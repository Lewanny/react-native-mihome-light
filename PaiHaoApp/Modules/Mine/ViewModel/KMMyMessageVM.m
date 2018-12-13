//
//  KMMyMessageVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMyMessageVM.h"

@implementation KMMyMessageVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentPage = 1;
    }
    return self;
}

-(void)km_bindNetWorkRequest{
    @weakify(self)
    //动态消息列表
    _dtMsgCommand       = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi messageDT] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *t         = x;
            NSArray *entrySet   = t.first;
            NSDictionary *entry = entrySet.firstObject;
            NSArray *platform   = [entry objectForKey:@"platformMsg"];
            NSArray *recovery   = [entry objectForKey:@"recoveryMsg"];
            self.platformMsgArr = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMPlatformMsgModel class] json:platform]];
            self.recoveryMsgArr = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMRecoveryMsgModel class] json:recovery]];
            [self.reloadSubject sendNext:nil];
        }]doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //添加阅读记录
    _addBrowsingHistoryCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACTupleUnpack(NSString * msgID, NSNumber * mode) = input;
        return [[[KM_NetworkApi addBrowsingHistoryWithMsgID:msgID Mode:mode] doNext:^(id  _Nullable x) {
            @strongify(self)
            //动态消息刷新
            [self.dtMsgCommand execute:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //删除消息
    _deleteRemindCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi deleMessageWithMsgID:input] doNext:^(id  _Nullable x) {
            KMLog(@"删除成功");
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //提醒消息
    _remindInfoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi remindInfoWithPage:self.currentPage] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *t = x;
            NSArray *entrySet = t.first;
            
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMRemindMsgModel class] json:entrySet]];
            if (self.currentPage == 1) {
                self.queueRemindArr = arrayM;
            }else{
                if (arrayM.count == 0) {
                    self.currentPage --;
                }
                [self.queueRemindArr addObjectsFromArray:arrayM];
            }
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //排号提醒未读数量
    _remindNumberCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi queueMessageNumber] doNext:^(id  _Nullable x) {
            RACTuple *t = x;
            NSArray *paramsSet = t.second;
            NSDictionary *params = paramsSet.firstObject;
            NSNumber *count = [[KMTool normalDictWithWeirdDict:params] objectForKey:@"number"];
            self.remindNumber = count ? [count integerValue] : 0;
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //动态消息未读数量
    _dtNumberCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi dynamicNumber] doNext:^(id  _Nullable x) {
            RACTuple *t = x;
            NSArray *paramsSet = t.second;
            NSDictionary *params = paramsSet.firstObject;
            NSNumber *count = [[KMTool normalDictWithWeirdDict:params] objectForKey:@"number"];
            self.dtNumber = count ? [count integerValue] : 0;
        }] doError:^(NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

-(void)deleRemindMessage:(NSInteger)msgID{
    for (KMRemindMsgModel *model in self.queueRemindArr) {
        if (model.ID == msgID) {
            [self.queueRemindArr removeObject:model];
            break;
        }
    }
}

#pragma mark - Lazy -
-(NSMutableArray *)platformMsgArr{
    if (!_platformMsgArr) {
        _platformMsgArr = [NSMutableArray array];
    }
    return _platformMsgArr;
}
-(NSMutableArray *)recoveryMsgArr{
    if (!_recoveryMsgArr) {
        _recoveryMsgArr = [NSMutableArray array];
    }
    return _recoveryMsgArr;
}
-(NSMutableArray *)queueRemindArr{
    if (!_queueRemindArr) {
        _queueRemindArr = [NSMutableArray array];
    }
    return _queueRemindArr;
}
@end
