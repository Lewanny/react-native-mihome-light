//
//  KMCallOfficerVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCallOfficerVM.h"

@implementation KMCallOfficerVM

#pragma mark - Privath Method -

-(NSAttributedString *)callerIDAttrStrWithInfo:(KMCallerInfo *)info{
    NSMutableAttributedString *s                                        = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"呼叫员ID: %@",info.loginName)];
    [s setFont:kFont32];
    [s setFont:kFont28 range:[s.string rangeOfString:info.loginName options:NSBackwardsSearch]];
    [s setColor:kFontColorDark];
    return s;
}
-(NSAttributedString *)callerNameAttrStrWithInfo:(KMCallerInfo *)info{
    NSMutableAttributedString *s                                        = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"姓名: %@",info.userName)];
    [s setFont:kFont32];
    [s setFont:kFont28 range:[s.string rangeOfString:info.userName options:NSBackwardsSearch]];
    [s setColor:kFontColorDarkGray];
    return s;
}
-(NSAttributedString *)callerPwdAttrStrWithInfo:(KMCallerInfo *)info{
    NSMutableAttributedString *s                                        = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"密码: %@",info.loginPwd)];
    [s setFont:kFont32];
    [s setFont:kFont28 range:[s.string rangeOfString:info.loginPwd options:NSBackwardsSearch]];
    [s setColor:kFontColorDarkGray];
    return s;
}

#pragma mark - BaseViewModelInterface -
-(void)km_bindNetWorkRequest{
    @weakify(self)
    _listCommand                                                        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       return [[[KM_NetworkApi callerList] doNext:^(id  _Nullable x) {
           @strongify(self)
    RACTuple * t                                                        = x;
    NSArray *entrySet                                                   = t.first;
    self.callerArr                                                      = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMCallerInfo class] json:entrySet]];
           [self.reloadSubject sendNext:nil];
       }] doError:^(NSError * _Nonnull error) {
           [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
       }];
    }];
    _deleCommand                                                        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    RACTuple * t                                                        = input;
    RACTupleUnpack(NSString * accounId, NSString * userId)              = t;
        return [[[KM_NetworkApi deleCallerWithAccountId:accounId UserId:userId] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    _addCommand                                                         = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    RACTuple * t                                                        = input;
    RACTupleUnpack(NSString * uName, NSString * lName, NSString * lPwd) = t;
        return [[[KM_NetworkApi addCallerUserName:uName LoginName:lName LoginPwd:lPwd] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

#pragma mark - Lazy -
-(NSMutableArray *)callerArr{
    if (!_callerArr) {
    _callerArr                                                          = [NSMutableArray array];
    }
    return _callerArr;
}
@end
