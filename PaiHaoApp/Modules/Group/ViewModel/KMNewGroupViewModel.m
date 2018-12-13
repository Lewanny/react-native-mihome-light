//
//  KMNewGroupViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMNewGroupViewModel.h"
#import "KMAddressPicker.h"
#import "KMMerchantTypeModel.h"
#import <ActionSheetPicker_3_0/ActionSheetPicker.h>
#import "KMInputInfoController.h"
#import "KMUploadImageTool.h"
@implementation KMNewGroupViewModel

-(instancetype)initWithGroupID:(NSString *)groupID{
    if (self                                     = [super init]) {
    _groupID                                     = groupID;
        if ([self isNewBuiltGroup]) {
    _groupNew                                    = [KMNewGroupModel new];
        }
    }
    return self;
}

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //加载原来的队列信息
    _infoCommand                                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi originalGroupInfoWithID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple                              = x;
    NSArray *entrySet                            = tuple.first;
    self.origin                                  = [KMOriginalGroupInfo modelWithJSON:entrySet.firstObject];
    self.isBatch = self.origin.singleNumber > 0 ? YES : NO;
    self.isLimit = self.origin.groupCount > 0 ? YES : NO;
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //提交新队列
    _addNewCommand                               = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       @strongify(self)
    NSDictionary *params                         = [self.groupNew modelToJSONObject];
        return [[[KM_NetworkApi addNewGroupWithData:params] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"提交失败" Duration:1];
        }];
    }];
    //编辑队列
    _editGroupCommand                            = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
    NSDictionary *params                         = [self.origin modelToJSONObject];
    NSDictionary *finalParams                    = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditGroupInfoEx]
                                                                 paramsSet:@[]
                                                                  entrySet:@[params]];
    NSString *str                                = [finalParams objectForKey:@"json"];
    str                                          = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *body                                 = [str dataUsingEncoding:kCFStringEncodingUTF8];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

    NSString *requestUrl                         = [KM_NetworkApi hostUrl];
    AFURLSessionManager *manager                 = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *request                 = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestUrl parameters:nil error:nil];
    request.timeoutInterval                      = 30;
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            // 设置body
            [request setHTTPBody:body];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes    = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/plain",
                                                         nil];
    manager.responseSerializer                   = responseSerializer;

            [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                KMLog(@"%@",responseObject);
                if (!error) {
    NSDictionary *dict                           = [responseObject jsonValueDecoded];
    NSNumber *status                             = [dict objectForKey:kStatus];
                    if ([status intValue] && [status intValue] != 3) {
                        //有错误
                        [SVProgressHUD showErrorWithStatus:@"提交失败" Duration:1];
                    }else{
                        //没错误
                        [subscriber sendNext:nil];
                        [SVProgressHUD showSuccessWithStatus:@"提交成功" Duration:1];
                    }
                }else{
                   [SVProgressHUD showErrorWithStatus:@"提交失败" Duration:1];
                }
                [subscriber sendCompleted];
            }] resume];

            return nil;
        }];
    }];
}

#pragma mark - 编辑队列数据
/** 点击编辑 */
-(void)didSelectIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1://编辑 省市区
            [self editAdress];
            break;
        case 3://编辑 行业类型
            [self editCategoryType];
            break;
        case 4://编辑 排队日期
            [self editQueueDay];
            break;
//        case 5://编辑开始、结束时间
//            [self editStartEndTime];
//            break;
        case 11://编辑 队列图片
            [self editPhoto];
            break;
        case 12://编辑 简介
            [self editIntro];
            break;
        default:
            break;
    }
}

