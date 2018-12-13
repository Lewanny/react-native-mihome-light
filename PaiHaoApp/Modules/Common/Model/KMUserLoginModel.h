//
//  KMUserLoginModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMUserLoginParamsModel : NSObject
/** 用户ID */
@property (nonatomic, copy) NSString * userId;
/** 用户类型 */
@property (nonatomic, copy) NSString * customerType;
/** 父级用户userid */
@property (nonatomic, copy) NSString * pid;
/** 角色码（0，默认管理员（号群管理员），1，呼叫员（由于管理员添加，只有呼叫权限）） */
@property (nonatomic, copy) NSString * rolecode;
/** 信用值 */
@property (nonatomic, copy) NSString * creditscore;
/** 不知道 */
@property (nonatomic, copy) NSString * resettime;
/** 固定电话 */
@property (nonatomic, copy) NSString * telephone;

@property (nonatomic, copy) NSString * isVoice;

@property (nonatomic, copy) NSString * isSms;

@end

/** 登录成功以后返回的模型 */
@interface KMUserLoginModel : KMBaseModel

@property (nonatomic, copy) NSString *mail;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *loginName;
/** accountId */
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *registerTime;

@property (nonatomic, copy) NSString *isValid;

@property (nonatomic, copy) NSString *reserve;

@property (nonatomic, copy) NSString *loginPwd;

@property (nonatomic, strong) KMUserLoginParamsModel * info;


@end
