//
//  KMGroupQueueInfoVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueInfoVM.h"

@implementation KMGroupQueueInfoVM

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //队列信息
    _requestGroupInfo                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi groupInfoWithGroupID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple           = (RACTuple *)x;
            NSArray *entrySet         = tuple.first;
            self.baseInfo             = [KMGroupBaseInfo modelWithJSON:entrySet.firstObject];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //排队信息
    _requestQueueInfo                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi queueDetailWithQueueID:self.queueID
                                              GroupID:self.groupID]
                doNext:^(id  _Nullable x) {
            @strongify(self)
//                    RACTuple *tuple   = (RACTuple *)x;
//                    NSArray *entrySet = tuple.first;
//                    self.queueDetail  = [KMQueueDetail modelWithJSON:entrySet.firstObject];
//                    self.packageInfo  = self.queueDetail.packageInfo;
                    RACTuple *tuple           = (RACTuple *)x;
                    NSArray *entrySet         = tuple.first;
                    self.queueArr             = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMQueueDataModel class] json:entrySet]];

        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    _requestQueueDetailInfo = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi queueDetailInfoWithQueueID:self.queueID GroupID:self.groupID] doNext:^(id  _Nullable x) {
                    RACTuple *tuple   = (RACTuple *)x;
                    NSArray *entrySet = tuple.first;
                  self.queueDetail  = [KMQueueDetail modelWithJSON:entrySet.firstObject];
                    self.packageInfo  = self.queueDetail.packageInfo;
        }] doError:^(NSError * _Nonnull error) {
             //[SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //退出排队
    _exitQueueCommand                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
      return [[[KM_NetworkApi exitQueueWithQueueID:self.queueID] doNext:^(id  _Nullable x) {
          [SVProgressHUD showSuccessWithStatus:@"退出成功" Duration:1];
      }] doError:^(NSError * _Nonnull error) {
          [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
      }];
    }];
    
    NSArray *needReloadArr            = @[_requestGroupInfo.executionSignals.switchToLatest, _requestQueueInfo.executionSignals.switchToLatest,_requestQueueDetailInfo.executionSignals.switchToLatest];
    
    //HUD 消失
    [[RACSignal combineLatest:needReloadArr] subscribeNext:^(RACTuple * _Nullable x) {
        [SVProgressHUD dismiss];
    }];
    
    //每请求成功就刷新一下
    [[RACSignal merge:needReloadArr] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.reloadSubject sendNext:nil];
    }];
}

-(CellStyle)styleForIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    switch (section) {
        case 0:{
            if (_baseInfo) {
                return CellStyleGroupInfo;
            }
            if (row == 0) {
                if (_packageInfo.length) {
                    return CellStylePackageInfo;
                }else{
                    return CellStyleWaitInfo;
                }
            }else{
               return CellStyleWaitInfo; 
            }
        }
            break;
        case 1:{
            if (_baseInfo) {
                if (row == 0) {
                    if (_packageInfo.length) {
                        return CellStylePackageInfo;
                    }else{
                        return CellStyleWaitInfo;
                    }
                }else{
                    return CellStyleWaitInfo;
                }
            }else{
                return CellStyleQueueInfo;
            }
        }
            break;
        case 2:{
            return CellStyleQueueInfo;
        }
            break;
        default:
            break;
    }
    
    return CellStyleGroupInfo;
}

-(NSInteger)numberOfSections{
    NSInteger count   = 0;
    if (self.baseInfo) {
        count ++;
    }
    if (self.queueDetail) {
        count ++;
        if (self.queueDetail.QueueDetailed.count) {
            count ++;
        }
    }
//    if (self.queueArr) {
//        count = self.queueArr.count;
//    }
    return count;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            if (self.baseInfo){
                return 1;
            }else{
                if (self.packageInfo.length) {
                    return 2;
                }
                return 1;
            }
        }
            break;
        case 1:{
            if (self.baseInfo) {
                if (self.packageInfo.length) {
                    return 2;
                }
                return 1;
            }else{
                return self.queueArr.count;
//                return self.queueDetail.QueueDetailed.count;
            }
        }
            break;
        case 2:{
//            return self.queueDetail.QueueDetailed.count;
            return self.queueArr.count;
        }
            break;
        default:
            return 0;
            break;
    }
}
- (NSMutableArray *)queueArr{
    if (!_queueArr) {
        _queueArr = [[NSMutableArray alloc] init];
    }
    return _queueArr;
}
@end
