//
//  KMGroupDetailViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupDetailViewModel.h"

@implementation KMGroupDetailViewModel

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //请求队列详情
    _detailCommand    = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi groupDetailInfoWithID:self.groupID] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple   = (RACTuple *)x;
    NSArray *entrySet = tuple.first;
    self.detailInfo   = [KMGroupDetailInfo modelWithJSON:entrySet.firstObject];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //删除队列
    _deleGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi deleGroupWithID:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

@end
