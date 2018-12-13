//
//  KMUserDetailViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/27.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserDetailViewModel.h"

@implementation KMUserDetailViewModel

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //获取用户详情
    _userDetailCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi requestUserDeatil] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple              = x;
    NSArray *entrySet            = tuple.first;
    self.userDetail              = [KMUserDetailModel modelWithJSON:entrySet.firstObject];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"获取用户资料失败"];
        }];
    }];
    //检查用户名是否已被使用
    _checkUserName               = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi checkNicknameStatus:input] map:^id _Nullable(id  _Nullable value) {
    NSArray *paramsSet           = ((RACTuple *)value).second;
    NSString *result             = [KMTool valueForName:kResult InArr:paramsSet];
    BOOL ret                     = NO;
            if ([result isEqualToString:@"0"]) {
                //已经被占用
    ret                          = NO;
            }else if ([result isEqualToString:@"1"]){
                //还没被占用
    ret                          = YES;
            }
            return @(ret);
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //编辑用户名
    _editUserName                = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editUserName:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //编辑头像
    _editHeadPortrait            = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi editHeadPortrait:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            self.userDetail.headportrait = input;
            [self.reloadSubject sendNext:nil];
            [SVProgressHUD showSuccessWithStatus:@"修改成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑电话号码
    _editPhone                   = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editPhone:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑邮箱
    _editMail                    = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editMail:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
    //编辑地址
    _editAddr                    = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi editAddr:input] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"修改失败" Duration:1];
        }];
    }];
}


/** 要更改的文字 */
-(NSString *)needCompeleTextWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return self.userDetail.username;
            break;
        case 1:
            return @"";
            break;
        case 2:
            return self.userDetail.phone;
            break;
        case 3:
            return self.userDetail.mail;
            break;
        case 4:
            return self.userDetail.weixin;
            break;
        case 5:
            return self.userDetail.address;
            break;
        default:
            return @"";
            break;
    }
}
/** 键盘类型 */
-(UIKeyboardType)keyboardTypeWithIndexPath:(NSIndexPath *)indexPath{
    NSString *leftText           = [self.leftTextArr objectAtIndex:indexPath.row];
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
    NSString *leftText           = [self.leftTextArr objectAtIndex:indexPath.row];
    if ([leftText isEqualToString:@"用户名"]) {
        //修改用户名  先检查有没有被使用
        [[_checkUserName execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if ([x boolValue]) {
                //姓名可以使用
                [[self.editUserName execute:text] subscribeNext:^(id  _Nullable x) {
                    //把用户名改掉
    self.userDetail.username     = text;
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
    self.userDetail.phone        = text;
                    callBack ? callBack() : nil;
                }];
            } else {
                //已被使用 不能改
                [SVProgressHUD showInfoWithStatus:@"该手机号码已被注册" Duration:1];
            }
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
    self.userDetail.mail         = text;
            callBack ? callBack() : nil;
        }];
    }else if ([leftText isEqualToString:@"我的地址"]){
        //修改地址
        [[_editAddr execute:text] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
    self.userDetail.address      = text;
            callBack ? callBack() : nil;
        }];
    }
}


/** 左标题 */
-(NSArray *)leftTextArr{
    return @[
             @"用户名",
             @"头像",
             @"手机",
             @"邮箱",
             @"微信号",
             @"我的地址"
             ];
}
/** 标题 */
-(NSArray *)titles{
    return [self leftTextArr];
}


@end
