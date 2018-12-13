//
//  KMRemindMsgModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMRemindMsgModel : NSObject
/** 排队ID */
@property (nonatomic, copy) NSString *queueId;
/** 用户ID */
@property (nonatomic, copy) NSString *userId;
/** 等待时间 */
@property (nonatomic, assign) NSInteger waitTime;
/** 消息ID */
@property (nonatomic, assign) NSInteger ID;
/** 0提醒消息 1 解散消息  */
@property (nonatomic, assign) NSInteger mode;
/** 排队编号 */
@property (nonatomic, copy) NSString *queueNo;
/** 窗口信息 */
@property (nonatomic, copy) NSString *windowName;
/** 队列名称 */
@property (nonatomic, copy) NSString *groupName;
/** 创建时间(消息发送时间) */
@property (nonatomic, copy) NSString *CreateTime;
/** 等待人数 */
@property (nonatomic, assign) NSInteger waitCount;

@end
