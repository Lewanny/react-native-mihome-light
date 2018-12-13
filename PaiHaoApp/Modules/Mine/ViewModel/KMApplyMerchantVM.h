//
//  KMApplyMerchantVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMNewGroupCell.h"
@interface KMApplyMerchantVM : KMBaseViewModel
/** 全称 */
@property (nonatomic, copy) NSString * fullname;
/** 省 */
@property (nonatomic, copy) NSString * province;
/** 市 */
@property (nonatomic, copy) NSString * city;
/** 区 */
@property (nonatomic, copy) NSString * area;
/** 详细地址 */
@property (nonatomic, copy) NSString * address;
/** 电话 */
@property (nonatomic, copy) NSString * telephone;
/** 邮箱 */
@property (nonatomic, copy) NSString * mail;
/** 简介 */
@property (nonatomic, copy) NSString * synopsis;

@property (nonatomic, strong) RACCommand * applyCommand;

-(void)edit:(id)data IndexPath:(NSIndexPath *)indexPath;

-(BOOL)verifyData;

#pragma mark - DataSouce -
-(NewGroupCellStyle)cellStyleWithIndexPath:(NSIndexPath *)indexPath;
-(NSString *)rightTextWithIndexPath:(NSIndexPath *)indexPath;
-(NSArray *)leftTextArr;
-(NSArray *)placeHolderArr;
@end
