//
//  KMGroupQueueDetailVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMGroupBaseInfo.h"
#import "KMQueueDataModel.h"
#import "KMGroupCommentModel.h"
#import "KMPackageItem.h"
typedef NS_ENUM(NSUInteger, SectionStyle) {
    SectionStyleGroupInfo,  //队列信息
    SectionStyleQueueInfo,  //排队信息
    SectionStyleEvaluate,   //用户评价
    SectionStyleRelated,    //相关队列
    SectionStyleNone        //没有信息
};

@interface KMGroupQueueDetailVM : KMBaseViewModel

/** 队列ID */
@property (nonatomic, copy) NSString * groupID;
/** 语音提醒 */
@property (nonatomic, assign) BOOL  isVoice;
/** 自定义的提醒时间 */
@property (nonatomic, strong) NSNumber * minutes;
/** 已经排队 */
@property (nonatomic, assign) BOOL  alreadyQueue;
/** 排号ID */
@property (nonatomic, copy) NSString * queueID;
/** 套餐数据 */
@property (nonatomic, copy) NSArray * packageList;
/** 队列信息 */
@property (nonatomic, strong) KMGroupBaseInfo * baseInfo;
/** 收藏ID */
@property (nonatomic, copy) NSString * collectionID;
/** 是否收藏 */
@property (nonatomic, assign) BOOL isCollection;
/** 排队信息 */
@property (nonatomic, strong) NSMutableArray * queueArr;
/** 评价数据 */
@property (nonatomic, strong) NSMutableArray * evaluateArr;
/** 相关队列 */
@property (nonatomic, strong) NSMutableArray * relatedArr;
/** 评论模型 */
@property (nonatomic, strong) KMGroupCommentModel * commentInfo;
/** 套餐信息 */
@property (nonatomic, copy) NSString * packageInfo;
/** 套餐名称 */
@property (nonatomic, copy) NSString * packageName;

/** 请求队列信息 */
@property (nonatomic, strong) RACCommand * requestGroupInfo;
/** 请求套餐信息 */
@property (nonatomic, strong) RACCommand * requestPackageInfo;
/** 现场排队情况 */
@property (nonatomic, strong) RACCommand * requestQueueInfo;
/** 请求评论信息 */
@property (nonatomic, strong) RACCommand * requestComment;
/** 参加排队 */
@property (nonatomic, strong) RACCommand * joinQueueCommand;
/** 判断套餐中队列是否有的已经排队，倘若有不允许再排套餐 */
@property (nonatomic, strong) RACCommand * checkPackageCommand;
/** 参加套餐 */
@property (nonatomic, strong) RACCommand * packageQueueCommand;
/** 退出排队 */
@property (nonatomic, strong) RACCommand * exitQueueCommand;
/** 判断是否收藏 */
@property (nonatomic, strong) RACCommand * checkCollectionStatus;
/** 加入收藏 */
@property (nonatomic, strong) RACCommand * addCollection;
/** 取消收藏 */
@property (nonatomic, strong) RACCommand * deleCollection;
/** 判断是否已经在排队 */
@property (nonatomic, strong) RACCommand * checkQueue;

/** 获取用户信息 */
@property (nonatomic, strong) RACCommand * userInfoCommand;

/** 刷新网络请求 */
@property (nonatomic, strong) RACSubject * refreshSubject;
/** 远程是否超出距离 */
-(BOOL)beyondDistance;
/** 自定义选择时间提醒 */
-(void)addRemind;

/** 是否可以排队 */
-(BOOL)checkCanQueue;

-(SectionStyle)styleForSection:(NSInteger)section;

-(NSInteger)numberOfSections;

-(NSInteger)numberOfRowsInSection:(NSInteger)section;

-(NSArray *)timeArr;

@end
