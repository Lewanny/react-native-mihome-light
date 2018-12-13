//
//  KMGroupQueueDetailVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueDetailVM.h"


@implementation KMGroupQueueDetailVM

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
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //套餐信息
    _requestPackageInfo               = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi packageLists:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple           = (RACTuple *)x;
            NSArray *entrySet         = tuple.first;
            self.packageList          = [NSArray modelArrayWithClass:[KMPackageItem class] json:entrySet];
        }] doError:^(NSError * _Nonnull error) {
//           [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //排队信息
    _requestQueueInfo                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi screenqueueDetailByGroundId:input WinID:nil] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple           = (RACTuple *)x;
            NSArray *entrySet         = tuple.first;
            self.queueArr             = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMQueueDataModel class] json:entrySet]];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //评论信息
    _requestComment                   = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi commentListWithGroupId:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple           = (RACTuple *)x;
            NSArray *entrySet         = tuple.first;
            self.commentInfo          = [KMGroupCommentModel modelWithJSON:entrySet.firstObject];
            self.evaluateArr          = [NSMutableArray arrayWithArray:self.commentInfo.commentInfo];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    
    //参加排队
    _joinQueueCommand                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi joinQueueWithGroupID:self.groupID
                                             isVoice:self.isVoice
                                               isSms:YES
                                             minutes:self.minutes]
                 doNext:^(id  _Nullable x) {
            @strongify(self)
            [self.refreshSubject sendNext:nil];
            [self addRemind];
            [SVProgressHUD showSuccessWithStatus:@"排队成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            if ([[error.userInfo objectForKey:kErrStatus] integerValue] == 11) {
                [SVProgressHUD showInfoWithStatus:@"当前人数已达上限，请改期参与！" Duration:2];
            }else{
//                [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
            }
        }];
    }];
    
    //参加套餐
    _packageQueueCommand              = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi joinQueueWithPackageID:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"套餐排队成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //退出排队
    _exitQueueCommand                 = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi exitQueueWithQueueID:self.queueID] doNext:^(id  _Nullable x) {
            @strongify(self)
            [self.refreshSubject sendNext:nil];
            [SVProgressHUD showSuccessWithStatus:@"退出成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //判断收藏
    _checkCollectionStatus            = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi checkCollectionStatusWithGroupId:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple           = x;
            NSInteger status          = [tuple[3] integerValue];
            if (status == 0) {      //已收藏
                NSArray *entrySet     = tuple.first;
                NSDictionary *entry   = entrySet.firstObject;
                self.collectionID     = [entry objectForKey:@"id"];
                self.isCollection     = YES;
            }else if (status == 3){ //未收藏
                self.isCollection     = NO;
            }
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //加入收藏
    _addCollection                    = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       return [[[KM_NetworkApi addCollectionWithGroupID:input] doNext:^(id  _Nullable x) {
           @strongify(self)
           RACTuple *tuple            = x;
           NSInteger status           = [tuple[3] integerValue];
           if (status == 0) {      //已收藏
               NSArray *entrySet      = tuple.first;
               NSDictionary *entry    = entrySet.firstObject;
               self.collectionID      = [entry objectForKey:@"id"];
               self.isCollection      = YES;
           }
       }] doError:^(NSError * _Nonnull error) {
//           [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
       }];
    }];
    //取消收藏
    _deleCollection                   = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[KM_NetworkApi cancelCollectionWithColID:self.collectionID] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //判断是否已经在排队
    _checkQueue                       = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi checkQueueInfo:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple           = (RACTuple *)x;
            NSNumber *status          = tuple.fourth;
            //0 已经排号  3 未排号
            if (status.intValue == 0) {
                NSArray *paramsSet    = tuple.second;
                NSDictionary * params = [paramsSet firstObject];
                self.queueID          = [params objectForKey:kValue];
                self.alreadyQueue     = YES;
            }else if (status.intValue == 3) {
                self.queueID          = @"";
                self.alreadyQueue     = NO;
            }
            NSDictionary *entry       = [tuple.first firstObject];
            self.packageInfo          = [entry objectForKey:@"groupInfo"];
            self.packageName          = [entry objectForKey:@"packagename"];
        }] doError:^(NSError * _Nonnull error) {
            @strongify(self)
            self.queueID              = @"";
            self.alreadyQueue         = NO;
            [self.reloadSubject sendNext:nil];
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //HUD 消失 
    [[RACSignal combineLatest:@[_requestGroupInfo.executionSignals.switchToLatest, _requestPackageInfo.executionSignals.switchToLatest, _requestQueueInfo.executionSignals.switchToLatest, _requestComment.executionSignals.switchToLatest]] subscribeNext:^(RACTuple * _Nullable x) {
        [SVProgressHUD dismiss];
    }];
    //每请求成功就刷新一下
    NSArray *needReloadArr            = @[_requestGroupInfo.executionSignals.switchToLatest, _requestPackageInfo.executionSignals.switchToLatest, _requestQueueInfo.executionSignals.switchToLatest, _requestComment.executionSignals.switchToLatest, _joinQueueCommand.executionSignals.switchToLatest, _exitQueueCommand.executionSignals.switchToLatest,_checkQueue.executionSignals.switchToLatest];
    
    [[RACSignal merge:needReloadArr] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.reloadSubject sendNext:nil];
    }];
    
    //判断套餐中队列是否有的已经排队，倘若有不允许再排套餐
    _checkPackageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[KM_NetworkApi checkPackageWithID:input] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    _userInfoCommand  = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi requestUserInfo] doNext:^(id  _Nullable x) {

        }] doError:^(NSError * _Nonnull error) {
            KMLog(@"%@",error);
        }];
    }];
    
}


