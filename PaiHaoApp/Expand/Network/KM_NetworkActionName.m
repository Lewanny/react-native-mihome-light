//
//  KM_NetworkActionName.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/20.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KM_NetworkActionName.h"

@implementation KM_NetworkActionName
#pragma mark - 首页与注册接口
/** 推荐号群 */
+(NSString *)MobileGetShowGroup{
    return @"MobileGetShowGroup";
}
/** 我的排号（先登录） */
+(NSString *)MobileGetUserQueueInfo{
    return @"MobileGetUserQueueInfo";
}
/** 查找号群 */
+(NSString *)MobileGetSearchGroup{
    return @"MobileGetSearchGroup";
}
/** 获取行业分类信息（号群行业分类和商户行业分类相同） */
+(NSString *)GetMerchantType{
    return @"GetMerchantType";
}
/** 获取验证码 */
+(NSString *)AHSMSEx{
    return @"AHSMSEx";
}
+(NSString *)MobileCheckAccount{
    return @"MobileCheckAccount";
}
/** 注册用户接口 */
+(NSString *)MobileRegister{
    return @"MobileRegister";
}
/** 完善用户信息 */
+(NSString *)MobileImproveUserInfo{
    return @"MobileImproveUserInfo";
}
/** 完善商户信息 */
+(NSString *)MobileImproveMerchantInfo{
    return @"MobileImproveMerchantInfo";
}
/** 修改密码（先验证用户输入手机号是否注册，注册则发送短信验证码，验证通过进入修改密码页面。） */
+(NSString *)MobileModifyPassWord{
    return @"MobileModifyPassWord";
}
/** 登录 */
+(NSString *)MobileLogin{
    return @"MobileLogin";
}
#pragma mark - 号群接口
/** 新增号群 */
+(NSString *)AddGroupInfo{
    return @"AddGroupInfo";
}
/** 加载号群列表 */
+(NSString *)MobileGetUserGroupInfo{
    return @"MobileGetUserGroupInfo";
}
/** 加载号群详细信息 */
+(NSString *)MobileGetGroupDetailedInfo{
    return @"MobileGetGroupDetailedInfo";
}
/** 加载原先数据（包含当前排队开始时间和结束时间以及自动续建设置信息） */
+(NSString *)GetAutomaticInfoByGroupId{
    return @"GetAutomaticInfoByGroupId";
}
/** 加载原先自动续建时段 */
+(NSString *)GetTimeIntervalByGroupId{
    return @"GetTimeIntervalByGroupId";
}
/** 手动续建 */
+(NSString *)EditGroupInfoTime{
    return @"EditGroupInfoTime";
}
/** 自动续建 */
+(NSString *)AutomaticSetting{
    return @"AutomaticSetting";
}
/** 窗口分配--加载当前用户名下未分配的窗口 */
+(NSString *)GetWindowInfoByUserIdEx{
    return @"GetWindowInfoByUserIdEx";
}
/** 号群绑定窗口（一个号群可绑定多个窗口，由多个窗口绑定叫号办理。） */
+(NSString *)AddWindowGroupEx{
    return @"AddWindowGroupEx";
}
/** 获取当前号群已经绑定的窗口列表 */
+(NSString *)GetWindowInfoByGroupId{
    return @"GetWindowInfoByGroupId";
}
/** 号群解绑窗口 */
+(NSString *)DelWindowGroupEx{
    return @"DelWindowGroupEx";
}
/** 删除号群 */
+(NSString *)DelGroupInfo{
    return @"DelGroupInfo";
}

/** 获取号群的窗口列表 */
+(NSString *)GetWindowInfoByGroupIdEx{
    return @"GetWindowInfoByGroupId";//@"GetWindowInfoByGroupIdEx";
}

/** 修改号群信息：第一步通过号群ID获取号群信息，渲染到修改界面；第二部修改信息提交。*/
/** 第一步获取号群信息 */
+(NSString *)GetGroupInfoByID{
    return @"GetGroupInfoByID";
}
/** 第二步修改号群信息，并提交 */
+(NSString *)EditGroupInfoEx{
    return @"EditGroupInfoEx";
}

/** 判断号群是否被当前用户收藏 */
+(NSString *)GetCollectionInfoByGroupId{
    return @"GetCollectionInfoByGroupId";
}
/** 收藏号群 */
+(NSString *)AddCollectionInfo{
    return @"AddCollectionInfo";
}
#pragma mark - 单人呼叫
/** 页面加载列表数据 */
+(NSString *)GetQueueDataByGroupId{
    return @"MobileGetQueueDataByGroupId";//@"GetQueueDataByGroupId";// MobileGetQueueDataByGroupId GetScreenDataByGroupId
}

