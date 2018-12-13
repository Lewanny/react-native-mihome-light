//
//  KMGroupSearchVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupSearchVM.h"

@implementation KMGroupSearchVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = 1;
    }
    return self;
}

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       return [[[KM_NetworkApi searchGroupWithKeyword:input Index:_currentPage] doNext:^(id  _Nullable x) {
           @strongify(self)
           RACTuple *tuple    = (RACTuple *)x;
           NSArray * entrySet = tuple.first;
           if (entrySet.count > 0) {
               if (self.currentPage == 1) {
                   self.resultArr     = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMGroupBriefModel class] json:entrySet]];
               }else{
                   [self.resultArr addObjectsFromArray:[NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMGroupBriefModel class] json:entrySet]]];
               }
           }else{
               self.currentPage --;
           }
           [self.reloadSubject sendNext:@(entrySet.count)];
       }] doError:^(NSError * _Nonnull error) {
           [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
       }];
    }];
}

#pragma mark - Getter
-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}
-(NSMutableArray *)resultArr{
    if (!_resultArr) {
        _resultArr  = [NSMutableArray array];
    }
    return _resultArr;
}
@synthesize historyArr = _historyArr;

@end
