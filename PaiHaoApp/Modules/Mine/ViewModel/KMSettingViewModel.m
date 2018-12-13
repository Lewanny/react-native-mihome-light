//
//  KMSettingViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSettingViewModel.h"
#import "KM_NetworkCache.h"
@implementation KMSettingViewModel

-(void)km_bindNetWorkRequest {
    @weakify(self)
    _editReminderCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        BOOL ret = [(NSNumber *)input boolValue];
        return [[[KM_NetworkApi editReminderSettings:ret] doNext:^(id  _Nullable x) {
            @strongify(self)
            [self.reloadSubject sendNext:@(ret)];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

/** 清除缓存 */
-(void)cleanCache:(Block_Void)callBack{
    @weakify(self)
    [LBXAlertAction showAlertWithTitle:@"提示" msg:NSStringFormat(@"确定清除缓存 %@ ?",[self cacheSizeString]) buttonsStatement:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 1) {//确认清除
            [SVProgressHUD showWithStatus:@"正在清除缓存"];
            //清除缓存
            [KM_NetworkCache removeAllHttpCache];
            [[YYImageCache sharedCache].memoryCache removeAllObjects];
            [[YYImageCache sharedCache].diskCache removeAllObjects];
            //清除完成回调
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self)
                callBack ? callBack() : nil;
                [self.reloadSubject sendNext:nil];
            });
        }
    }];


}
/** 缓存大小 */
-(NSString *)cacheSizeString{
    //网络请求缓存 + 图片磁盘缓存
    //图片内存缓存不算
    CGFloat size = [KM_NetworkCache getAllHttpCacheSize] + [YYImageCache sharedCache].diskCache.totalCost;
    KMLog(@"=========== %ld   %ld   %ld",[KM_NetworkCache getAllHttpCacheSize], [YYImageCache sharedCache].memoryCache.totalCost, [YYImageCache sharedCache].diskCache.totalCost);
    return NSStringFormat(@"%.2fMB",(size /1024.0/1024.0));
}

-(NSArray *)titleArr{
    return @[
             @[@"语音提醒设置", @"清除缓存"],
             @[@"版本号"],
             @[@"打印机"],
             @[@"退出登录"]
            ];
}
@end
