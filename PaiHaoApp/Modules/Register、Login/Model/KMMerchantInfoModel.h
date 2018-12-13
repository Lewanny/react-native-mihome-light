//
//  KMMerchantInfoModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 商家完善信息 */
@interface KMMerchantInfoModel : NSObject
/** 姓名 */
@property (nonatomic, copy) NSString * userName;
/** 头像 */
@property (nonatomic, copy) NSString * headportrait;
/** 手机号码 */
@property (nonatomic, copy) NSString * phone;
/** 商户全称 */
@property (nonatomic, copy) NSString * businessName;
/** 省 */
@property (nonatomic, copy) NSString * groupprovince;
/** 市 */
@property (nonatomic, copy) NSString * groupcity;
/** 区域 */
@property (nonatomic, copy) NSString * grouparea;
/** 详细地址 */
@property (nonatomic, copy) NSString * UserAddress;
/** 固定电话 */
@property (nonatomic, copy) NSString * telephone;
/** 邮箱 */
@property (nonatomic, copy) NSString * mail;
/** 商户简介 */
@property (nonatomic, copy) NSString * synopsis;
@end
