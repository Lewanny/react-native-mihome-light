//
//  KMGroupViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupViewModel.h"

@implementation KMGroupViewModel

#pragma mark - Private Method
-(NSString *)emptyTitle{
    return @"等待创建队列";
}
-(NSString *)emptySubTitle{
    return @"还没有任何队列,您可以免费创建队列,\n发起排队。";
}
#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    _requestGroupList = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       return [[[KM_NetworkApi userGroupInfo] doNext:^(id  _Nullable x) {
           @strongify(self)
    RACTuple *tuple   = (RACTuple *)x;
    NSArray *entrySet = tuple.first;
    self.groupList    = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMGroupInfo class] json:entrySet]];
           [self.reloadSubject sendNext:nil];
       }]doError:^(NSError * _Nonnull error) {
           [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
       }];
    }];
}

-(void)km_bindOtherEvent{
    @weakify(self)
    //退出登录 清除数据
    [[kNotificationCenter rac_addObserverForName:kLogoutNotiName object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.groupList removeAllObjects];
        [self.reloadSubject sendNext:nil];
    }];
}

#pragma mark - Lazy
-(NSMutableArray *)groupList{
    if (!_groupList) {
    _groupList        = [NSMutableArray array];
    }
    return _groupList;
}

@end
