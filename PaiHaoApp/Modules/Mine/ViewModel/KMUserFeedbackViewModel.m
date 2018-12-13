//
//  KMUserFeedbackViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserFeedbackViewModel.h"

@implementation KMUserFeedbackViewModel

#pragma mark - Private Method
- (NSString *)textViwePlaceholder{
    return @"请输入反馈, 我们将为您不断改进...";
}

#pragma mark - BaseViewModelInterface

-(void)km_bindNetWorkRequest{
    @weakify(self)
    _feedbackCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi feedbackWithMessage:self.feedBackText] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"反馈成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

-(void)km_bindOtherEvent{
    _maxTextCount    = 200;
    @weakify(self)
    _commitEnableSig = [RACSignal combineLatest:@[RACObserve(self, feedBackText)] reduce:^id (NSString *feedBack){
        @strongify(self)
        return @(feedBack.length > 3 && feedBack.length <= self.maxTextCount);
    }];
}
@end
