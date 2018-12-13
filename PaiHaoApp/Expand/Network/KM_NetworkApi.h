//
//  KM_NetworkApi.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
/** http://112.124.3.157:8100/Image/ */
@interface KM_NetworkApi : NSObject
/** 请求基地址 */
+(NSString *)hostUrl;
/** 图片地址 */
+(NSString *)imagePrefixUrl;
/** 接口地址：http://112.124.3.157:8100/UploadImage.ashx
 Post上传 文件name为”fieldName”
 返回图片名称。其完整路径是：http://112.124.3.157:8100/Image/+ 系统返回路径
 */
+(NSString *)uploadImageUrl;

#pragma mark - 首页与注册接口
/** 推荐号群 */
+(RACSignal *)requestRecommendGroup;
/** 我的排号（先登录) */
+(RACSignal *)requestMineQueue;
/** 根据行业分类获取号群列表 */
+(RACSignal *)requestQueueListWithCategory:(NSString *)category
                                     Index:(NSInteger)index
                                    Status:(NSInteger)status
                                      City:(NSString *)city;


/** 登录 */
+(RACSignal *)loginWithUserName:(NSString *)userName
                       Password:(NSString *)password
                      LoginType:(KM_LoginType)loginType;
/** 获取验证码 */
+(RACSignal *)requestSecurityCodeWithTele:(NSString *)tele;

/** 检查注册状态 没注册过的才继续注册 */
+(RACSignal *)checkAccountRegisterStatus:(NSString *)tele;

/**
 提交注册

 @param tele 电话号码
 @param password  输入密码
 @param userType  用户类型
 @return RACSignal
 */
+(RACSignal *)commitRegisterWithTele:(NSString *)tele
                            Password:(NSString *)password
                            UserType:(KM_UserType)userType;

/**
 找回密码

 @param newPassword 新密码
 @param tele 电话号码
 @return RACSignal
 */
+(RACSignal *)commitNewPassword:(NSString *)newPassword
                           Tele:(NSString *)tele;

/**
 完善用户信息

 @param accountId 账户ID
 @param userName 用户名
 @param mail 邮箱
 @param location 定位
 @return RACSignal
 */
+(RACSignal *)completeUserInfoWithAccountId:(NSString *)accountId
                                   UserName:(NSString *)userName
                                      Mail:(NSString *)mail
                                  Location:(NSString *)location;

/**
 完善商户信息

 @param accountId 账户ID
 @param merchanInfo 商户信息
 @return RACSignal
 */
+(RACSignal *)commpleteMerchantInfoWithAccountId:(NSString *)accountId
                                     MerchanInfo:(KMMerchantInfoModel *)merchanInfo;


/**
 上传图片

 @param imageArr 图片数组
 @param fieldNameArr 文件名数组
 @return RACSignal
 */
+(RACSignal *)uploadImages:(NSArray<UIImage *> *)imageArr
                FieldNames:(NSArray<NSString *> *)fieldNameArr;

/** 获取行业类别 */
+(RACSignal *)requestMerchantType;

#pragma mark - 会员中心
/** 获取个人信息 */
+(RACSignal *)requestUserInfo;
/** 获取普通用户详情 */
+(RACSignal *)requestUserDeatil;
/** 修改个人用户姓名 */
+(RACSignal *)editUserName:(NSString *)userName;
/** 修改头像 */
+(RACSignal *)editHeadPortrait:(NSString *)url;
/** 验证姓名是否已被占用 */
+(RACSignal *)checkNicknameStatus:(NSString *)nickname;
/** 修改手机号 */
+(RACSignal *)editPhone:(NSString *)phone;
/** 修改邮箱 */
+(RACSignal *)editMail:(NSString *)mail;
/** 修改地址 */
+(RACSignal *)editAddr:(NSString *)addr;
/** 修改区域 */
+(RACSignal *)editAreaWithProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area;
/** 修改电话号码 */
+(RACSignal *)editTelephoneWithTel:(NSString *)telephone;
/** 修改行业 */
+(RACSignal *)editMerchantWithID:(NSString *)merchantID;

/** 获取商户详情 */
+(RACSignal *)businessUserInfo;
/** 修改商户图片 */
+ (RACSignal *)editPictrue:(NSString *)pictrue;
/** 修改商户名称 */
+ (RACSignal *)editBusinessName:(NSString *)businessName;
/** 更改商家简介 */
+(RACSignal *)editSynopsis:(NSString *)synopsis;
/** 历史排号 */
+(RACSignal *)queueHistory;
/** 我的收藏列表 */
+(RACSignal *)collectionQueue;
/** 删除历史排队 */
+(RACSignal *)delHistoryQueue:(NSString *)queueID;
/** 删除收藏 */
+(RACSignal *)delCollectionQueue:(NSString *)queueID;
/** 服务窗口列表 */
+(RACSignal *)serviceWindowList;
/** 删除窗口 */
+(RACSignal *)deleWindowWithID:(NSString *)winID;
/** 添加窗口 */
+(RACSignal *)addWindowWithName:(NSString *)winName
                           Info:(NSString *)winInfo;
