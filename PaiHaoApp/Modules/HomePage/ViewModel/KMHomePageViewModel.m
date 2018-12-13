//
//  KMHomePageViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHomePageViewModel.h"
#import "KMMerchantTypeModel.h"
#import "KMHistoryQueueModel.h"

@interface KMHomePageViewModel ()
/** 推荐 */
@property (nonatomic, strong) NSMutableArray * recommendArr;
/** 我的排号 */
@property (nonatomic, strong) NSMutableArray * mineArr;
/** 历史 */
@property (nonatomic, strong) NSMutableArray * historyArr;
@end

@implementation KMHomePageViewModel

/** 号群列表数据 */
-(NSArray *)groupArr{
    switch (self.groupType) {
        case KM_GroupTypeRecommend:
            //没有定位到 按原来的排序
            if (![KMLocationManager shareInstance].myLocation) {
                return self.recommendArr;
            }
            //已有定位 按由近到远排序
            return [self.recommendArr sortedArrayUsingComparator:^NSComparisonResult(KMGroupBriefModel * obj1, KMGroupBriefModel * obj2) {
                CLLocation *locat1        = [[CLLocation alloc]initWithLatitude:obj1.lat longitude:obj1.lng];
                CLLocation *locat2        = [[CLLocation alloc]initWithLatitude:obj2.lat longitude:obj2.lng];

                CGFloat distance1         = [KMLocationManager distanceWithLocation:locat1];
                CGFloat distance2         = [KMLocationManager distanceWithLocation:locat2];
                NSComparisonResult result = distance1 < distance2 ? NSOrderedAscending : NSOrderedDescending;
                return result;
            }];
            break;
        case KM_GroupTypeMyArranging:
            return self.mineArr;
            break;
        case KM_GroupTypeHistory:
            return self.historyArr;
            break;
        default:
            break;
    }
    return nil;
}


#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //请求行业分类
    _requestCategory          = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi requestMerchantType] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple           = (RACTuple *)x;
    NSArray *entrySet         = tuple.first;
    self.categoryArr          = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMMerchantTypeModel class] json:entrySet]];
            [KMTool saveCategoryType:self.categoryArr];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //请求推荐列表
    _requestRecommend         = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi requestRecommendGroup] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple           = (RACTuple *)x;
    NSArray *entrySet         = tuple.first;
    self.recommendArr         = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMGroupBriefModel class] json:entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //我的排号
    _requestMine              = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi requestMineQueue] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple           = (RACTuple *)x;
    NSArray *entrySet         = tuple.first;
    self.mineArr              = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMQueueInfo class] json:entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //查看历史
    _requestHistory           = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self)
    NSArray *arr              = [NSUserDefaults arcObjectForKey:kHistory];
            if (arr && arr.count) {
    self.historyArr           = arr.mutableCopy;
            }
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }] doNext:^(id  _Nullable x) {
            @strongify(self)
          [self.reloadSubject sendNext:nil];
        }];
    }];
    //获取未读消息数量
    _messagesNumberCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi messageNumber] doNext:^(id  _Nullable x) {
            RACTuple *t = x;
            NSNumber *status = t.fourth;
            if (status.integerValue == 0) {
                NSArray *paramsSet = t.second;
                NSDictionary *params = paramsSet.firstObject;
                NSNumber *count = [[KMTool normalDictWithWeirdDict:params] objectForKey:@"number"];
                self.messageCount = count ? [count integerValue] : 0;
                [[AppDelegate shareAppDelegate] setBadge:self.messageCount];
            }
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

-(void)km_bindOtherEvent{
    @weakify(self)
    [[kNotificationCenter rac_addObserverForName:kLogoutNotiName object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.mineArr removeAllObjects];
        [self.historyArr removeAllObjects];
        [self.reloadSubject sendNext:nil];
    }];
}

#pragma mark - Lazy
-(NSMutableArray *)categoryArr{
    if (!_categoryArr) {
    _categoryArr              = [NSMutableArray array];
    }
    return _categoryArr;
}
-(NSMutableArray *)recommendArr{
    if (!_recommendArr) {
    _recommendArr             = [NSMutableArray array];
    }
    return _recommendArr;
}
-(NSMutableArray *)mineArr{
    if (!_mineArr) {
    _mineArr                  = [NSMutableArray array];
    }
    return _mineArr;
}
-(NSMutableArray *)historyArr{
    if (!_historyArr) {
    _historyArr               = [NSMutableArray array];
    }
    return _historyArr;
}
@end
