//
//  KM_NetworkActionName.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/20.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KM_NetworkActionName : NSObject
#pragma mark - 首页与注册接口
/** 推荐队列 */
+(NSString *)MobileGetShowGroup;
/** 我的排号（先登录） */
+(NSString *)MobileGetUserQueueInfo;
/** 查找队列 */
+(NSString *)MobileGetSearchGroup;
/** 获取行业分类信息（队列行业分类和商户行业分类相同） */
+(NSString *)GetMerchantType;
/** 获取验证码 */
+(NSString *)AHSMSEx;
/** 验证账号或手机号是否已经注册 */
+(NSString *)MobileCheckAccount;
/** 注册用户接口 */
+(NSString *)MobileRegister;
/** 完善用户信息 */
+(NSString *)MobileImproveUserInfo;
/** 完善商户信息 */
+(NSString *)MobileImproveMerchantInfo;
/** 修改密码（先验证用户输入手机号是否注册，注册则发送短信验证码，验证通过进入修改密码页面。） */
+(NSString *)MobileModifyPassWord;
/** 登录 */
+(NSString *)MobileLogin;
#pragma mark - 队列接口
/** 新增队列 */
+(NSString *)AddGroupInfo;
/** 加载队列列表 */
+(NSString *)MobileGetUserGroupInfo;
/** 加载队列详细信息 */
+(NSString *)MobileGetGroupDetailedInfo;
/** 加载原先数据（包含当前排队开始时间和结束时间以及自动续建设置信息） */
+(NSString *)GetAutomaticInfoByGroupId;
/** 加载原先自动续建时段 */
+(NSString *)GetTimeIntervalByGroupId;
/** 手动续建 */
+(NSString *)EditGroupInfoTime;
/** 自动续建 */
+(NSString *)AutomaticSetting;
/** 窗口分配--加载当前用户名下未分配的窗口 */
+(NSString *)GetWindowInfoByUserIdEx;
/** 队列绑定窗口（一个队列可绑定多个窗口，由多个窗口绑定叫号办理。） */
+(NSString *)AddWindowGroupEx;
/** 获取当前队列已经绑定的窗口列表 */
+(NSString *)GetWindowInfoByGroupId;
/** 队列解绑窗口 */
+(NSString *)DelWindowGroupEx;
/** 删除队列 */
+(NSString *)DelGroupInfo;

/** 获取队列的窗口列表 */
+(NSString *)GetWindowInfoByGroupIdEx;

/** 修改队列信息：第一步通过队列ID获取队列信息，渲染到修改界面；第二部修改信息提交。*/
/** 第一步获取队列信息 */
+(NSString *)GetGroupInfoByID;
/** 第二步修改队列信息，并提交 */
+(NSString *)EditGroupInfoEx;

/** 判断队列是否被当前用户收藏 */
+(NSString *)GetCollectionInfoByGroupId;
/** 收藏队列 */
+(NSString *)AddCollectionInfo;
/** 取消收藏 */
+(NSString *)DelCollectionInfo;
#pragma mark - 单人呼叫
/** 页面加载列表数据 */
+(NSString *)GetQueueDataByGroupId;

+ (NSString *)MobileGetQueueDataByGroupId;

/** 首页---景区等 进入队列详情 */
+ (NSString *)GetScreenDataDetailByGroupId;

/** 修改列表中第一条数据的状态为办理中，并记录办理窗口。 */
+(NSString *)EditState;
/** 呼叫当前 */
+(NSString *)CallCurrent;
/** 下一位 */
+(NSString *)SingleCallNext;
/** 过号 */
+(NSString *)SingleExpireNo;
/** 暂停接口 */
+(NSString *)Suspend;
/** 解散 */
+(NSString *)Disband;

/** 排号（即现场取号）：分2步骤，第一步骤：排队并返回成功的序号，第二步骤：获取票号信息，并打印纸质票据。
 */
/** 排队并返回成功的序号 */
+(NSString *)SceneQueue;
/** 获取票号信息，并打印纸质票据 */
+(NSString *)MobileGetBillInfo;

