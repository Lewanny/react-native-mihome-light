//
//  KMMemberCenterViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMemberCenterViewModel.h"

@implementation KMMemberCenterViewModel

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    _userInfoCommand  = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi requestUserInfo] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple   = x;
    NSArray *entrySet = tuple.first;
    self.member       = [KMMemberModel modelWithJSON:entrySet.firstObject];
        }] doError:^(NSError * _Nonnull error) {
            KMLog(@"%@",error);
        }];
    }];
}

-(void)km_bindOtherEvent{
    @weakify(self)
    //退出登录清除用户信息
    [[kNotificationCenter rac_addObserverForName:kLogoutNotiName object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
    self.member       = nil;
    }];
}

/** 获取用户的类型 */
-(KM_CustomerType)customerType{
    if (_member) {
        return [_member.customertype integerValue];
    }
    return KM_CustomerTypePersonal;
}

/** 能否升级账户 */
-(BOOL)checkCanUpdate{
    if (!_member) {
        return NO;
    }
    if ([self customerType] == KM_CustomerTypeCertification) {
        [SVProgressHUD showInfoWithStatus:@"您已成为高级商户" Duration:1];
        return NO;
    }
    if ([self customerType] == KM_CustomerTypeGold) {
        [SVProgressHUD showInfoWithStatus:@"您已成为白金商户" Duration:1];
        return NO;
    }
    return YES;
}

-(NSArray *)titleArr{
    return @[
             @[@""],
             @[
                 @"我的消息",
                 @"我的收藏",
                 @"历史排队",
                 @"商户服务",
                 @"用户反馈"
             ],
             @[@"设置"]
             ];
}
-(NSArray *)imgNameArr{
    return @[
             @[@""],
             @[
                 @"wodexiaoxi",
                 @"wdsc",
                 @"lspd",
                 @"shfw",
                 @"yhfk"
              ],
             @[@"shezhi"]
             ];
}
@end
