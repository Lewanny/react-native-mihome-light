//
//  KMGroupContinueVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupContinueVM.h"

@implementation KMGroupContinueVM

- (instancetype)init
{
    self                        = [super init];
    if (self) {

    NSDate * curDate            = [NSDate date];

    NSDate * aDate              = [NSDate dateWithString:[[curDate stringWithFormat:@"yyyy-MM-dd"] stringByAppendingString:@" 00:00"] format:@"yyyy-MM-dd HH:mm"];

    _manualDay                  = aDate;
    _manualDateStart            = aDate;
    _manualDateEnd              = aDate;

    _autoDayStart               = aDate;
    _autoDayEnd                 = aDate;

    _autoDateStart              = aDate;
    _autoDateEnd                = aDate;

    _autoAMSatrt                = aDate;
    _autoAMEnd                  = aDate;

    _autoPMSatrt                = aDate;
    _autoPMEnd                  = aDate;

    _autoNightStart             = aDate;
    _autoNightEnd               = aDate;
    }
    return self;
}

/** 更新 时间 */
-(void)updateDate{

    NSDate *curDate             = [NSDate date];

    //手动续建 日期
    if ([_manualDay compare:curDate] == NSOrderedAscending) {//小于
    _manualDay                  = curDate;
    }
//    //自动续建 开始日期
//    if ([_autoDayStart compare:curDate] == NSOrderedAscending) {//小于
//    _autoDayStart               = curDate;
//    }
//    //自动续建 结束日期
//    if ([_autoDayEnd compare:_autoDayStart] == NSOrderedAscending) {//小于
//    _autoDayEnd                 = _autoDayStart;
//    }
}

