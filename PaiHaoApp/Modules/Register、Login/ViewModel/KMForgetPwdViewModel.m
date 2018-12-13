//
//  KMForgetPwdViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMForgetPwdViewModel.h"

@interface KMForgetPwdViewModel ()

@property (nonatomic, assign) NSInteger countSeconds;

@end

@implementation KMForgetPwdViewModel
-(void)dealloc{
    /** 清除验证码的缓存 */
    KMUserDefault.verification = nil;
}
#pragma mark - Private Method
/** 开始倒计时 */
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
    //请求验证码
    _requestCode = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            //先验证是否为11位数字
            if (![self.tele isMobilePhone]) {
                [SVProgressHUD showInfoWithStatus:@"请输入11位手机号码" Duration:1];
                [subscriber sendCompleted];
                return nil;
            }
            [[KMUserManager shareInstance] checkAccountRegisterStatus:self.tele CallBack:^(BOOL ret) {
                if (ret) {
                    //手机号码没有注册
                    [SVProgressHUD showInfoWithStatus:@"该手机号码尚未注册" Duration:1];
                    [subscriber sendCompleted];
                }else{
                    //手机号码已经注册 发起验证码请求
                    [[KMUserManager shareInstance] requestSecurityCodeWithTele:self.tele Success:^(NSString *verification) {
                        [self startCountDown];
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    } Failure:^(NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
                        [subscriber sendError:error];
                    }];
                }
            }];
            return nil;
        }];
    }];
    
    //保存
    _saveCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
            [[KMUserManager shareInstance] changePwdWithTele:self.tele Code:self.code Password1:self.password1 Password2:self.password2 Success:^(BOOL ret) {
                if (ret) {
                    [subscriber sendNext:nil];
                    [SVProgressHUD showSuccessWithStatus:@"找回密码成功" Duration:1];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"找回密码失败" Duration:1];
                }
                [subscriber sendCompleted];
            } Failure:^(NSError *error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
                    [subscriber sendError:error];
                }else{
                    [subscriber sendCompleted];
                }
            }];
            return nil;
        }];
    }];
}
-(void)km_bindOtherEvent{
    /** 电话号码长度 11 验证码长度不为零  密码长度 大于等于3 */
    _btnEnableSig = [RACSignal combineLatest:@[RACObserve(self, tele), RACObserve(self, code), RACObserve(self, password1), RACObserve(self, password2)] reduce:^id (NSString *tele, NSString *code, NSString *pwd1, NSString *pwd2){
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
