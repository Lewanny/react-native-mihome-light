//
//  KMPackageVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageVM.h"

@implementation KMPackageVM

#pragma mark - Private Method -
-(BOOL)verifyNewPackageData{

    if (_packageName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请套餐名称" Duration:1];
        return NO;
    }
    if (_packageInfo.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请套餐说明" Duration:1];
        return NO;
    }

    NSArray *arr            = [[self.groupArr.rac_sequence filter:^BOOL(KMGroupOrderInfo *info) {
        return info.select;
    }] array];

    if (arr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请至少选择一个号群" Duration:1];
        return NO;
    }

    return YES;
}

-(NSDictionary *)newPackageParams{

    NSArray *arr            = [[self.groupArr.rac_sequence filter:^BOOL(KMGroupOrderInfo *info) {
        return info.select;
    }] array];

    NSMutableArray *arrM    = [NSMutableArray array];

    for (KMGroupOrderInfo *info in arr) {
    NSDictionary *d         = @{@"groupid" : info.groupID, @"sort":@(info.order)};
        [arrM addObject:d];
    }

    NSDictionary *params    = @{
                             @"packagename":_packageName,
                             @"creater":KMUserDefault.userName,
                             @"userid":KMUserDefault.userID,
                             @"explain":_packageInfo,
                             @"relate":arrM
                             };

    return params;
}


/** 编辑套餐参数验证 */
-(BOOL)verifyEditPackageData{
    if (_editPackageInfo.packageName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写套餐名称" Duration:1];
        return NO;
    }
    if (_editPackageInfo.explain.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写套餐说明" Duration:1];
        return NO;
    }

    NSArray *arr            = [[self.editPackageInfo.relate.rac_sequence filter:^BOOL(KMPackageRelate *info) {
        return info.selected;
    }] array];

    if (arr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请至少选择一个号群" Duration:1];
        return NO;
    }

    return YES;
}

-(NSDictionary *)editPackageParams{

    NSArray *arr            = [[self.editPackageInfo.relate.rac_sequence filter:^BOOL(KMPackageRelate *info) {
        return info.selected;
    }] array];

    NSMutableArray *arrM    = [NSMutableArray array];

    for (KMPackageRelate *info in arr) {
    NSDictionary *d         = @{@"groupid" : info.groupId, @"sort":@(info.sort)};
        [arrM addObject:d];
    }

    NSDictionary *params    = @{
                             @"id":@(_editPackageInfo.ID),
                             @"packagename":_editPackageInfo.packageName,
                             @"creater":KMUserDefault.userName,
                             @"userid":KMUserDefault.userID,
                             @"explain":_editPackageInfo.explain,
                             @"relate":arrM
                             };

    return params;
}

#pragma mark - BaseViewModelInterface -
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //套餐列表
    _packageListCommand     = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi userPackageList] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *t             = x;
    NSArray *entrySet       = t.first;
    self.packageArr         = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMPackageInfo class] json:entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //号群列表
    _groupListCommand       = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi userGroupInfo] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple         = (RACTuple *)x;
    NSArray *entrySet       = tuple.first;
    NSArray *groups         = [NSArray modelArrayWithClass:[KMGroupInfo class] json:entrySet];
            [self.groupArr removeAllObjects];
            for (KMGroupInfo *gInfo in groups) {
    KMGroupOrderInfo *dInfo = [KMGroupOrderInfo new];
    dInfo.groupID           = gInfo.groupid;
    dInfo.groupName         = gInfo.groupname;
                [self.groupArr addObject:dInfo];
            }
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //添加新套餐
    _addNewPackageCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi addGroupPackage:[self newPackageParams]] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //删除套餐
    _deleCommand            = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi delePackageWithPackageID:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //获取修改信息
    _editInfoCommand        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi waitEditPackageInfo:input] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *t             = x;
    NSArray *entrySet       = t.first;
    self.editPackageInfo    = [KMEditPackageInfo modelWithJSON:entrySet.firstObject];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];

    //提交修改
    _commitEditCommand      = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi editPackageWith:[self editPackageParams]] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

#pragma mark - Lazy -
-(NSMutableArray *)packageArr{
    if (!_packageArr) {
    _packageArr             = [NSMutableArray array];
    }
    return _packageArr;
}
-(NSMutableArray *)groupArr{
    if (!_groupArr) {
    _groupArr               = [NSMutableArray array];
    }
    return _groupArr;
}
@end
