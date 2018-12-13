//
//  KMBusinessUpgradeVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBusinessUpgradeVM.h"

@implementation KMBusinessUpgradeVM

-(void)km_bindNetWorkRequest{
    @weakify(self)
    _updateCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
    RACTuple *t    = RACTuplePack(self.fullname, self.certificates, self.certificatespicture, self.contacts, self.phone);
        return [[[KM_NetworkApi updateMerchantWithData:t] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

-(BOOL)verifyData{
    if (!_fullname.length) {
        [SVProgressHUD showInfoWithStatus:self.placeHolderArr[0][0] Duration:1];
        return NO;
    }
    if (!_certificates.length) {
        [SVProgressHUD showInfoWithStatus:self.placeHolderArr[0][1] Duration:1];
        return NO;
    }
    if (!_certificatespicture.length) {
        [SVProgressHUD showInfoWithStatus:self.placeHolderArr[0][2] Duration:1];
        return NO;
    }
    if (!_contacts.length) {
        [SVProgressHUD showInfoWithStatus:self.placeHolderArr[1][0] Duration:1];
        return NO;
    }
    if (!_phone.length) {
        [SVProgressHUD showInfoWithStatus:self.placeHolderArr[1][1] Duration:1];
        return NO;
    }
    return YES;
}

-(void)edit:(id)data IndexPath:(NSIndexPath *)indexPath{
    if (![data isKindOfClass:[NSString class]]) {
        return;
    }
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
    _fullname      = data;//商户全称
                    break;
                case 1:
    _certificates  = data;//营业执照号
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:
    _contacts      = data;//联系人姓名
                    break;
                case 1:
    _phone         = data;//联系人手机
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(NSString *)valueForIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                    return _fullname;//商户全称
                    break;
                case 1:
                    return _certificates;//营业执照号
                    break;
                case 2:
                    return _certificatespicture;//营业执照图片
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:
                    return _contacts;//联系人姓名
                    break;
                case 1:
                    return _phone;//联系人手机
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return @"";
}

-(NSArray *)leftTextArr{
    return @[@[@"商户全称", @"营业执照号", @"营业执照图片"], @[@"联系人姓名", @"联系人手机"]];
}
-(NSArray *)placeHolderArr{
    return @[@[@"请填写商户全称", @"请填写营业执照号", @"请上传营业执照图片"], @[@"请填写联系人姓名", @"请填写联系人手机"]];
}
@end
