//
//  KMUserDetailModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/27.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMUserDetailModel : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 手机号 */
@property (nonatomic, copy) NSString *phone;
/** 电子邮件 */
@property (nonatomic, copy) NSString *mail;
/** 头像（普通用户） */
@property (nonatomic, copy) NSString *headportrait;
/** 微信ID */
@property (nonatomic, copy) NSString *weixin;
/** 用户地址 */
@property (nonatomic, copy) NSString *address;
@end
