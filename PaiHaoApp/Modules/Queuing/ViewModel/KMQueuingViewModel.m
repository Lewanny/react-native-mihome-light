//
//  KMQueuingViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMQueuingViewModel.h"

@implementation KMQueuingViewModel

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    //我的排号
    _requestMyQueue           = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi requestMineQueue] doNext:^(id  _Nullable x) {
            RACTuple *tuple   = (RACTuple *)x;
            NSArray *entrySet = tuple.first;
            self.dataArr      = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMQueueInfo class] json:entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}
-(void)km_bindOtherEvent{
    @weakify(self)
    //退出登录 清除数据
    [[kNotificationCenter rac_addObserverForName:kLogoutNotiName object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.dataArr removeAllObjects];
        [self.reloadSubject sendNext:nil];
    }];
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr              = [NSMutableArray array];
    }
    return _dataArr;
}

@end