#pragma mark - 批量叫号
/** 批量叫号  排队列表 */
+(NSString *)GetQueueDataByGroupIds;
/** 设置呼叫窗口 */
+(NSString *)EditWindowStatus;
/** 批量叫号 结束上一批 */
+(NSString *)MultipleCallNext;
/** 批量暂停 */
+(NSString *)MultipleSuspend;
/** 加载数据成功后修改列表中数据状态为办理中 */
+(NSString *)EditBatchState;
#pragma mark - 会员中心
/** 获取个人信息（根据用户类型不同进入不同的界面，请求基本数据都是这个接口） */
+(NSString *)MobileGetUserInfoEx;
/** 普通用户详细界面 */
+(NSString *)MobileGetAverageUserInfo;
/** 商户详细界面 */
+(NSString *)MobileGetBusinessUserInfo;
/** 我的收藏（获取收藏信息） */
+(NSString *)MobileGetCollectionGroupByuserId;
/** 历史排号 */
+(NSString *)GetDataForQueueHistory;
/** 删除历史排队 */
+(NSString *)DelQueueInfo;
/** 窗口列表 */
+(NSString *)GetWindowInfoByUserId;
/** 删除窗口 */
+(NSString *)DelWindowInfo;
/** 添加窗口 */
+(NSString *)AddWindowInfo;
/** 呼叫员列表 */
+(NSString *)GetCallOfficer;
/** 删除呼叫员 */
+(NSString *)DelCallOfficer;
/** 添加呼叫员 */
+(NSString *)AddCallOfficer;
/** 语音提醒设置 */
+(NSString *)EditReminderSettings;
#pragma mark - 我的消息
/** 我的消息 动态消息 */
+(NSString *)GetMessageReminder;
/** 添加阅读记录 */
+(NSString *)AddReadingInfo;
/** 用户反馈 */
+(NSString *)AddMessageInfo;
/** 获取排号提醒未读消息数量 */
+(NSString *)MobileGetRemindNumber;
/** 获取回馈的详细内容 */
+(NSString *)GetFeedbackInfoById;
/** 获取通知信息接口 */
+(NSString *)MobileGetRemindInfo;
/** 动态消息未读数量 */
+(NSString *)GetMessageReminderNumber;
/** 未读消息 */
+(NSString *)GetMessageNumber;
/** 删除提醒信息 */
+(NSString *)MobileDeleteRemind;
#pragma mark - （个人资料修改信息）
/** 修改姓名 */
+(NSString *)EditUserNameEx;
/** 修改手机号 */
+(NSString *)EditPhone;
/** 修改商户全称 */
+(NSString *)EditBusinessName;
/** 修改区域 */
+(NSString *)EditArea;
/** 修改详细地址 */
+(NSString *)EditAddr;
/** 修改邮箱 */
+(NSString *)EditMail;
/** 修改商家简介 */
+(NSString *)EditSynopsis;
/** 修改头像 */
+(NSString *)EditHeadPortrait;
/** 修改商户图片 */
+(NSString *)MobileEditPictrue;
/** 修改电话号码 */
+(NSString *)EditTelephone;
/** 修改行业 */
+(NSString *)EditMerchant;

/** 普通用户升级成商户 */
+(NSString *)MobileApplyMerchant;
/** 商户升级成高级商户 */
+(NSString *)MobileUpgradeSeniorMerchant;


#pragma mark - 排号接口
/** 排队信息 */
+(NSString *)GetScreenDataByGroupId;
/** 评论信息 */
+(NSString *)GetGroupCommentByGroupId;
/** 加入队列 */
+(NSString *)AddQueueInfo;
/** 带套餐 加入队列 */
+(NSString *)PackageQueue;
/** 队列信息 */
+(NSString *)MobileGetGroupInfoByGroupId;
/** 结束排号（退出排号） */
+(NSString *)ExitQueueEx;
/** 退出排号 参数 userID groupID */
+(NSString *)ExitQueue;
/** 评分 */
+(NSString *)AddComment;
/** 查看是否已经排队 */
+(NSString *)CheckQueueInfo;
/** 我的排队详情 */
+(NSString *)MobileGetQueueDetailed;
#pragma mark - 套餐
/** 加入套餐页面获取套餐信息（通过队列ID获取套餐信息） */
+(NSString *)GetPackageLists;
/** 获取用户套餐信息 */
+(NSString *)GetGroupPackageByUserId;
/** 新增套餐 */
+(NSString *)AddGroupPackage;
/** 删除套餐 */
+(NSString *)DelGroupPackage;
/** 套餐修改页面 */
+(NSString *)MobileGetEditPackageInfo;
/** 提交修改套餐 */
+(NSString *)EditGroupPackage;
/** 套餐进度 */
+(NSString *)MobileGetPackageSchedule;
/** 判断套餐中队列是否有的已经排队 */
+(NSString *)CheckPackage;
@end
