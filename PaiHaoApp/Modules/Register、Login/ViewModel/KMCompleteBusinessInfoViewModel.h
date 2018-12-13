//
//  KMCompleteBusinessInfoViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMMerchantInfoModel.h"
@interface KMCompleteBusinessInfoViewModel : KMBaseViewModel
/** 账户ID */
@property (nonatomic, copy) NSString * accountId;
/** 商户信息 */
@property (nonatomic, strong) KMMerchantInfoModel * info;
/** 保存信息 */
@property (nonatomic, strong) RACCommand * saveCommand;
/** 保存成功 */
@property (nonatomic, strong) RACSubject * successSubject;


/** 更新地址信息 */
-(void)updateLocationWithCLPlacemark:(CLPlacemark *)placemark;
/** 验证数据完整 */
-(BOOL)verifyInfoData;
/** 拿出要修改的文字 */
-(NSString *)needCompeleTextWithIndexPath:(NSIndexPath *)indexPath;
/** 修改完成赋值 */
-(void)compeleText:(NSString *)text IndexPath:(NSIndexPath *)indexPath;

/** 左边标题 */
-(NSArray *)leftText;
/** 右边占位文字 */
-(NSArray *)placeholders;
/** 完善信息控制器标题 */
-(NSArray *)titles;
@end