/** 呼叫员列表 */
+(RACSignal *)callerList;
/** 删除呼叫员 */
+(RACSignal *)deleCallerWithAccountId:(NSString *)accountId
                               UserId:(NSString *)userId;
/** 添加呼叫员 */
+(RACSignal *)addCallerUserName:(NSString *)userName
                      LoginName:(NSString *)loginName
                       LoginPwd:(NSString *)loginPwd;
/** 普通用户升级商户 */
+(RACSignal *)applyMerchantWithData:(RACTuple *)data;
/** 普通商户升级认证商户 */
+(RACSignal *)updateMerchantWithData:(RACTuple *)data;
/** 语音提醒设置 */
+(RACSignal *)editReminderSettings:(BOOL)setting;
#pragma mark - 我的消息
/** 我的消息 动态消息 */
+(RACSignal *)messageDT;
/** 添加浏览记录  0浏览内容，1浏览评论,2浏览反馈信息  */
+(RACSignal *)addBrowsingHistoryWithMsgID:(NSString *)msgID Mode:(NSNumber *)mode;
/** 提交反馈 */
+(RACSignal *)feedbackWithMessage:(NSString *)message;
/** 获取排行提醒未读消息数量 */
+(RACSignal *)queueMessageNumber;
/** 获取回馈的详细内容 */
+(RACSignal *)feedbackInfoWithMsgID:(NSString *)msgID;
/** 获取通知信息接口 */
+(RACSignal *)remindInfoWithPage:(NSInteger)page;
/** 动态消息未读数量 */
+(RACSignal *)dynamicNumber;
/** 未读消息 */
+(RACSignal *)messageNumber;

/** 删除消息 */
+(RACSignal *)deleMessageWithMsgID:(NSString *)msgID;

#pragma mark - 号群
/** 我的号群列表 */
+(RACSignal *)userGroupInfo;
/** 判断号群是否被当前用户收藏 */
+(RACSignal *)checkCollectionStatusWithGroupId:(NSString *)groupID;
/** 收藏号群 */
+(RACSignal *)addCollectionWithGroupID:(NSString *)groupID;
/** 取消收藏 */
+(RACSignal *)cancelCollectionWithColID:(NSString *)colID;
/** 加载号群详细信息 */
+(RACSignal *)groupDetailInfoWithID:(NSString *)groupID;
/** 加载号群排队信息 */
+(RACSignal *)queueDataByGroupID:(NSString *)groupID WinID:(NSString *)winID;
/** 窗口分配--加载当前用户名下未分配的窗口 */
+(RACSignal *)unabsorbedWindow;
/** 呼叫选择窗口列表 */
+(RACSignal *)bindedWindowWithGroupID:(NSString *)groupID;
/** 获取当前号群已经绑定的窗口列表 窗口解绑列表 */ //GetWindowInfoByGroupIdEx
+(RACSignal *)windowWithGroupID:(NSString *)groupID;

/** 设置当前呼叫窗口（设置当前叫号窗口的窗口号，进行呼叫） */
+(RACSignal *)bindCallWindowWithWindowID:(NSString *)windowID;

/** 号群绑定窗口 窗口ID串，多个以3个“#”分割 */
+(RACSignal *)bindWindow:(NSString *)windowID Group:(NSString *)groupID;
/** 号群解绑窗口 窗口ID串，多个以3个“#”分割 */
+(RACSignal *)unbindWindow:(NSString *)windowID;
/** 搜索号群 */
+(RACSignal *)searchGroupWithKeyword:(NSString *)keyword Index:(NSInteger)index;

/** 过号 */
+(RACSignal *)singleExpireWithQueueID:(NSString *)queueID
                              GroupID:(NSString *)groupID;
/** 呼叫当前 */
+(RACSignal *)callCurrentWithQueueID:(NSString *)queueID;
/** 下一位 */
+(RACSignal *)callNextWithQueueID:(NSString *)queueID
                          GroupID:(NSString *)groupID;
/** 暂停 */
+(RACSignal *)suspendWithQueueID:(NSString *)queueID;
/** 解散 */
+(RACSignal *)disbandWithGroupID:(NSString *)groupID;
/** 删除号群 */
+(RACSignal *)deleGroupWithID:(NSString *)groupID;
/** 现场排号 */
+(RACSignal *)sceneQueueWithGrouoID:(NSString *)groupID UserID:(NSString *)userID;
/** 获取票据信息 */
+(RACSignal *)billInfoWithGroupID:(NSString *)groupID BespeakSort:(NSString *)bespeakSort;


