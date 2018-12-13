//
//  KMReplyDetailVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMReplyDetailVM.h"

@implementation KMReplyDetailVM

#pragma mark - BaseViewModelInterface -

-(void)km_bindNetWorkRequest{
    @weakify(self)
    _feedbackInfoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi feedbackInfoWithMsgID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *t = x;
            NSArray *entrySet = t.first;
            self.reply = [KMReplyMsgModel modelWithJSON:entrySet.firstObject];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
 
    _feedbackCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi feedbackWithMessage:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"发布回复成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

@end