/** 首页---景区等 进入号群详情 */
+ (NSString *)GetScreenDataDetailByGroupId{
    return @"GetScreenDataByGroupId";
}

/** 修改列表中第一条数据的状态为办理中，并记录办理窗口。 */
+(NSString *)EditState{
    return @"EditState";
}
/** 呼叫当前 */
+(NSString *)CallCurrent{
    return @"CallCurrent";
}
/** 下一位 */
+(NSString *)SingleCallNext{
    return @"SingleCallNext";
}
/** 过号 */
+(NSString *)SingleExpireNo{
    return @"SingleExpireNo";
}
/** 暂停接口 */
+(NSString *)Suspend{
    return @"Suspend";
}
/** 解散 */
+(NSString *)Disband{
    return @"Disband";
}
/** 排号（即现场取号）：分2步骤，第一步骤：排队并返回成功的序号，第二步骤：获取票号信息，并打印纸质票据。
 */
/** 排队并返回成功的序号 */
+(NSString *)SceneQueue{
    return @"SceneQueue";
}
/** 获取票号信息，并打印纸质票据 */
+(NSString *)MobileGetBillInfo{
    return @"MobileGetBillInfo";
}

#pragma mark - 批量叫号
/** 批量叫号  排队列表 */
+(NSString *)GetQueueDataByGroupIds{
    return @"MobileGetQueueDataByGroupIds";
}
/** 设置呼叫窗口 */
+(NSString *)EditWindowStatus{
    return @"EditWindowStatus";
}
/** 批量叫号 结束上一批 */
+(NSString *)MultipleCallNext{
    return @"MultipleCallNext";
}
/** 批量暂停 */
+(NSString *)MultipleSuspend{
    return @"MultipleSuspend";
}
/** 加载数据成功后修改列表中数据状态为办理中 */
+(NSString *)EditBatchState{
    return @"EditBatchState";
}
#pragma mark - 会员中心
/** 获取个人信息（根据用户类型不同进入不同的界面，请求基本数据都是这个接口） */
+(NSString *)MobileGetUserInfoEx{
    return @"MobileGetUserInfoEx";
}
/** 普通用户详细界面 */
+(NSString *)MobileGetAverageUserInfo{
    return @"MobileGetAverageUserInfo";
}
/** 商户详细界面 */
+(NSString *)MobileGetBusinessUserInfo{
    return @"MobileGetBusinessUserInfo";
}
/** 我的收藏（获取收藏信息） */
+(NSString *)MobileGetCollectionGroupByuserId{
    return @"MobileGetCollectionGroupByuserId";
}
/** 历史排号 */
+(NSString *)GetDataForQueueHistory{
    return @"GetDataForQueueHistory";
}
/** 删除历史排队 */
+(NSString *)DelQueueInfo{
    return @"DelQueueInfo";
}
/** 删除收藏 */
+(NSString *)DelCollectionInfo{
    return @"DelCollectionInfo";
}
/** 窗口列表 */
+(NSString *)GetWindowInfoByUserId{
    return @"GetWindowInfoByUserId";
}
/** 删除窗口 */
+(NSString *)DelWindowInfo{
    return @"DelWindowInfo";
}
/** 添加窗口 */
+(NSString *)AddWindowInfo{
    return @"AddWindowInfo";
}
/** 呼叫员列表 */
+(NSString *)GetCallOfficer{
    return @"GetCallOfficer";
}
/** 删除呼叫员 */
+(NSString *)DelCallOfficer{
    return @"DelCallOfficer";
}
/** 添加呼叫员 */
+(NSString *)AddCallOfficer{
    return @"AddCallOfficer";
}
/** 语音提醒设置 */
+(NSString *)EditReminderSettings{
    return @"EditReminderSettings";
}
#pragma mark - 我的消息 
/** 我的消息 动态消息 */
+(NSString *)GetMessageReminder{
    return @"GetMessageReminder";
}
/** 添加阅读记录 */
+(NSString *)AddReadingInfo{
    return @"AddReadingInfo";
}
/** 用户反馈 */
+(NSString *)AddMessageInfo{
    return @"AddMessageInfo";
}
/** 获取排行提醒未读消息数量 */
+(NSString *)MobileGetRemindNumber{
    return @"MobileGetRemindNumber";
}
/** 获取回馈的详细内容 */
+(NSString *)GetFeedbackInfoById{
    return @"GetFeedbackInfoById";
}
/** 获取通知信息接口 */
+(NSString *)MobileGetRemindInfo{
    return @"MobileGetRemindInfo";
}
/** 动态消息未读数量 */
+(NSString *)GetMessageReminderNumber{
    return @"GetMessageReminderNumber";
}
/** 未读消息 */
+(NSString *)GetMessageNumber{
    return @"GetMessageNumber";
}
/** 删除提醒信息 */
+(NSString *)MobileDeleteRemind{
    return @"MobileDeleteRemind";
}
#pragma mark - （个人资料修改信息）
/** 修改姓名 */
+(NSString *)EditUserNameEx{
    return @"EditUserNameEx";
}
/** 修改手机号 */
+(NSString *)EditPhone{
    return @"EditPhone";
}
/** 修改商户全称 */
+(NSString *)EditBusinessName{
    return @"EditBusinessName";
}
/** 修改区域 */
+(NSString *)EditArea{
    return @"EditArea";
}
/** 修改详细地址 */
+(NSString *)EditAddr{
    return @"EditAddr";
}
/** 修改邮箱 */
+(NSString *)EditMail{
    return @"EditMail";
}
/** 修改商家简介 */
+(NSString *)EditSynopsis{
    return @"EditSynopsis";
}
/** 修改头像 */
+(NSString *)EditHeadPortrait{
    return @"EditHeadPortrait";
}
/** 修改商户图片 */
+(NSString *)MobileEditPictrue{
    return @"MobileEditPictrue";
}
/** 修改电话号码 */
+(NSString *)EditTelephone{
    return @"EditTelephone";
}
/** 修改行业 */
+(NSString *)EditMerchant{
    return @"EditMerchant";
}