/** 远程是否超出距离 */
-(BOOL)beyondDistance{
    BOOL ret = NO;
    if (_baseInfo.isallowremote == 0) {
        //允许远程排队
        ret = NO;
    }else{
        CLLocation *location = [[KMLocationManager shareInstance] myLocation];
        if (location) {
            CLLocation *targetLocation = [[CLLocation alloc]initWithLatitude:[_baseInfo.lat floatValue]longitude:[_baseInfo.lng floatValue]];
            CLLocationDistance meters  = [location distanceFromLocation:targetLocation];
            if (meters > 200) {
                ret = YES;
                [UIAlertView showMessage:@"该队列管理员不允许远程排号！请到现场参与。"];
            }
        }else{
            ret = YES;
            [UIAlertView showMessage:@"获取当前定位失败，该队列管理员不允许远程排号！"];
        }
    }
    return ret;
}

/** 自定义选择时间提醒 */
-(void)addRemind{
    if (_minutes == nil || [_minutes isEqual:@(0)]) {
        return;
    }
}

-(NSInteger)numberOfSections{
    NSInteger count                    = 0;
    if (_baseInfo) {
        count ++;
    }
    if (self.queueArr.count) {
        count ++;
    }
    if (self.evaluateArr.count) {
        count ++;
    }
    return count;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count                    = 0;
    SectionStyle style                 = [self styleForSection:section];
    
    switch (style) {
        case SectionStyleGroupInfo:
            count                      = 1;
            break;
        case SectionStyleQueueInfo:
            count                      = self.queueArr.count;
            break;
        case SectionStyleEvaluate:
            count                      = self.evaluateArr.count;
            break;
        default:
            break;
    }
    return count;
}

-(NSArray *)timeArr{
    return @[@0, @10, @20, @30 ,@45, @60];
}

-(SectionStyle)styleForSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            if (_baseInfo) {
                return SectionStyleGroupInfo;
            }else if (self.queueArr.count){
                return SectionStyleQueueInfo;
            }else if (self.evaluateArr.count){
                return SectionStyleEvaluate;
            }else if (self.relatedArr.count){
                return SectionStyleRelated;
            }
        }
            break;
        case 1:{
            if (_baseInfo && self.queueArr.count) {
                return SectionStyleQueueInfo;
            }else if (_baseInfo || self.queueArr.count){
                if (self.evaluateArr.count) {
                    return SectionStyleEvaluate;
                }else if (self.relatedArr.count){
                    return SectionStyleRelated;
                }
            }
        }
            break;
        case 2:{
            if (_baseInfo && self.queueArr.count) {
                if (self.evaluateArr.count) {
                    return SectionStyleEvaluate;
                }else if (self.relatedArr.count){
                    return SectionStyleRelated;
                }
            }else{
               return SectionStyleRelated;
            }
        }
            break;
        case 3:{
            return SectionStyleRelated;
        }
            break;
            
        default:
            return SectionStyleNone;
            break;
    }
    return SectionStyleNone;
}

/** 是否可以排队 */
-(BOOL)checkCanQueue{
    if (self.baseInfo.groupstatus == 1) {
        [SVProgressHUD showInfoWithStatus:@"队列已锁定，不允许排队" Duration:1];
        return NO;
    }
    if (self.baseInfo.groupstatus == 2) {
        [SVProgressHUD showInfoWithStatus:@"队列已删除/注销，不允许排队" Duration:1];
        return NO;
    }
    if (self.baseInfo.groupstatus == 3) {
        [SVProgressHUD showInfoWithStatus:@"队列人数已满，不允许排队" Duration:1];
        return NO;
    }
    //时间段
    if ([_baseInfo.timespan containsString:@"-"]) {
        NSArray *times = [_baseInfo.timespan componentsSeparatedByString:@" "];
        if (times.count == 2) {
            NSString *date = times.firstObject;
            NSString *time = times.lastObject;

            NSDate *start = [NSDate dateWithString:NSStringFormat(@"%@ %@",date,[time componentsSeparatedByString:@"-"].firstObject) format:@"yyyy/MM/dd HH:mm"] ;
            NSDate *end = [NSDate dateWithString:NSStringFormat(@"%@ %@",date,[time componentsSeparatedByString:@"-"].lastObject) format:@"yyyy/MM/dd HH:mm"];

            NSDate *currentDate = [NSDate date];

            if ([start compare:currentDate] == NSOrderedAscending && [end compare:currentDate] == NSOrderedDescending) {
                BOOL extractedExpr = [self beyondDistance];
                
                return !extractedExpr;
            }
        }
        [SVProgressHUD showInfoWithStatus:@"不在排队时间段内，不允许排队" Duration:1];
        return NO;
    }

    BOOL extractedExpr = [self beyondDistance];
    
    return !extractedExpr;
}


#pragma mark - Lazy
-(NSMutableArray *)queueArr{
    if (!_queueArr) {
        _queueArr                      = [NSMutableArray array];
    }
    return _queueArr;
}

-(NSMutableArray *)evaluateArr{
    if (!_evaluateArr) {
        _evaluateArr                   = [NSMutableArray array];
    }
    return _evaluateArr;
}

-(NSMutableArray *)relatedArr{
    if (!_relatedArr) {
        _relatedArr                    = [NSMutableArray array];
    }
    return _relatedArr;
}
-(RACSubject *)refreshSubject{
    if (!_refreshSubject) {
        _refreshSubject                = [RACSubject subject];
    }
    return _refreshSubject;
}
@end
