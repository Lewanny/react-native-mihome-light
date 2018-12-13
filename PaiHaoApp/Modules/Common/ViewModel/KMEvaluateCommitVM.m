//
//  KMEvaluateCommitVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMEvaluateCommitVM.h"

@implementation KMEvaluateCommitVM

#pragma mark - BaseViewModelInterface -
-(void)km_bindNetWorkRequest{
    @weakify(self)
    _commitCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi addCommentWithQueueID:input Score:@(self.starNum) Comment:self.comment] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}
-(void)km_bindOtherEvent{
    
    _commitEnableSig = [RACSignal combineLatest:@[RACObserve(self, starNum), RACObserve(self, comment)] reduce:^id _Nullable(NSNumber * score, NSString * comment){
        
        return @(score.floatValue > 0 && comment.length >= 15);
    }];
}

@end
