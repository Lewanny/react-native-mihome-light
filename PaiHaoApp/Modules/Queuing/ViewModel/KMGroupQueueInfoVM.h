//
//  KMGroupQueueInfoVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMGroupBaseInfo.h"
#import "KMQueueDetail.h"
#import "KMQueueDataModel.h"
typedef NS_ENUM(NSUInteger, CellStyle) {
    CellStyleGroupInfo,     //队列信息
    CellStylePackageInfo,   //套餐信息
    CellStyleWaitInfo,      //等待信息
    CellStyleQueueInfo      //排队信息
};

@interface KMGroupQueueInfoVM : KMBaseViewModel


/** 队列ID */
@property (nonatomic, copy) NSString * groupID;
/** 排队ID */
@property (nonatomic, copy) NSString * queueID;


/** 队列信息 */
@property (nonatomic, strong) KMGroupBaseInfo * baseInfo;
/** 排队信息 */
@property (nonatomic, strong) KMQueueDetail * queueDetail;
/** 排队信息 --- 现在用的*/
@property (nonatomic, strong) KMQueueDataModel * queueDetailItem;

/** 套餐信息 */
@property (nonatomic, copy) NSString * packageInfo;

/** 请求队列信息 */
@property (nonatomic, strong) RACCommand * requestGroupInfo;
/** 请求排队信息 */
@property (nonatomic, strong) RACCommand * requestQueueInfo;
/** 请求排队--等候时间，等候人数 */
@property (nonatomic, strong) RACCommand * requestQueueDetailInfo;

/** 退出排队 */
@property (nonatomic, strong) RACCommand * exitQueueCommand;


/**
 排队数组
 */
@property (strong, nonatomic) NSMutableArray *queueArr;

-(CellStyle)styleForIndexPath:(NSIndexPath *)indexPath;

-(NSInteger)numberOfSections;

-(NSInteger)numberOfRowsInSection:(NSInteger)section;
@end
