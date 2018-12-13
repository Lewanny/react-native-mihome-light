//
//  KMHistoryQueueViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHistoryQueueViewModel.h"

@implementation KMHistoryQueueViewModel


#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //历史排队列表
    _requestHistory              = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi queueHistory] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple              = (RACTuple *)x;
    NSArray *entrySet            = tuple.first;
    self.historyList             = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMHistoryQueueModel class] json:entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //删除历史排队
    _deleHistory                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    KMHistoryQueueModel *history = input;
    NSString *queueID            = history.queueId;
        @weakify(history)
        return [[[KM_NetworkApi delHistoryQueue:queueID] doNext:^(id  _Nullable x) {
            @strongify(self, history)
            if ([self.historyList containsObject:history]) {
                [self.historyList removeObject:history];
//                [self.reloadSubject sendNext:nil];
            }
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}
#pragma mark - Lazy
-(NSMutableArray *)historyList{
    if (!_historyList) {
    _historyList                 = [NSMutableArray array];
    }
    return _historyList;
}
@end
