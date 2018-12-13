//
//  KMBaseGroupViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseGroupViewModel.h"

@interface KMBaseGroupViewModel ()


@end

@implementation KMBaseGroupViewModel

-(instancetype)initWithGroupType:(KM_GroupType)groupType{
    if (self             = [super init]) {
    self.groupType       = groupType;
    }
    return self;
}

-(NSString *)controllerTitle{
    NSString *title      = @"";
    switch (self.groupType) {
        case KM_GroupTypeRecommend:
    title                = @"推荐队列";
            break;
        case KM_GroupTypeMyArranging:
    title                = @"我的排号";
            break;
        case KM_GroupTypeHistory:
    title                = @"查看历史";
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - BaseViewModelInterface

-(void)km_bindNetWorkRequest{
    @weakify(self);
    _loadListDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        //请求成功后进行处理  请求失败弹HUD
    RACSignal *sig       = [[[KM_NetworkApi requestRecommendGroup] doNext:^(id  _Nullable x) {
    RACTuple *tuple      = (RACTuple *)x;
    self.groupList       = [NSMutableArray arrayWithArray:tuple.allObjects];
        }] doError:^(NSError * _Nonnull error) {
           [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        return sig;
    }];
}


#pragma mark - Lazy
-(NSMutableArray *)groupList{
    if (!_groupList) {
    _groupList           = [NSMutableArray array];
    }
    return _groupList;
}

@end
