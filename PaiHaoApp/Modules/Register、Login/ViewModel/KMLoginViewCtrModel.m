//
//  KMLoginViewCtrModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMLoginViewCtrModel.h"

@implementation KMLoginViewCtrModel
#pragma mark - BaseViewModelInterface

-(void)km_bindNetWorkRequest{
    @weakify(self)
    //登录
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            [[KMUserManager shareInstance] loginWithUserName:self.userName
                                                    Password:self.password
                                                     Success:^(KMUserLoginModel *userLogin) {
                //登录成功
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            } Failure:^(NSError *error) {
                [UIAlertView showMessage:@"账号或密码错误，请重新输入"];
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }];
    //切换到最新信号
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功" Duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.loginSuccessSubject sendNext:nil];
            });
        }else{
//            [UIAlertView showMessage:@"账号或密码错误，请重新输入"];
//            [SVProgressHUD showErrorWithStatus:@"账号或密码错误，请重新输入" Duration:1];
        }
    }];
    //处理错误信号
    [_loginCommand.errors subscribeNext:^(NSError * _Nullable x) {
//        NSString *msg = [x.userInfo objectForKey:kErrmsg];
//        [SVProgressHUD showErrorWithStatus:msg.length ? msg : @"账号或密码错误，请重新输入" Duration:1];
    }];
    //信号正在执行中
    [[_loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            [SVProgressHUD showWithStatus:@"正在登录" Duration:1.5];
        }
    }];
}

-(void)km_bindOtherEvent{
    _loginBtnEnableSig = [RACSignal combineLatest:@[RACObserve(self, userName), RACObserve(self, password)] reduce:^id (NSString *userName, NSString *password){
        return @(userName.length >= 3 && password.length >= 3);
    }];
}

#pragma mark - Lazy
-(RACSubject *)loginSuccessSubject{
    if (!_loginSuccessSubject) {
        _loginSuccessSubject = [RACSubject subject];
    }
    return _loginSuccessSubject;
}

@end