/** 加载续建信息 */
+(RACSignal *)groupTimeInfoWithGroupID:(NSString *)groupID;

/** 也是加载续建信息 */
+(RACSignal *)groupAutoTimeInfoWithGroupID:(NSString *)groupID;

/** 提交 手动续建 */
+(RACSignal *)editGroupWaitTimeWithData:(RACTuple *)data;
/** 提交 自动续建 */
+(RACSignal *)editAutoGroupTimeWithData:(NSDictionary *)data;

/** 加载原来的号群信息 */
+(RACSignal *)originalGroupInfoWithID:(NSString *)groupID;
/** 新建号群 */
+(RACSignal *)addNewGroupWithData:(NSDictionary *)data;
/** 编辑号群 */
+(RACSignal *)editGroupInfoWithData:(NSDictionary *)data;

#pragma mark - 批量叫号 -
/** 批量叫号 排队列表信息 */ //GetQueueDataByGroupIds
+(RACSignal *)batchQueueDataWithGroupID:(NSString *)groupID
                                 Number:(NSInteger)number
                               WindowID:(NSString *)windowID;
/** 批量叫号 结束上一批 */
+(RACSignal *)batchEndLastWithQueueIDs:(NSString *)queueIDs
                               GroupID:(NSString *)groupID;
/** 批量暂停 */
+(RACSignal *)batchSuspendWithQueueIDs:(NSString *)queueIDs;
/** 加载数据成功后修改列表中数据状态为办理中 */
+(RACSignal *)editQueueStateWithQueueIDs:(NSString *)queueIDs WinID:(NSString *)winID;
#pragma mark - 排号
/** 查看是否已经排队 */
+(RACSignal *)checkQueueInfo:(NSString *)groupID;
/** 号群信息 */
+(RACSignal *)groupInfoWithGroupID:(NSString *)groupID;
/** 获取号群评论信息 */
+(RACSignal *)commentListWithGroupId:(NSString *)groupID;
/** 参加排号 */
+(RACSignal *)joinQueueWithGroupID:(NSString *)groupID
                           isVoice:(BOOL)isVoice
                             isSms:(BOOL)isSms
                           minutes:(NSNumber *)minutes;
/** 套餐参加排号 */
+(RACSignal *)joinQueueWithPackageID:(NSString *)packageID;

/** 为他人进行套餐排队 */
+(RACSignal *)joinQueueWithPackageID:(NSString *)packageID
                              UserID:(NSString *)userID;

/** 退出排号 参数 userID groupID */
+(RACSignal *)exitQueueWithGroupID:(NSString *)groupID;
/** 退出排号 参数 queueID */
+(RACSignal *)exitQueueWithQueueID:(NSString *)queueID;

/** 我的排队详情 */
+(RACSignal *)queueDetailWithQueueID:(NSString *)queueID
                             GroupID:(NSString *)groupID;
/** 我的排队详情---获取当前排队号，需等候时间 */
+ (RACSignal *)queueDetailInfoWithQueueID:(NSString *)queueID
                                  GroupID:(NSString *)groupID;

/** 提交评论 */
+(RACSignal *)addCommentWithQueueID:(NSString *)queueID
                              Score:(NSNumber *)score
                            Comment:(NSString *)comment;
#pragma mark - 套餐
/** 通过号群ID获取套餐信息 */
+(RACSignal *)packageLists:(NSString *)groupID;
/** 获取用户套餐信息 */
+(RACSignal *)userPackageList;
/** 新增套餐 */
+(RACSignal *)addGroupPackage:(NSDictionary *)param;
/** 删除套餐 */
+(RACSignal *)delePackageWithPackageID:(NSString *)packageID;
/** 编辑套餐页面数据 */
+(RACSignal *)waitEditPackageInfo:(NSNumber *)packageID;
/** 提交修改套餐数据 */
+(RACSignal *)editPackageWith:(NSDictionary *)param;
/** 套餐进度 */
+(RACSignal *)packageSchedule:(NSString *)packageID;
/** 判断套餐中号群是否有的已经排队 */
+(RACSignal *)checkPackageWithID:(NSString *)packageID;

/**
 首页--景区等--进入排号详情

 @param groupID <#groupID description#>
 @param winID <#winID description#>
 @return <#return value description#>
 */
+ (RACSignal *)screenqueueDetailByGroundId:(NSString *)groupID WinID:(NSString *)winID;
@end
