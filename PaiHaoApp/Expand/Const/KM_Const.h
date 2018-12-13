//
//  KM_Const.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMLogService.h"

//static const CGFloat kTabBarHeight = 49.0;

#define kTabBarHeight (isiPhoneX ? 83.0 : 49.0)

#define kNavHeight   (isiPhoneX ? 88.0 : 64.0)

#pragma mark - 通知
/** 登录 */
static NSString * const kLoginNotiName = @"loginNotification";
/** 退出登录 */
static NSString * const kLogoutNotiName = @"logoutNotification";
/** 定位成功 */
static NSString * const kPositioningSuccess = @"kPositioningSuccess";


#pragma mark - key值

/** NSUserDefaults Key */
static NSString * const kUserLoginModel = @"UserLoginModel";
static NSString * const kIsUserLogin = @"isUserLogin";
/** 当前城市 */
static NSString * const kCurrentCity = @"CurrentCity";
/** 定位到城市 */
static NSString * const kLocationCity = @"LocationCity";


/** 请求/返回 的数据格式key */
static NSString * const kActionName = @"actionName";
static NSString * const kStatus = @"status";
static NSString * const kTimeStamp = @"timeStamp";
static NSString * const kToken = @"token";
static NSString * const kEntrySet = @"entrySet";
static NSString * const kParamsSet = @"paramsSet";

/** 请求返回的字典 格式key */
static NSString * const kName = @"name";
static NSString * const kValue = @"value";

/** 登录参数 的 key */
static NSString * const kLoginName = @"LoginName";
static NSString * const kLoginPwd = @"LoginPwd";
static NSString * const kMode = @"mode";

/** 验证码参数 的 key */
static NSString * const kMobile = @"mobile";
static NSString * const kType = @"type";
static NSString * const kTypeValue = @"155767";

/** 验证码 key */
static NSString * const kVerification = @"verification";

/** 检查是否已经注册 */
static NSString * const kLoginname = @"loginname";
static NSString * const kResult = @"result";


/** 注册参数 的 key */
static NSString * const kLoginpwd = @"loginpwd";
static NSString * const kPhone = @"phone";
static NSString * const kAuditstatus = @"auditstatus";

/** 找回密码 的 key */
static NSString * const kloginPwd = @"loginPwd";

/** 完善用户信息 */
static NSString * const kAccountId = @"accountId";
static NSString * const kloginName = @"loginName";
static NSString * const kMail = @"mail";
static NSString * const kAddress = @"address";

/** 获取用户信息 */
static NSString * const kUserId = @"userId";

/** 修改用户姓名 */
static NSString * const kUsername = @"username";

/** 修改头像 */
static NSString * const kHeadportrait = @"headportrait";
/** 修改地址 */
static NSString * const kUserAddress = @"userAddress";

/** 修改商户名称 */
static NSString * const kBusinessname = @"businessname";
/** 更改商家简介 */
static NSString * const kSynopsis = @"synopsis";

/** 删除历史排队 删除收藏排队 */
static NSString * const kId = @"Id";
/** 自定义的网络请求错误key */
static NSString * const kErrmsg = @"errmsg";
static NSString * const kErrStatus = @"errstatus";


/** 保存行业分类信息 Key */
static NSString * const kCategoryType = @"categoryType";

/** 查找队列 key */
static NSString * const kKeyword = @"keyword";
static NSString * const kProv = @"prov";
static NSString * const kCity = @"city";
static NSString * const kDist = @"dist";
static NSString * const kCategory = @"category";

/** 参加排号 */
static NSString * const kTickets = @"tickets";

/** 套餐ID */
static NSString * const kPackageID = @"packageId";
/** 队列ID */
static NSString * const kGroupId = @"groupId";

/** 排号ID */
static NSString * const kQueueId = @"queueId";

static NSString * const kComment = @"comment";

/** 评分 */
static NSString * const kScore = @"score";
/** 查看历史Key */
static NSString * const kHistory = @"history";

static NSString * const kCurrentqueueid = @"currentqueueid";
static NSString * const kWorkerId = @"workerId";

/** 队列时间 */
static NSString * const kStartWaitTime = @"startWaitTime";
static NSString * const kEndWaitTime = @"endWaitTime";

/** 队列排队信息 */
static NSString * const kSingleNumber = @"singleNumber";
static NSString * const kWindowId = @"windowId";

/** 服务窗口列表 */
static NSString * const kuserid = @"userid";
