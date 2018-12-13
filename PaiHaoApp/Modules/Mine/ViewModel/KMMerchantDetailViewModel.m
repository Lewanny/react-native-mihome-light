//
//  KMMerchantDetailViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/27.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMerchantDetailViewModel.h"

@implementation KMMerchantDetailViewModel


#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //商户详情
    _businessUserInfo      = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi businessUserInfo] doNext:^(id  _Nullable x) {
           @strongify(self)
    RACTuple *tuple        = (RACTuple *)x;
    NSArray *entrySet      = tuple.first;
    self.user              = [KMBusinessUserModel modelWithJSON:entrySet.firstObject];
            if (self.user == nil) {
    self.user              = [KMBusinessUserModel new];
                
            }
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //编辑头像
    _editHeadPortrait      = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi editPictrue:input] doNext:^(id  _Nullable x) {
            @strongify(self)
    self.user.picture      = input;
            [self.reloadSubject sendNext:nil];
            [SVProgressHUD showSuccessWithStatus:@"修改成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //检查用户名是否已被使用
    _checkUserName         = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi checkNicknameStatus:input] map:^id _Nullable(id  _Nullable value) {
    NSArray *paramsSet     = ((RACTuple *)value).second;
    NSString *result       = [KMTool valueForName:kResult InArr:paramsSet];
    BOOL ret               = NO;
            if ([result isEqualToString:@"0"]) {
                //已经被占用
                ret = NO;
            }else if ([result isEqualToString:@"1"]){
                //还没被占用
                ret = YES;
            }
            return @(ret);
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //编辑用户名
    _editUserName = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editUserName:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //修改商户名称
    _editBusinessName = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editBusinessName:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //编辑地址
    _editAddr = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editAddr:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑邮箱
    _editMail = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editMail:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑商家简介
    _editSynopsis          = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editSynopsis:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑区域
    _editArea = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACTuple *t = input;
        NSString *province = t.first;
        NSString *city = t.second;
        NSString *area = t.third;
        return [[[KM_NetworkApi editAreaWithProvince:province City:city Area:area] doNext:^(id  _Nullable x) {
            @strongify(self)
            [SVProgressHUD showSuccessWithStatus:@"修改成功" Duration:1];
            self.user.province = province;
            self.user.city = city;
            self.user.area = area;
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑电话
    _editTelephone = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editTelephoneWithTel:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑行业
    _editMerchant = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi editMerchantWithID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            [SVProgressHUD showSuccessWithStatus:@"修改成功" Duration:1];
            self.user.merchantid = input;
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
}


/** 要更改的文字 */
-(NSString *)needCompeleTextWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return self.user.username;
                break;
            case 2:
                return self.user.phone;
                break;
            case 3:
                return self.user.weixin;
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                return self.user.businessname;
                break;
            case 1:
                return [KMTool categoryNameWithID:self.user.merchantid];
                break;
            case 2:
                return NSStringFormat(@"%@ %@ %@",self.user.province, self.user.city, self.user.area);
                break;
            case 3:
                return self.user.address;
                break;
            case 4:
                return self.user.telephone;
                break;
            case 5:
                return self.user.mail;
                break;
            case 6:
                return self.user.synopsis;
                break;
            default:
                break;
        }
    }
    return nil;
}
/** 键盘类型 */
-(UIKeyboardType)keyboardTypeWithIndexPath:(NSIndexPath *)indexPath{
    NSString *leftText     = [[self.leftTextArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([leftText isEqualToString:@"手机"]) {
        return UIKeyboardTypeNumberPad;
    }else if ([leftText isEqualToString:@"邮箱"]){
        return UIKeyboardTypeEmailAddress;
    }
    return UIKeyboardTypeDefault;
}


/** 发起网络请求更改 */
-(void)compeleText:(NSString *)text IndexPath:(NSIndexPath *)indexPath CallBack:(void (^)(void))callBack{
    @weakify(self)

    NSString *leftText     = [[self.leftTextArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if ([leftText isEqualToString:@"姓名"]) {
        //修改用户名  先检查有没有被使用
        [[_checkUserName execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if ([x boolValue]) {
                //姓名可以使用
                [[self.editUserName execute:text] subscribeNext:^(id  _Nullable x) {
                    //把用户名改掉
    self.user.username     = text;
                    callBack ? callBack() : nil;
                }];
            }else{
                //姓名已被占用
                [SVProgressHUD showInfoWithStatus:@"该用户名已被占用" Duration:1];
            }
        }];
    }else if ([leftText isEqualToString:@"手机"]){
        //修改手机号码 先验证是否为11位数字
        if (![text isMobilePhone]) {
            [SVProgressHUD showInfoWithStatus:@"请输入11位手机号码" Duration:1];
            return;
        }
        //再验证手机号码是否已被别人注册
        [[KMUserManager shareInstance] checkAccountRegisterStatus:text CallBack:^(BOOL ret) {
            @strongify(self)
            if (ret) {
                //可以修改
                [[self.editPhone execute:text] subscribeNext:^(id  _Nullable x) {
                    //修改成功 把手机号码改掉
    self.user.phone        = text;
                    callBack ? callBack() : nil;
                }];
            } else {
                //已被使用 不能改
                [SVProgressHUD showInfoWithStatus:@"该手机号码已被注册" Duration:1];
            }
        }];
    }else if ([leftText isEqualToString:@"商户名称"]){
        //修改商户名称
        [[_editBusinessName execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
    self.user.businessname = text;
            callBack ? callBack() : nil;
        }];
    }else if ([leftText isEqualToString:@"详细地址"]){
        //修改地址
        [[_editAddr execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
    self.user.address      = text;
            callBack ? callBack() : nil;
        }];
    }else if ([leftText isEqualToString:@"邮箱"]){
        //修改邮箱 先验证是否是邮箱
        if (![text isEmailAddress]) {
            [SVProgressHUD showInfoWithStatus:@"请输入邮箱地址" Duration:1];
            return;
        }
        //再进行修改邮箱
        [[_editMail execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
    self.user.mail         = text;
            callBack ? callBack() : nil;
        }];
    }else if ([leftText isEqualToString:@"商家简介"]){
        //修改商家简介
        [[_editSynopsis execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.user.synopsis = text;
            callBack ? callBack() : nil;
        }];
    }else if ([leftText isEqualToString:@"电话"]){
        //修改电话
        [[_editTelephone execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            self.user.telephone = text;
            callBack ? callBack() : nil;
        }];
    }
}


/** 左标题 */
-(NSArray *)leftTextArr{
    return @[
             @[@"姓名", @"头像", @"手机", @"微信号"],
             @[@"商户名称", @"行业类别", @"区域", @"详细地址", @"电话", @"邮箱", @"商家简介"]
            ];
}
/** 标题 */
-(NSArray *)titles{
    return [self leftTextArr];
}

@end
