//
//  KMCompleteBusinessInfoViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCompleteBusinessInfoViewModel.h"

@implementation KMCompleteBusinessInfoViewModel

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    //保存信息
    _saveCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi commpleteMerchantInfoWithAccountId:self.accountId MerchanInfo:self.info] doNext:^(id  _Nullable x) {
            //保存成功
            [SVProgressHUD showSuccessWithStatus:@"保存成功" Duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.successSubject sendNext:nil];
            });
        }] doError:^(NSError * _Nonnull error) {
            //保存失败
            [SVProgressHUD showErrorWithStatus:@"保存失败" Duration:1];
        }];
    }];
}

/** 更新地址信息 */
-(void)updateLocationWithCLPlacemark:(CLPlacemark *)placemark{
    //获取城市
    NSString *city = placemark.locality;
    if (!city) {
        //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
        city = placemark.administrativeArea;
    }
    //获取区
    NSString *subLocality = placemark.subLocality;
    //获取街道
    NSString *name = placemark.name;
    NSString *locationStr = NSStringFormat(@"%@%@",subLocality,name);
    KMLog(@"当前位置 ===  %@",locationStr);//具体位置
    self.info.groupcity = city;
    self.info.groupprovince = placemark.administrativeArea;
    self.info.grouparea = city;
    self.info.UserAddress = locationStr;
}

/** 验证数据完整 */
-(BOOL)verifyInfoData{
    BOOL ret = YES;
    
    KMMerchantInfoModel *info = self.info;
    
    if (info.userName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入姓名" Duration:1];
        ret = NO;
    }else if (info.headportrait.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请上传头像" Duration:1];
        ret = NO;
    }else if (info.phone.length != 11){
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码" Duration:1];
        ret = NO;
    }else if (info.businessName.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入商户全称" Duration:1];
        ret = NO;
    }else if (info.grouparea.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入区域" Duration:1];
        ret = NO;
    }else if (info.UserAddress.length == 0){
        [SVProgressHUD showInfoWithStatus:@"没有获取到定位信息" Duration:1];
        ret = NO;
    }else if (info.telephone.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入电话号码" Duration:1];
        ret = NO;
    }else if (![info.mail isEmailAddress]){
        [SVProgressHUD showInfoWithStatus:@"请输入邮箱地址" Duration:1];
        ret = NO;
    }else if (info.synopsis.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入商家简介" Duration:1];
        ret = NO;
    }
    return ret;
}
/** 拿出要修改的文字 */
-(NSString *)needCompeleTextWithIndexPath:(NSIndexPath *)indexPath{
    NSString *text = nil;
    KMMerchantInfoModel * info = self.info;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                text = info.userName;
                break;
            case 2:
                text = info.phone;
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                text = info.businessName;
                break;
            case 1:
            case 2:
                text = nil;
                break;
            case 3:
                text = info.telephone;
                break;
            case 4:
                text = info.mail;
                break;
            case 5:
                text = info.synopsis;
                break;
            default:
                break;
        }
    }
    return text;
}
/** 修改完成赋值 */
-(void)compeleText:(NSString *)text IndexPath:(NSIndexPath *)indexPath{
    KMMerchantInfoModel * info = self.info;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                info.userName = text;
                break;
            case 2:
                info.phone = text;
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                info.businessName = text;
                break;
            case 1:
            case 2:
                
                break;
            case 3:
                info.telephone = text;
                break;
            case 4:
                info.mail = text;
                break;
            case 5:
                info.synopsis = text;
                break;
            default:
                break;
        }
    }
    self.info = info;
}
/** 左边标题 */
-(NSArray *)leftText{
    return @[
             @[
               @"姓名",
               @"头像",
               @"手机"
             ],
             @[
               @"商户全称",
               @"区域",
               @"详细地址",
               @"电话",
               @"邮箱",
               @"商家简介"
              ]
           ];
}
/** 右边占位文字 */
-(NSArray *)placeholders{
    return @[
             @[@"请输入姓名",@"",@"请输入手机号码"],
             @[@"请输入商户全称",@"正在定位",@"正在定位",@"请输入电话号码",@"请输入邮箱",@"请输入商家简介"]
            ];
}
/** 完善信息控制器标题 */
-(NSArray *)titles{
    return [self leftText];
}
#pragma mark - Lazy
-(KMMerchantInfoModel *)info{
    if (!_info) {
        _info = [[KMMerchantInfoModel alloc]init];
    }
    return _info;
}
-(RACSubject *)successSubject{
    if (!_successSubject) {
        _successSubject = [RACSubject subject];
    }
    return _successSubject;
}
@end
