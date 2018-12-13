//
//  GVUserDefaults+KMProperties.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "GVUserDefaults.h"

#define KMUserDefault [GVUserDefaults standardUserDefaults]

@interface GVUserDefaults (KMProperties)

#pragma mark - 用户资料相关
/** 用户名 */
@property (nonatomic, weak) NSString * userName;
/** 用户ID */
@property (nonatomic, weak) NSString * userID;
/** 账户ID */
@property (nonatomic, weak) NSString * accountID;
/** 固定电话 */
@property (nonatomic, weak) NSString * telephone;
#pragma mark - 验证码
/** 验证码 */
@property (nonatomic, weak) NSString * verification;

#pragma mark - 是否第一次启动本次版本号的APP
/** 是否第一次启动本次版本号的APP */
@property (nonatomic,assign) BOOL isNoFirstLaunch;

#pragma mark - 版本号
/** APP版本号 */
@property (nonatomic, weak) NSString * appVersion;

#pragma mark - 是否已经登录
/** 是否已经登录 */
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, weak) NSString * isVoice;

@property (nonatomic, weak) NSString * isSms;

@end
