//
//  KMCategoryViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCategoryViewModel.h"

@implementation KMCategoryViewModel

- (instancetype)init
{
    self                        = [super init];
    if (self) {
    _currentPage                = 1;
    _queueSort                  = KMCategoryQueueSortNone;
    }
    return self;
}

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //请求行业类型号群
    _requestCategoryList        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi requestQueueListWithCategory:input Index:self.currentPage Status:self.queueSort City:self.sortArea] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple = (RACTuple *)x;
            NSArray * entrySet = tuple.first;
            if (entrySet.count > 0) {
                if (self.currentPage == 1) {
                    self.groupList = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMGroupBriefModel class] json:entrySet]];
                }else{
                    [self.groupList addObjectsFromArray:[NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMGroupBriefModel class] json:entrySet]]];
                }
            }else{
                if (self.currentPage == 1) {
                    [self.groupList removeAllObjects];
                }else{
                    self.currentPage --;
                }
            }
            [self.reloadSubject sendNext:@(entrySet.count)];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

/** 根据排序类型获取数据源 */
-(NSArray *)dataArr{

    NSMutableArray *arrM        = [self.groupList mutableCopy];
    KMCategorySortType sortType = self.sortType;
    switch (sortType) {
        case KMCategorySortTypeNearToFar:{
            return arrM;
//            if (![KMLocationManager shareInstance].myLocation) {
//                //没开启定位 或者定位未完成
//                return arrM;
//            }

//            return [arrM sortedArrayUsingComparator:^NSComparisonResult(KMGroupBriefModel * obj1, KMGroupBriefModel * obj2) {
//                CLLocation *locat1 = [[CLLocation alloc]initWithLatitude:obj1.lat longitude:obj1.lng];
//                CLLocation *locat2 = [[CLLocation alloc]initWithLatitude:obj2.lat longitude:obj2.lng];
//
//                CGFloat distance1 = [KMLocationManager distanceWithLocation:locat1];
//                CGFloat distance2 = [KMLocationManager distanceWithLocation:locat2];
//                NSComparisonResult result = distance1 < distance2 ? NSOrderedAscending : NSOrderedDescending;
//                return result;
//            }];
        }
            break;
        case KMCategorySortTypeIntellect:{

        }
            break;
        case KMCategorySortTypeScreen:{
            if (_sortArea.length == 0) {
                return arrM;
            }
            @weakify(self)
            return [[arrM.rac_sequence filter:^BOOL(KMGroupBriefModel * value) {
                @strongify(self)
                return [value.area containsString:self.sortArea] || [self.sortArea containsString:value.area];
            }] array];
        }
            break;
        default:
            break;
    }

    return arrM;
}

#pragma mark - Lazy
-(NSMutableArray *)groupList{
    if (!_groupList) {
    _groupList                  = [NSMutableArray array];
    }
    return _groupList;
}

@end