/** 直接编辑 */
-(void)editWithData:(id)data IndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 5) {
    BOOL isTapStart = [data integerValue];
        isTapStart ? [self editStartTime] : [self editEndTime];
    }


    //编辑队列
    if (![self isNewBuiltGroup]) {
        switch (indexPath.row) {
            case 0://名称
    _origin.groupName                            = data;
                break;
            case 2://详细地址
    _origin.groupAddress                         = data;
                break;
            case 6://平均排队时间
    _origin.averagetime                          = [data integerValue];
                break;
            case 7://关键字
    _origin.keyword                              = data;
                break;
            case 8://远程排队
    _origin.isAllowRemote = [data boolValue] ? 0 : 1;
                break;
            case 9://批量
                if ([data isKindOfClass:[NSString class]]) {
                    _origin.singleNumber = [data integerValue];
                }else if ([data isKindOfClass:[NSNumber class]]){
                    
                    BOOL isBatch = [data boolValue];
                    if (!isBatch) {
                        _origin.singleNumber = 0;
                    }
                    _isBatch = isBatch;
                }
                break;
            case 10://限制
                if ([data isKindOfClass:[NSString class]]) {
                    _origin.groupCount = [data integerValue];
                }else if ([data isKindOfClass:[NSNumber class]]){
                    BOOL isLimit = [data boolValue];
                    if (!isLimit) {
                        _origin.groupCount = 0;
                    }
                    _isLimit = isLimit;
                }
                break;
            default:
                break;
        }
    }else{
    //新建队列
        switch (indexPath.row) {
            case 0://名称
    _groupNew.groupName                          = data;
                break;
            case 2://详细地址
    _groupNew.groupAddress                       = data;
                break;
            case 6://平均排队时间
    _groupNew.averagetime                        = data;
                break;
            case 7://关键字
    _groupNew.keyword                            = data;
                break;
            case 8://远程排队
    _groupNew.isAllowRemote                      = [data boolValue] ? 0 : 1;
                break;
            case 9://批量
                if ([data isKindOfClass:[NSString class]]) {
    _groupNew.singleNumber                       = [data integerValue];
                }else if ([data isKindOfClass:[NSNumber class]]){
    _isBatch                                     = [data boolValue];
                }
                break;
            case 10://限制
                if ([data isKindOfClass:[NSString class]]) {
    _groupNew.groupCount                         = [data integerValue];
                }else if ([data isKindOfClass:[NSNumber class]]){
    _isLimit                                     = [data boolValue];
                }
                break;
            default:
                break;
        }
    }
}
/** 编辑省市区地址 */
-(void)editAdress{
    @weakify(self)
    [KMAddressPicker showWithCallBack:^(NSString *province, NSString *city, NSString *area) {
        @strongify(self)
        if ([self isNewBuiltGroup]) {
    self.groupNew.groupProvince                  = province;
    self.groupNew.groupCity                      = city;
    self.groupNew.groupArea                      = area ? area : @"";
        }else{
    self.origin.groupProvince                    = province;
    self.origin.groupCity                        = city;
    self.origin.groupArea                        = area ? area : @"";
        }
        [self.reloadSubject sendNext:nil];
    }];
}
/** 编辑行业类别 */
-(void)editCategoryType{

    NSArray *categorys                           = [KMTool getCategoryType];
    NSMutableArray *arrM                         = [NSMutableArray array];
    __block NSInteger selection                  = 0;
    @weakify(self)
    [categorys enumerateObjectsUsingBlock:^(KMMerchantTypeModel *info, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        [arrM addObject:info.typeName];
        if ([self isNewBuiltGroup]) {
            if (self.groupNew.industrytype.length && [self.groupNew.industrytype isEqualToString:info.ID]) {
    selection                                    = idx;
            }
        }else{
            if (self.origin.industrytype.length && [self.origin.industrytype isEqualToString:info.ID]) {
    selection                                    = idx;
            }
        }
    }];
    [ActionSheetStringPicker showPickerWithTitle:@"选择行业类型"
                                            rows:arrM
                                initialSelection:selection
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
           if ([self isNewBuiltGroup]) {
    self.groupNew.industrytype                   = [KMTool categoryIDWithName:selectedValue];
           }else{
    self.origin.industrytype                     = [KMTool categoryIDWithName:selectedValue];
           }
        [self.reloadSubject sendNext:nil];
    } cancelBlock:nil origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
}
/** 编辑排号日期 */
-(void)editQueueDay{
    if ([self isNewBuiltGroup]) {
        //当前时间
    NSDate *curDate                              = [NSDate date];
        //初始选中时间
    NSDate *sDate                                = _groupNew.startWaitTime.length ? [NSDate dateWithString:_groupNew.startWaitTime format:@"yyyy-MM-dd HH:mm"] : curDate;
        @weakify(self)
    ActionSheetDatePicker *picker                = [[ActionSheetDatePicker alloc]initWithTitle:@"选择排号日期" datePickerMode:UIDatePickerModeDate selectedDate:sDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            @strongify(self)
            //开始时间
    NSDate *sDate                                = self.groupNew.startWaitTime.length ? [NSDate dateWithString:_groupNew.startWaitTime format:@"yyyy-MM-dd HH:mm"] : nil;
            //结束时间
    NSDate *eDate                                = self.groupNew.endWaitTime.length ? [NSDate dateWithString:_groupNew.endWaitTime format:@"yyyy-MM-dd HH:mm"] : nil;
            //选中时间
    NSDate *aDate                                = selectedDate;
            //设置开始时间
    self.groupNew.startWaitTime                  = [[aDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:sDate ? [sDate stringWithFormat:@" HH:mm"] : @" 00:00"];
            //设置结束时间
    self.groupNew.endWaitTime                    = [[aDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:eDate ? [eDate stringWithFormat:@" HH:mm"] : @" 00:00"];
            //刷新
            [self.reloadSubject sendNext:nil];
        } cancelBlock:nil origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
    picker.locale                                = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    picker.minimumDate                           = curDate;
    picker.maximumDate                           = [curDate dateByAddingWeeks:1];
        [picker showActionSheetPicker];
    }else{
        //当前时间
    NSDate *curDate                              = [NSDate date];
        //初始选中时间
    NSDate *sDate                                = _origin.startWaitTime.length ? [NSDate dateWithString:_origin.startWaitTime format:@"yyyy-MM-dd HH:mm"] : curDate;
        @weakify(self)
    ActionSheetDatePicker *picker                = [[ActionSheetDatePicker alloc]initWithTitle:@"选择排号日期" datePickerMode:UIDatePickerModeDate selectedDate:sDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            @strongify(self)
            //开始时间
    NSDate *sDate                                = self.origin.startWaitTime.length ? [NSDate dateWithString:self.origin.startWaitTime format:@"yyyy-MM-dd HH:mm"] : nil;
            //结束时间
    NSDate *eDate                                = self.origin.endWaitTime.length ? [NSDate dateWithString:self.origin.endWaitTime format:@"yyyy-MM-dd HH:mm"] : nil;
            //选中时间
    NSDate *aDate                                = selectedDate;
            //设置开始时间
    self.origin.startWaitTime                    = [[aDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:sDate ? [sDate stringWithFormat:@" HH:mm"] : @" 00:00"];
            //设置结束时间
    self.origin.endWaitTime                      = [[aDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:eDate ? [eDate stringWithFormat:@" HH:mm"] : @" 00:00"];
            //刷新
            [self.reloadSubject sendNext:nil];
        } cancelBlock:nil origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
    picker.locale                                = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    picker.minimumDate                           = curDate;
    picker.maximumDate                           = [curDate dateByAddingWeeks:1];
        [picker showActionSheetPicker];
    }
}
/** 编辑开始时间 */
-(void)editStartTime{
    if ([self isNewBuiltGroup]) {
    NSDate *cDate                                = [NSDate date];
    NSDate *sDate                                = _groupNew.startWaitTime.length ? [NSDate dateWithString:_groupNew.startWaitTime format:@"yyyy-MM-dd HH:mm"] : [NSDate dateWithString:[[cDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:@" 00:00"] format:@"yyyy-MM-dd HH:mm"];

        //选择开始时间
        @weakify(self)
    ActionSheetDatePicker *sPicker               = [[ActionSheetDatePicker alloc]initWithTitle:@"选择开始时间" datePickerMode:UIDatePickerModeTime selectedDate:sDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            @strongify(self)
    self.groupNew.startWaitTime                  = [selectedDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            [self.reloadSubject sendNext:nil];
        } cancelBlock:nil origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
    sPicker.locale                               = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [sPicker showActionSheetPicker];
    }else{
    NSDate *cDate                                = [NSDate date];
    NSDate *sDate                                = _origin.startWaitTime.length ? [NSDate dateWithString:_origin.startWaitTime format:@"yyyy-MM-dd HH:mm"] : [NSDate dateWithString:[[cDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:@" 00:00"] format:@"yyyy-MM-dd HH:mm"];

        //选择开始时间
        @weakify(self)
    ActionSheetDatePicker *sPicker               = [[ActionSheetDatePicker alloc]initWithTitle:@"选择开始时间" datePickerMode:UIDatePickerModeTime selectedDate:sDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            @strongify(self)
    self.origin.startWaitTime                    = [selectedDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            [self.reloadSubject sendNext:nil];
        } cancelBlock:nil origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
    sPicker.locale                               = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [sPicker showActionSheetPicker];
    }
}
/** 编辑结束时间 */
-(void)editEndTime{
    if ([self isNewBuiltGroup]) {
        NSDate *cDate = [NSDate date];
        NSDate *eDate = _groupNew.endWaitTime.length ? [NSDate dateWithString:_groupNew.endWaitTime format:@"yyyy-MM-dd HH:mm"] : [NSDate dateWithString:[[cDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:@" 00:00"] format:@"yyyy-MM-dd HH:mm"];
        //选择结束时间
        @weakify(self)
    ActionSheetDatePicker *ePicker = [[ActionSheetDatePicker alloc]initWithTitle:@"选择结束时间" datePickerMode:UIDatePickerModeTime selectedDate:eDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            @strongify(self)
            self.groupNew.endWaitTime = [selectedDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            [self.reloadSubject sendNext:nil];
        } cancelBlock:nil origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
        ePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [ePicker showActionSheetPicker];
    }else{
        NSDate *cDate = [NSDate date];
        NSDate *eDate = _origin.endWaitTime.length ? [NSDate dateWithString:_origin.endWaitTime format:@"yyyy-MM-dd HH:mm"] : [NSDate dateWithString:[[cDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:@" 00:00"] format:@"yyyy-MM-dd HH:mm"];
        //选择结束时间
        @weakify(self)
        ActionSheetDatePicker *ePicker = [[ActionSheetDatePicker alloc]initWithTitle:@"选择结束时间" 
                                                                      datePickerMode:UIDatePickerModeTime selectedDate:eDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            @strongify(self)
            self.origin.endWaitTime                      = [selectedDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            [self.reloadSubject sendNext:nil];
        } cancelBlock:nil origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
            ePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
            [ePicker showActionSheetPicker];
    }
}

/** 编辑简介 */
-(void)editIntro{
    KMInputInfoController *input                 = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMInputUserInfoIdentifier);
    input.type                                   = InputInfoTypeCompele;
    input.titleStr                               = @"简介";
    input.placeholder                            = @"请输入简介";
    input.needChangeText                         = [self isNewBuiltGroup] ? _groupNew.introduction : _origin.introduction;
    input.keyboardType                           = UIKeyboardTypeDefault;
    @weakify(self)
    input.compele                                = ^(NSString *text) {
        @strongify(self)
        if ([self isNewBuiltGroup]) {
    self.groupNew.introduction                   = text;
        }else{
    self.origin.introduction                     = text;
        }
        [self.reloadSubject sendNext:nil];
    };
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:input animated:YES];
}
/** 编辑图片 */
-(void)editPhoto{
    @weakify(self)
    [KMUploadImageTool uploadWithSuccess:^(UIImage *uploadImage, NSString *imageUrl) {
        @strongify(self)
        if ([self isNewBuiltGroup]) {
    self.groupNew.photo                          = imageUrl;
        }else{
    self.origin.photo                            = imageUrl;
        }
        [self.reloadSubject sendNext:nil];
    } Failure:^(NSError *error) {

    }];
}


#pragma mark - DataSource
-(NSString *)rightTextWithIndexPath:(NSIndexPath *)indexPath{

    NSString *text = @"";
    //修改队列
    if (![self isNewBuiltGroup]) {
        //修改队列 赋值
        switch (indexPath.row) {
            case 0://名称
                text = _origin.groupName;
                break;
            case 1://省市区
                text = [[_origin.groupProvince stringByAppendingString:_origin.groupCity.length ? NSStringFormat(@"、%@",_origin.groupCity) : @""] stringByAppendingString:_origin.groupArea.length ? NSStringFormat(@"、%@",_origin.groupArea) : @""];
                break;
            case 2://详细地址
                text = _origin.groupAddress;
                break;
            case 3://行业类型
                text = [KMTool categoryNameWithID:_origin.industrytype];
                break;
            case 4://日期
                text = [[NSDate dateWithString:_origin.startWaitTime format:@"yyyy-MM-dd HH:mm"] stringWithFormat:@"yyyy-MM-dd"];
                break;
            case 5://开始时间、结束时间
                text = _origin.startWaitTime || _origin.endWaitTime ? NSStringFormat(@"%@ － %@", _origin.startWaitTime.length ? [[NSDate dateWithString:_origin.startWaitTime format:@"yyyy-MM-dd HH:mm"] stringWithFormat:@"HH:mm"] : @"开始时间", _origin.endWaitTime.length ? [[NSDate dateWithString:_origin.endWaitTime format:@"yyyy-MM-dd HH:mm"] stringWithFormat:@"HH:mm"] : @"结束时间") : @"";
                break;
            case 6://评均排队时间
                text = NSStringFormat(@"%ld",_origin.averagetime);
                break;
            case 7://关键字
                text = _origin.keyword;
                break;
            case 9://批量
                text = [self switchValueWithIndexPath:indexPath] ? NSStringFormat(@"%ld",_origin.singleNumber) : @"";
                break;
            case 10://限制
                text = [self switchValueWithIndexPath:indexPath] ? NSStringFormat(@"%ld",_origin.groupCount) : @"";
                break;
            case 12://简介
                text = _origin.introduction;
                break;
            default:
                break;
        }
        return text;
    }
    //新建队列 赋值
    switch (indexPath.row) {
        case 0://名称
            text = _groupNew.groupName;
            break;
        case 1://省市区
            text = [[_groupNew.groupProvince stringByAppendingString:_groupNew.groupCity.length ? NSStringFormat(@"、%@",_groupNew.groupCity) : @""] stringByAppendingString:_groupNew.groupArea.length ? NSStringFormat(@"、%@",_groupNew.groupArea) : @""];
            break;
        case 2://详细地址
            text = _groupNew.groupAddress;
            break;
        case 3://行业类型
            text = [KMTool categoryNameWithID:_groupNew.industrytype];
            break;
        case 4://日期
            text = [[NSDate dateWithString:_groupNew.startWaitTime format:@"yyyy-MM-dd HH:mm"] stringWithFormat:@"yyyy-MM-dd"];
            break;
        case 5://开始时间、结束时间
            text = _groupNew.startWaitTime || _groupNew.endWaitTime ? NSStringFormat(@"%@ － %@", _groupNew.startWaitTime.length ? [[NSDate dateWithString:_groupNew.startWaitTime format:@"yyyy-MM-dd HH:mm"] stringWithFormat:@"HH:mm"] : @"开始时间", _groupNew.endWaitTime.length ? [[NSDate dateWithString:_groupNew.endWaitTime format:@"yyyy-MM-dd HH:mm"] stringWithFormat:@"HH:mm"] : @"结束时间") : @"";
            break;
        case 6://评均排队时间
            text = _groupNew.averagetime;
            break;
        case 7://关键字
            text = _groupNew.keyword;
            break;
        case 9://批量
            text = [self switchValueWithIndexPath:indexPath] ? NSStringFormat(@"%ld",_groupNew.singleNumber) : @"";
            break;
        case 10://限制
            text = [self switchValueWithIndexPath:indexPath] ? NSStringFormat(@"%ld",_groupNew.groupCount) : @"";
            break;
        case 12://简介
            text = _groupNew.introduction;
            break;
        default:
            break;
    }
    return text;
}

-(BOOL)switchValueWithIndexPath:(NSIndexPath *)indexPath{
    BOOL ret                                     = NO;
    //队列编辑
    if (![self isNewBuiltGroup]) {
        switch (indexPath.row) {
            case 8:
                ret = _origin.isAllowRemote == 0 ? YES : NO;
            break;
            case 9:
                ret = _isBatch;
            break;
            case 10:
                ret = _isLimit;
                break;
            default:
                break;
        }
        return ret;
    }
    //新建队列
    switch (indexPath.row) {
        case 8:
    ret                                          = _groupNew.isAllowRemote == 0 ? YES : NO;
            break;
        case 9:
    ret                                          = _isBatch;
            break;
        case 10:
    ret                                          = _isLimit;
            break;
        default:
            break;
    }
    return ret;
}

-(NewGroupCellStyle)cellStyleWithIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0://只有输入
        case 2:
        case 6:
        case 7:
            return NewGroupCellStyleTextField;
            break;
        case 1:
        case 3:
        case 4:
        case 5:
        case 12://文字 + 箭头
            return NewGroupCellStyleArrow | NewGroupCellStyleLabel;
            break;
        case 8://开关
            return NewGroupCellStyleSwitch;
            break;
        case 9://输入 + 开关
        case 10:
            return NewGroupCellStyleSwitch | NewGroupCellStyleTextField;
            break;
        case 11://箭头 + 图片
            return NewGroupCellStyleArrow | NewGroupCellStylePhoto;
            break;
        default:
            return NewGroupCellStyleArrow | NewGroupCellStyleLabel;
            break;
    }
}
-(UIKeyboardType)keyboardTypeWithIndexPath:(NSIndexPath *)indexPath{
    UIKeyboardType k                             = UIKeyboardTypeDefault;
    switch (indexPath.row) {
        case 6:
        case 9:
        case 10:
    k                                            = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
    return k;
}

-(NSArray *)leftTextArr{
    return @[@"队列名称",
             @"区域",
             @"详细地址",
             @"行业类别",
             @"排号日期",
             @"开始时间、结束时间",
             @"人均排队时间",
             @"关键字",
             @"远程排队",
             @"批量叫号",
             @"限定人数",
             @"照片",
             @"简介"];
}
-(NSArray *)placeHolderArr{
    return @[@"请输入队列名称",
             @"请选择区域",
             @"请输入详细地址",
             @"行业类别",
             @"排号日期",
             @"开始时间 － 结束时间",
             @"请输入分钟 1到60之间",
             @"输入关键字",
             @"",
             @"请输入每批人数",
             @"请输入限定人数",
             @"",
             @"请输入简介"
             ];
}

#pragma mark - Private Method -

-(BOOL)verifyNewGroupParams{
    BOOL ret                                     = YES;
    CLLocation *location                         = [[KMLocationManager shareInstance] myLocation];
    NSString *alertText                          = nil;
    _groupNew.userId                             = KMUserDefault.userID;
    _groupNew.creater                            = KMUserDefault.userName;
    _groupNew.phone                              = KMUserDefault.telephone;
    //没有定位
    if (location) {
    _groupNew.longitude                          = NSStringFormat(@"%f",location.coordinate.longitude);
    _groupNew.latitude                           = NSStringFormat(@"%f",location.coordinate.latitude);
    }else{
    ret                                          = NO;
    alertText                                    = @"没有定位到您的位置,请在设置中开启应用定位权限";
    }
    //队列名称
    if (ret && _groupNew.groupName.length == 0) {
    ret                                          = NO;
    alertText                                    = @"请填写队列名称";
    }
    //队列区域
    if (ret && !_groupNew.groupProvince.length) {
    ret                                          = NO;
    alertText                                    = @"请选择队列区域";
    }
    //详细地址
    if (ret && !_groupNew.groupAddress.length) {
    ret                                          = NO;
    alertText                                    = @"请填写详细地址";
    }
    //行业类别
    if (ret && !_groupNew.industrytype.length) {
    ret                                          = NO;
    alertText                                    = @"请选择行业类别";
    }
    //排号时间
    if (ret && !(_groupNew.startWaitTime.length && _groupNew.endWaitTime.length)) {
    ret                                          = NO;
    alertText                                    = @"请选择排号开始、结束时间";
    }
    //人均排队时间
    if (ret && !_groupNew.averagetime.length) {
    ret                                          = NO;
    alertText                                    = @"请填写人均排队时间";
    }
    //关键字
    if (ret && !_groupNew.keyword.length) {
    ret                                          = NO;
    alertText                                    = @"请填写关键字";
    }
    //队列图片
    if (ret && !_groupNew.photo.length) {
    ret                                          = NO;
    alertText                                    = @"请上传队列图片";
    }
    //简介
    if (ret && !_groupNew.introduction.length) {
    ret                                          = NO;
    alertText                                    = @"请填写队列简介";
    }
    if (!ret && alertText) {
        [SVProgressHUD showInfoWithStatus:alertText Duration:1];
    }
    return ret;
}

-(BOOL)verifyEditGroupParams{
    BOOL ret                                     = YES;
    NSString *alertText                          = nil;
    //队列名称
    if (ret && _origin.groupName.length == 0) {
    ret                                          = NO;
    alertText                                    = @"请填写队列名称";
    }
    //队列区域
    if (ret && !_origin.groupProvince.length) {
    ret                                          = NO;
    alertText                                    = @"请选择队列区域";
    }
    //详细地址
    if (ret && !_origin.groupAddress.length) {
    ret                                          = NO;
    alertText                                    = @"请填写详细地址";
    }
    //行业类别
    if (ret && !_origin.industrytype.length) {
    ret                                          = NO;
    alertText                                    = @"请选择行业类别";
    }
    //排号时间
    if (ret && !(_origin.startWaitTime.length && _origin.endWaitTime.length)) {
    ret                                          = NO;
    alertText                                    = @"请选择排号开始、结束时间";
    }
    //关键字
    if (ret && !_origin.keyword.length) {
    ret                                          = NO;
    alertText                                    = @"请填写关键字";
    }
    //队列图片
    if (ret && !_origin.photo.length) {
    ret                                          = NO;
    alertText                                    = @"请上传队列图片";
    }
    //简介
    if (ret && !_origin.introduction.length) {
    ret                                          = NO;
    alertText                                    = @"请填写队列简介";
    }
    if (!ret && alertText) {
        [SVProgressHUD showInfoWithStatus:alertText Duration:1];
    }
    return ret;
}

/** 判断是否新建队列 */
-(BOOL)isNewBuiltGroup{
    return _groupID.length == 0;
}

@end
