//
//  KMCompleteUserInfoViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCompleteUserInfoViewModel.h"

@implementation KMCompleteUserInfoViewModel

#pragma mark - BaseViewModelInterface

-(void)km_bindNetWorkRequest{
    @weakify(self)
    //保存
    _saveCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        RACSignal *sig = [[[KM_NetworkApi completeUserInfoWithAccountId:self.accountId
                                                             UserName:self.userName
                                                                 Mail:self.mail
                                                             Location:self.location] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功" Duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.successSubject sendNext:nil];
            });
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"保存失败" Duration:1];
        }];
        return sig;
    }];
}

-(void)km_bindOtherEvent{
    //按钮是否可点击
    _saveBtnEnableSig = [RACSignal combineLatest:@[RACObserve(self, userName), RACObserve(self, mail), RACObserve(self, location)] reduce:^id _Nullable(NSString *userName, NSString *mail, NSString *location){
        return @(userName.length >= 3 && [mail isEmailAddress] && location.length);
    }];
}
#pragma mark - Lazy
-(RACSubject *)successSubject{
    if (!_successSubject) {
        _successSubject = [RACSubject subject];
    }
    return _successSubject;
}
@end
