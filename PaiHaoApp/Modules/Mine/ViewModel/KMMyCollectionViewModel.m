//
//  KMMyCollectionViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMyCollectionViewModel.h"

@implementation KMMyCollectionViewModel

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //请求收藏列表
    _requestCollection            = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi collectionQueue] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple               = (RACTuple *)x;
    NSArray *entrySet             = tuple.first;
    self.collectionList           = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMCollectionModel class] json:entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //删除收藏排号
    _delCollection                = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    KMCollectionModel *collection = input;
    NSString *queueID             = collection.collecteid;
        @weakify(collection)
        return [[[KM_NetworkApi delCollectionQueue:queueID] doNext:^(id  _Nullable x) {
            @strongify(self, collection)
            if ([self.collectionList containsObject:collection]) {
                [self.collectionList removeObject:collection];
            }
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

#pragma mark - Lazy
-(NSMutableArray *)collectionList{
    if (!_collectionList) {
    _collectionList               = [NSMutableArray array];
    }
    return _collectionList;
}
@end