/** 普通用户升级成商户 */
+(NSString *)MobileApplyMerchant{
    return @"MobileApplyMerchant";
}
/** 商户升级成高级商户 */
+(NSString *)MobileUpgradeSeniorMerchant{
    return @"MobileUpgradeSeniorMerchant";
}

#pragma mark - 排号接口

/** 排队信息 */
+(NSString *)GetScreenDataByGroupId{
    return @"GetScreenDataByGroupId";
}
/** 评论信息 */
+(NSString *)GetGroupCommentByGroupId{
    return @"GetGroupCommentByGroupId";
}
/** 加入号群 */
+(NSString *)AddQueueInfo{
    return @"AddQueueInfo";
}
/** 带套餐 加入号群 */
+(NSString *)PackageQueue{
    return @"PackageQueue";
}
/** 号群信息 */
+(NSString *)MobileGetGroupInfoByGroupId{
    return @"MobileGetGroupInfoByGroupId";
}
/** 结束排号（退出排号） */
+(NSString *)ExitQueueEx{
    return @"ExitQueueEx";
}
/** 退出排号 参数 userID groupID */
+(NSString *)ExitQueue{
    return @"ExitQueue";
}
/** 评分 */
+(NSString *)AddComment{
    return @"AddComment";
}
/** 查看是否已经排队 */
+(NSString *)CheckQueueInfo{
    return @"CheckQueueInfo";
}
/** 我的排队详情 */
+(NSString *)MobileGetQueueDetailed{
    return @"MobileGetQueueDetailed";
}
#pragma mark - 套餐
/** 加入套餐页面获取套餐信息（通过号群ID获取套餐信息） */
+(NSString *)GetPackageLists{
    return @"GetPackageLists";
}
/** 获取用户套餐信息 */
+(NSString *)GetGroupPackageByUserId{
    return @"GetGroupPackageByUserId";
}
/** 新增套餐 */
+(NSString *)AddGroupPackage{
    return @"AddGroupPackage";
}
/** 删除套餐 */
+(NSString *)DelGroupPackage{
    return @"DelGroupPackage";
}
/** 套餐修改页面 */
+(NSString *)MobileGetEditPackageInfo{
    return @"MobileGetEditPackageInfo";
}
/** 提交修改套餐 */
+(NSString *)EditGroupPackage{
    return @"EditGroupPackage";
}
/** 套餐进度 */
+(NSString *)MobileGetPackageSchedule{
    return @"MobileGetPackageSchedule";
}
/** 判断套餐中号群是否有的已经排队 */
+(NSString *)CheckPackage{
    return @"CheckPackage";
}
@end
