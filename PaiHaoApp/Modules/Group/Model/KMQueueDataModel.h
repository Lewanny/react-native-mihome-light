//
//  KMQueueDataModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMQueueDataModel : NSObject
/** 号码 */
@property (nonatomic, copy) NSString *bespeakSort;
/** 用户电话 */
@property (nonatomic, copy) NSString *phone;
/** 排队用户ID */
@property (nonatomic, copy) NSString *userid;
/** 窗口名称（处理过程中失误刷新数据，可找回当前窗口之前未办理的，继续处理。没有则为空，当前第一条为当期办理。） */
@property (nonatomic, copy) NSString *windowName;
/** 队列信息ID */
@property (nonatomic, copy) NSString *Id;

/** 新增 套餐ID */
@property (nonatomic, copy) NSString * packageId;

@property (nonatomic, copy) NSString *queueState;
@end
