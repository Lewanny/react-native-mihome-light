//
//  KMBusinessUserModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/28.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMBusinessUserModel : NSObject
/** 商户名称 */
@property (nonatomic, copy) NSString *businessname;
/** 手机号 */
@property (nonatomic, copy) NSString *phone;
/** 简介 */
@property (nonatomic, copy) NSString *synopsis;
/** 头像（普通用户） */
@property (nonatomic, copy) NSString *headportrait;
/** 商户图片 */
@property (nonatomic, copy) NSString *picture;
/** 区 */
@property (nonatomic, copy) NSString *area;
/** 省 */
@property (nonatomic, copy) NSString *province;
/** 微信ID */
@property (nonatomic, copy) NSString *weixin;
/** 用户地址 */
@property (nonatomic, copy) NSString *address;
/** 行业类型 */
@property (nonatomic, copy) NSString *merchantid;
/** 市 */
@property (nonatomic, copy) NSString *city;
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 电话号码 */
@property (nonatomic, copy) NSString *telephone;
/** 邮箱 */
@property (nonatomic, copy) NSString *mail;
@end
