//
//  KMSeePackageVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSeePackageVM.h"

@implementation KMPackageStatusInfo

@end

@implementation KMSeePackageVM

-(void)km_bindNetWorkRequest{
    @weakify(self)
    _packageCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi packageSchedule:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *t       = x;
            NSArray *entrySet = t.first;
            self.infoArr      = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMPackageStatusInfo class] json:entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

#pragma mark - Lazy -
-(NSMutableArray *)infoArr{
    if (!_infoArr) {
        _infoArr = [NSMutableArray array];
    }
    return _infoArr;
}
@end
