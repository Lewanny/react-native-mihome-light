//
//  KMUserManager.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KM_EnumerateHeader.h"

@class KMUserLoginModel;

@interface KMUserManager : NSObject

@property (nonatomic, strong) KMUserLoginModel * userLoginModel;


/**
 获取单例
 
 @return shareInstance
 */
+ (id)shareInstance;
/** 登录 */
-(void)loginWithUserName:(NSString *)userName
                Password:(NSString *)password
                 Success:(Block_Obj)success
                 Failure:(Block_Err)failure;


/** 获取验证码 */
-(void)requestSecurityCodeWithTele:(NSString *)tele
                           Success:(Block_Str)success
                           Failure:(Block_Err)failure;
/** 检查是否已经注册 ret = YES 手机号码还没注册 ret = NO 手机号码已经注册 */
-(void)checkAccountRegisterStatus:(NSString *)tele
                         CallBack:(Block_Bool)callBack;

/** 注册 */
-(void)registerWithTele:(NSString *)tele
                   Code:(NSString *)code
              Password1:(NSString *)password1
              Password2:(NSString *)password2
               UserType:(KM_UserType)userType
                Success:(Block_Str)success
                Failure:(Block_Err)failure;

/** 找回密码 */
-(void)changePwdWithTele:(NSString *)tele
                   Code:(NSString *)code
              Password1:(NSString *)password1
              Password2:(NSString *)password2
                Success:(Block_Bool)success
                 Failure:(Block_Err)failure;

/**
 是否登录
 
 @param needPresent 如果没登录是否跳转登录
 @return 是否登录
 */
+(BOOL)checkLoginWithPresent:(BOOL)needPresent;
/** 保存登录数据 */
+(void)loginSuccess:(KMUserLoginModel *)userLoginModel;
/** 获取之前保存在本地登录返回的模型 */
+(KMUserLoginModel *)getLoginModel;

/** 退出登录 */
+(void)logout;

/** 跳转队列详情 */
+(void)pushDetailWithGroupID:(NSString *)groupID;

/** 跳转二维码 */
+(void)pushQRCodeVCWithData:(id)data;

@end