/** 提交前 检查数据 */
-(BOOL)verifyData{
    BOOL ret = YES;
    if (_continueStyle == ContinueStyleManual) {
        if ([_manualDateEnd compare:_manualDateStart] == NSOrderedAscending) {
            [SVProgressHUD showInfoWithStatus:@"结束时间不能小于开始时间" Duration:1];
            ret = NO;
        }
    }else{
        if ([[self weekParamsString] isEqualToString:@"0000000"]) {
            [UIAlertView showMessage:@"请选择星期"];
            ret = NO;
        }
        if (_autoStyle == AutoStyleNormal){
            if ([_autoDateEnd compare:_autoDateStart] == NSOrderedAscending) {
                [SVProgressHUD showInfoWithStatus:@"结束时间不能小于开始时间" Duration:1];
                ret = NO;
            }
        }else{
    NSArray *arr = @[@[_autoAMSatrt, _autoAMEnd], @[_autoPMSatrt, _autoPMEnd], @[_autoNightStart, _autoNightEnd]];
            for (NSArray *a in arr) {
                if ([a.lastObject compare:a.firstObject] == NSOrderedAscending) {
                    [SVProgressHUD showInfoWithStatus:@"结束时间不能小于开始时间" Duration:1];
                    ret = NO;
                    break;
                }
            }
        }
    }
    return ret;
}

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //加载续建信息
    _autoInfoCommand            = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi groupTimeInfoWithGroupID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple             = x;
    NSArray *entrySet           = tuple.first;
    NSArray *timeInfos          = [NSArray modelArrayWithClass:[KMTimeSectionModel class] json:entrySet];

            for (KMTimeSectionModel *info in timeInfos) {
                NSDate *start               = [NSDate dateWithString:info.startTime format:@"HH:mm"] ? [NSDate dateWithString:info.startTime format:@"HH:mm"] :[NSDate date];
                NSDate *end                 = [NSDate dateWithString:info.endTime format:@"HH:mm"] ? [NSDate dateWithString:info.endTime format:@"HH:mm"] : [NSDate date];
                            if (info.mode == 0) {
                self.autoDateStart          = start;
                self.autoDateEnd            = end;
                            }else if (info.mode == 1){
                self.autoAMSatrt            = start;
                self.autoAMEnd              = end;
                            }else if (info.mode == 2){
                self.autoPMSatrt            = start;
                self.autoPMEnd              = end;
                            }else if (info.mode == 3){
                self.autoNightStart         = start;
                self.autoNightEnd           = end;
                            }
                        }
                self.timeSections           = timeInfos;
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //还是加载续建信息
    _autoTimeInfoCommand        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi groupAutoTimeInfoWithGroupID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple             = x;
    NSDictionary *entry         = [tuple.first firstObject];
    NSString *startWaitTime     = [entry objectForKey:@"startWaitTime"];
    NSString *endWaitTime       = [entry objectForKey:@"endWaitTime"];
    NSString *untilEndTime      = [entry objectForKey:@"untilEndTime"];
    NSString *untilStartTime    = [entry objectForKey:@"untilStartTime"];
    NSInteger untilMode         = [[entry objectForKey:@"untilMode"] integerValue];
    NSString *weekDate          = [entry objectForKey:@"weekDate"];

            //赋值手动续建参数
    self.manualDay              = [NSDate dateWithString:startWaitTime format:@"yyyy-MM-dd HH:mm"];
    self.manualDateStart        = [NSDate dateWithString:startWaitTime format:@"yyyy-MM-dd HH:mm"];
    self.manualDateEnd          = [NSDate dateWithString:endWaitTime format:@"yyyy-MM-dd HH:mm"];

            //自动续建 日期
    self.autoDayStart           = [NSDate dateWithString:untilStartTime format:@"yyyy-MM-dd"];
    self.autoDayEnd             = [NSDate dateWithString:untilEndTime format:@"yyyy-MM-dd"];

            //自动续建 模式
            if (untilMode == 1) {
    self.autoStyle              = AutoStyleNormal;
            }else if (untilMode == 2){
    self.autoStyle              = AutoStyleSection;
            }
            //星期赋值
            if (weekDate.length == 7) {
    KMWeek week                 = 0;
    for (NSUInteger i           = 0; i < weekDate.length; i++) {
    NSString *aDay              = [weekDate substringWithRange:NSMakeRange(i, 1)];
                    if ([aDay integerValue] == 1) {
    KMWeek aWeek                = 1 << i;
                        //增加
    week                        = week | aWeek;
                    }
                }
    self.weeks                  = week;
            }
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //手动续建
    _manualCommit               = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi editGroupWaitTimeWithData:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //自动续建提交
    _autoCommit                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {

    NSString *untilstarttime    = [self.autoDayStart stringWithFormat:@"yyyy-MM-dd"];
    NSString *untilendtime      = [self.autoDayEnd stringWithFormat:@"yyyy-MM-dd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:input forKey:kGroupId];
        [params setObject:untilstarttime ? untilstarttime : @"" forKey:@"untilstarttime"];
        [params setObject:untilendtime ? untilendtime : nil forKey:@"untilendtime"];
        [params setObject:self.autoStyle == AutoStyleNormal ? @"1" : @"2" forKey:@"untilmode"];
        [params setObject:[self weekParamsString] forKey:@"weekDate"];
        [params setObject:[self timeParamsWithGroupID:input] forKey:@"tim"];

        return [[[KM_NetworkApi editAutoGroupTimeWithData:params] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

}


-(NSString *)weekParamsString{
    NSString *week              = @"";
    for (NSInteger i            = 0; i < 7 ; i ++ ) {
    KMWeek aWeek                = 1 << i;
        //包含
        if (self.weeks & aWeek ){
    week                        = [week stringByAppendingString:@"1"];
        }else{
    week                        = [week stringByAppendingString:@"0"];
        }
    }
    return week;
}

-(NSArray *)timeParamsWithGroupID:(NSString *)groupID{
    if (_autoStyle == AutoStyleNormal) {
    KMTimeSectionModel *model   = [KMTimeSectionModel new];
    model.groupId               = groupID;
    model.mode                  = 0;
    model.startTime             = [self.autoDateStart stringWithFormat:@"HH:mm"];
    model.endTime               = [self.autoDateEnd stringWithFormat:@"HH:mm"];
    for (KMTimeSectionModel *obj in self.timeSections) {
        if (obj.mode == model.mode) {
            model.ID  = obj.ID;
            break;
        }
    }
        return @[[model modelToJSONObject]];
    }

    NSMutableArray *arrM        = [NSMutableArray array];
    for (int i                  = 0 ; i < 3; i ++) {
    KMTimeSectionModel *model   = [KMTimeSectionModel new];
    model.groupId               = groupID;
    model.mode                  = i + 1;
        for (KMTimeSectionModel *obj in self.timeSections) {
            if (obj.mode == model.mode) {
                model.ID  = obj.ID;
                break;
            }
        }
        if (i == 0) {
    model.startTime             = [self.autoAMSatrt stringWithFormat:@"HH:mm"];
    model.endTime               = [self.autoAMEnd stringWithFormat:@"HH:m"];
        }else if (i == 1){
    model.startTime             = [self.autoPMSatrt stringWithFormat:@"HH:m"];
    model.endTime               = [self.autoPMEnd stringWithFormat:@"HH:m"];
        }else if (i == 2){
    model.startTime             = [self.autoNightStart stringWithFormat:@"HH:m"];
    model.endTime               = [self.autoNightEnd stringWithFormat:@"HH:m"];
        }
        [arrM addObject:[model modelToJSONObject]];
    }
    return arrM;
}

@end
