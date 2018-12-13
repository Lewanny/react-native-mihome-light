//
//  KM_EnumerateHeader.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#ifndef KM_EnumerateHeader_h
#define KM_EnumerateHeader_h

typedef void(^Block_Str)(NSString *str);
typedef void(^Block_Bool)(BOOL ret);
typedef void(^Block_Obj)(id object);
typedef void(^Block_Err)(NSError *error);
typedef void(^Block_Void)();

//枚举
//请求类型
typedef NS_ENUM(NSUInteger, KM_HTTPMethod) {
    KM_GET = 0,
    KM_POST,
    KM_PUT,
    KM_DELETE
};

//用户类型
typedef NS_ENUM(NSUInteger, KM_UserType) {
    KM_UserTypeNormal = 0,      //普通用户类型
    KM_UserTypeBusiness         //商户类型
};
//详细的用户类型
typedef NS_ENUM(NSUInteger, KM_CustomerType) {
    KM_CustomerTypePersonal = 0, //个人用户
    KM_CustomerTypeOrdinary,     //普通商户
    KM_CustomerTypeCertification,//认证商户
    KM_CustomerTypeGold          //白金商户
};

//登录方式
typedef NS_ENUM(NSUInteger, KM_LoginType) {
    KM_LoginTypePC = 0,
    KM_LoginTypeWeChat,
    KM_LoginTypeAndroid,
    KM_LoginTypeiOS,
    KM_LoginTypeOther
};

//首页 行业类型
typedef NS_ENUM(NSUInteger, KM_ArrangingType) {
    KM_ArrangingTypeZhengWu = 0,    //政务
    KM_ArrangingTypeJingQu,         //景区
    KM_ArrangingTypeHuoDong,        //活动
    KM_ArrangingTypeYiYuan,         //医院
    KM_ArrangingTypeCanYin,         //餐饮
    KM_ArrangingTypePiaoWu,         //票务
    KM_ArrangingTypeReMen,          //热门
    KM_ArrangingTypeQiTa            //其他
};

typedef NS_ENUM(NSUInteger, KM_GroupType) {
    KM_GroupTypeRecommend = 0,      //推荐队列
    KM_GroupTypeMyArranging,        //我的排号
    KM_GroupTypeHistory,            //查看历史
};

//排队状态（0排队状态，1已经处理（可评论），2过号，3退出，5已经呼叫，6.解散（可评论）（业务说明，解散叫号员有事离开或时间到了，无法处理完成。）7.已经评分）
typedef NS_ENUM(NSUInteger, KM_QueueState) {
    KM_QueueStateWaitProcessed = 1,     //1已经处理（可评论）
    KM_QueueStateMiss = 2,              //2过号
    KM_QueueStateQuit = 3,              //3退出
    KM_QueueStateAlreadyCall = 5,       //5已经呼叫
    KM_QueueStateDismiss = 6,           //6.解散（可评论）（业务说明，解散叫号员有事离开或时间到了，无法处理完成。）
    KM_QueueStateAlreadyEvaluate = 7    //7.已经评分
};

//窗口绑定类型
typedef NS_ENUM(NSUInteger, KM_WindowBindState) {
    KM_WindowBindStateNot = 0,           //未分配
    KM_WindowBindStateAlready,           //已绑定
};
//星期
typedef NS_OPTIONS(NSUInteger, KMWeek) {
    KMWeekMon = 1 << 0,     //星期一
    KMWeekTue = 1 << 1,     //星期二
    KMWeekWed = 1 << 2,     //星期三
    KMWeekThu = 1 << 3,     //星期四
    KMWeekFri = 1 << 4,     //星期五
    KMWeekSat = 1 << 5,     //星期六
    KMWeekSun = 1 << 6      //星期日
};

//套餐办理状态
typedef NS_ENUM(NSUInteger, KMPackageStatus) {
    KMPackageStatusYet = 0,             //未办理
    KMPackageStatusInProcess,           //办理中
    KMPackageStatusNotYet,              //已办理
};

//行业队列列表排序
typedef NS_ENUM(NSUInteger, KMCategorySortType) {
    KMCategorySortTypeNone = 0,     //没有排序
    KMCategorySortTypeNearToFar,    //由近到远
    KMCategorySortTypeIntellect,    //智能排序
    KMCategorySortTypeScreen        //筛选
};

typedef NS_ENUM(NSUInteger, KMCategoryQueueSort) {
    KMCategoryQueueSortNone   = -1, //排队不做限制
    KMCategoryQueueSortNotyet = 1,  //还没排队
    KMCategoryQueueSortBeing  = 0,  //正在排队
    KMCategoryQueueSortEnd    = 2   //已经结束
};

typedef NS_ENUM(NSUInteger, KMMyMsgType) {
    KMMyMsgTypeQueue = 0,           //排号提醒
    KMMyMsgTypeDynamic              //动态消息
};

#endif /* KM_EnumerateHeader_h */
