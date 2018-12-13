//
//  KMQueueInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMQueueInfo : NSObject
/** 你的号码 */
@property (nonatomic, copy) NSString *currentno;
/** 号群ID（数据标识） */
@property (nonatomic, copy) NSString *groupid;
/** 等待人数 */
@property (nonatomic, assign) NSInteger waitcount;
/** 号群图片 */
@property (nonatomic, copy) NSString *groupphoto;
/** 号群ID（编号） */
@property (nonatomic, copy) NSString *groupno;
/** 当前办理编号 */
@property (nonatomic, copy) NSString *currenthandle;
/** 排队ID */
@property (nonatomic, copy) NSString *queueid;
/** 纬度 */
@property (nonatomic, copy) NSString *lat;
/** 号群名称 */
@property (nonatomic, copy) NSString *groupname;
/** 经度 */
@property (nonatomic, copy) NSString *lng;
/** 等待时间（-3 还没开始办理 -2 已经结束办理 -1 还未到办理时间） */
@property (nonatomic, assign) NSInteger waittime;
/** 二维码 */
@property (nonatomic, copy) NSString * qrcode;
@end
