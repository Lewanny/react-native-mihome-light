//
//  KMRegisterCtrModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMRegisterCtrModel.h"
@interface KMRegisterCtrModel ()

@property (nonatomic, assign) NSInteger countSeconds;

@end

@implementation KMRegisterCtrModel

-(void)dealloc{
    /** 清除验证码的缓存 */
    KMUserDefault.verification = nil;
}

#pragma mark - Private Method
-(void)startCountDown{
    @weakify(self)
    //倒计时60秒
    _countSeconds = 60;
    [[[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:_countSeconds] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self)
        self.countSeconds --;
        [self.countDownSubject sendNext:@(self.countSeconds)];
        KMLog(@"%ld",self.countSeconds);
    }];
}

#pragma mark - BaseViewModelInterface

-(void)km_bindNetWorkRequest{
    @weakify(self)
    //获取验证码
    _requestCode = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            //先验证是否为11位数字
            if (![self.tele isMobilePhone]) {
                [SVProgressHUD showInfoWithStatus:@"请输入11位手机号码" Duration:1];
                [subscriber sendCompleted];
                return nil;
            }
            //请求验证码
            [[KMUserManager shareInstance] requestSecurityCodeWithTele:self.tele Success:^(NSString *verification) {
                @strongify(self)
                [self startCountDown];
                [subscriber sendNext:verification];
                [subscriber sendCompleted];
            } Failure:^(NSError *error) {
                NSString *msg = GetErrorMsg(error);
                [SVProgressHUD showErrorWithStatus:msg.length ? msg : @"获取验证码失败" Duration:1];
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }];
    
    //提交注册
    _regCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            // 先检查是否已经注册
            [[KMUserManager shareInstance] checkAccountRegisterStatus:self.tele CallBack:^(BOOL ret) {
                if (ret) {
                    @strongify(self)
                    //没注册过 再进行真正的注册
                    [[KMUserManager shareInstance] registerWithTele:self.tele Code:self.code Password1:self.password1 Password2:self.password2 UserType:self.userType Success:^(NSString * accountId) {
                        @strongify(self)
                        self.accountId = accountId;
                        [SVProgressHUD showSuccessWithStatus:@"注册成功" Duration:1];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        });
                    } Failure:^(NSError *error) {
                        if (error) {
                            NSString *msg = GetErrorMsg(error);
                            [SVProgressHUD showErrorWithStatus:msg.length ? msg : @"注册失败" Duration:1];
                            [subscriber sendError:error];
                        }else{
                            [subscriber sendCompleted];
                        }
                    }];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"该手机号码已被注册" Duration:2];
                    [subscriber sendCompleted];
                }
            }];
            return nil;
        }];
    }];
}

-(void)km_bindOtherEvent{
    /** 电话号码长度 11 验证码长度不为零  密码长度 大于等于3 */
    _regBtnEnableSig = [RACSignal combineLatest:@[RACObserve(self, tele), RACObserve(self, code), RACObserve(self, password1), RACObserve(self, password2)] reduce:^id (NSString *tele, NSString *code, NSString *pwd1, NSString *pwd2){
        return @(tele.length == 11 && code.length && pwd1.length >=3 && pwd2.length >= 3);
    }];
}

#pragma mark - Lazy
-(RACSubject *)countDownSubject{
    if (!_countDownSubject) {
        _countDownSubject = [RACSubject subject];
    }
    return _countDownSubject;
}

@end
