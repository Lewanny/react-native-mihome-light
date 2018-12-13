//
//  KMApplyMerchantVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMApplyMerchantVM.h"

@implementation KMApplyMerchantVM

-(void)km_bindNetWorkRequest{
    @weakify(self)
    _applyCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
    RACTuple *t   = RACTuplePack(self.fullname, self.province, self.city, self.area, self.address, self.telephone, self.mail, self.synopsis);
        return [[[KM_NetworkApi applyMerchantWithData:t] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

-(BOOL)verifyData{
    if (!_fullname.length) {
        [SVProgressHUD showInfoWithStatus:[self.placeHolderArr objectAtIndex:0] Duration:1];
        return NO;
    }
    if (!_province.length) {
        [SVProgressHUD showInfoWithStatus:[self.placeHolderArr objectAtIndex:1] Duration:1];
        return NO;
    }
    if (!_address.length) {
        [SVProgressHUD showInfoWithStatus:[self.placeHolderArr objectAtIndex:2] Duration:1];
        return NO;
    }
    if (!_telephone.length) {
        [SVProgressHUD showInfoWithStatus:[self.placeHolderArr objectAtIndex:3] Duration:1];
        return NO;
    }
    if (!_mail.length) {
        [SVProgressHUD showInfoWithStatus:[self.placeHolderArr objectAtIndex:4] Duration:1];
        return NO;
    }
    if (!_synopsis.length) {
        [SVProgressHUD showInfoWithStatus:[self.placeHolderArr objectAtIndex:5] Duration:1];
        return NO;
    }
    return YES;
}

-(void)edit:(id)data IndexPath:(NSIndexPath *)indexPath{
    if (![data isKindOfClass:[NSString class]]) {
        return;
    }
    switch (indexPath.row) {
        case 0:
    _fullname     = data;
            break;
        case 2:
    _address      = data;
            break;
        case 3:
    _telephone    = data;
            break;
        case 4:
    _mail         = data;
            break;
        case 5:
    _synopsis     = data;
            break;
        default:
            break;
    }
}

-(NewGroupCellStyle)cellStyleWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 5) {
        return NewGroupCellStyleLabel;
    }else{
        return NewGroupCellStyleTextField;
    }
}
-(NSString *)rightTextWithIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return _fullname;
            break;
        case 1:
            return _province.length ? NSStringFormat(@"%@ %@ %@",_province, _city, _area) : @"";
            break;
        case 2:
            return _address;
            break;
        case 3:
            return _telephone;
            break;
        case 4:
            return _mail;
            break;
        case 5:
            return _synopsis;
            break;
        default:
            break;
    }
    return @"";
}
-(NSArray *)leftTextArr{
    return @[@"商户全称", @"区域", @"详细地址", @"电话", @"邮箱", @"商家简介"];
}
-(NSArray *)placeHolderArr{
    return @[@"请填写商户全称", @"请选择区域", @"请填写详细地址", @"请填写电话", @"请填写邮箱", @"请填写商家简介"];
}
@end
