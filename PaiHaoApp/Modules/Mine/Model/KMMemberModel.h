//
//  KMMemberModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/27.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMMemberModel : NSObject
/** 手机号 */
@property (nonatomic, copy) NSString *phone;
/** 商户全称 */
@property (nonatomic, copy) NSString *businessname;
/** 图片（商户） */
@property (nonatomic, copy) NSString *picture;
/** 头像（普通用户） */
@property (nonatomic, copy) NSString *headportrait;
/** 商户类型（0，普通用户；1，普通商户；2，高级商户；3.白金商户） */
@property (nonatomic, copy) NSString *customertype;
/** 信用值 */
@property (nonatomic, assign) CGFloat creditscore;
/** 用户名 */
@property (nonatomic, copy) NSString * username;
@end
