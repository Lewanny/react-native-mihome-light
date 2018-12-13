//
//  KMSetWinVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSetWinVM.h"

@implementation KMSetWinVM

-(BOOL)verifyData{

    NSArray *arr          = [[[self dataArr].rac_sequence filter:^BOOL(KMWindowInfo * value) {
        return value.selected;
    }] array];
    if (arr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择窗口进行操作" Duration:1];
        return NO;
    }
    return YES;
}

-(NSArray *)dataArr{
    switch (self.bindState) {
        case KM_WindowBindStateNot:
            return self.unabsorbedWinArr;
            break;
        case KM_WindowBindStateAlready:
            return self.bindedWinArr;
            break;
        default:
            break;
    }
    return @[];
}

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //加载当前用户名下未分配的窗口
    _unabsorbedWin        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi unabsorbedWindow] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple       = (RACTuple *)x;
    NSArray *entrySet     = tuple.first;
    NSMutableArray *arrM  = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMWindowInfo class] json:entrySet]];
            for (KMWindowInfo *info in self.unabsorbedWinArr) {
                for (KMWindowInfo * newInfo in arrM) {
                    if ([info.ID isEqualToString:newInfo.ID]) {
    newInfo.selected      = info.selected;
                    }
                }
            }
    self.unabsorbedWinArr = arrM;
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //获取当前号群已经绑定的窗口列表
    _bindedWin            = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi windowWithGroupID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple       = (RACTuple *)x;
    NSArray *entrySet     = tuple.first;
    NSMutableArray *arrM  = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMWindowInfo class] json:entrySet]];
            for (KMWindowInfo *info in self.bindedWinArr) {
                for (KMWindowInfo * newInfo in arrM) {
                    if ([info.ID isEqualToString:newInfo.ID]) {
    newInfo.selected      = info.selected;
                    }
                }
            }
    self.bindedWinArr     = arrM;
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //提交
    _commitCommand        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
    NSString *windowStr   = @"";
    NSArray *arr          = [[[self dataArr].rac_sequence filter:^BOOL(KMWindowInfo * value) {
            return value.selected;
        }] array];
        for (KMWindowInfo *info in arr) {
    windowStr             = windowStr.length ? [windowStr stringByAppendingFormat:@"###%@", info.ID] : [windowStr stringByAppendingString:info.ID];
        }

        if (self.bindState == KM_WindowBindStateNot) {
            //未分配
            return [[[KM_NetworkApi bindWindow:windowStr Group:input] doNext:^(id  _Nullable x) {
                @strongify(self)
                [SVProgressHUD showSuccessWithStatus:@"绑定成功" Duration:1];
                [self.unabsorbedWin execute:nil];
            }] doError:^(NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
            }];
        }else if (self.bindState == KM_WindowBindStateAlready){
            //已绑定
            return [[[KM_NetworkApi unbindWindow:windowStr] doNext:^(id  _Nullable x) {
                @strongify(self)
                [SVProgressHUD showSuccessWithStatus:@"解绑成功" Duration:1];
                [self.bindedWin execute:input];
            }] doError:^(NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
            }];
        }
        return nil;
    }];
}

#pragma mark - Lazy
-(NSMutableArray *)unabsorbedWinArr{
    if (!_unabsorbedWinArr) {
    _unabsorbedWinArr     = [NSMutableArray array];
    }
    return _unabsorbedWinArr;
}
-(NSMutableArray *)bindedWinArr{
    if (!_bindedWinArr) {
    _bindedWinArr         = [NSMutableArray array];
    }
    return _bindedWinArr;
}
@end
