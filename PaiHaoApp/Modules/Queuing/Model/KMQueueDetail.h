//
//  KMQueueDetail.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMQueueItem : NSObject
/** 编号 */
@property (nonatomic, copy) NSString * bespeakSort;
/** 电话 */
@property (nonatomic, copy) NSString * phone;
/** 窗口号 */
@property (nonatomic, copy) NSString * windowName;

@property (nonatomic, copy) NSString * queueState;

@end

@interface KMQueueDetail : NSObject<YYModel>
/** 当前办理编号 */
@property (nonatomic, copy) NSString * currenthandle;
/** 你的编号 */
@property (nonatomic, copy) NSString * currentno;
/** 等待人数 */
@property (nonatomic, copy) NSString * waitingcount;
/** 等待时间 */
@property (nonatomic, copy) NSString * waitingtime;
/** 排队列表 */
@property (nonatomic, copy) NSArray * QueueDetailed;
/** 套餐信息 */
@property (nonatomic, copy) NSString * packageInfo;
/** 套餐名称 */
@property (nonatomic, copy) NSString * packageName;
/** 套餐ID */
@property (nonatomic, copy) NSString * packageId;
@end
