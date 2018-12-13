//
//  KMGroupBaseInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMGroupBaseInfo : NSObject
/** 时段 */
@property (nonatomic, copy) NSString *timespan;
/** 前面人数 */
@property (nonatomic, copy) NSString *frontnumber;
/** 号群ID（数据标识） */
@property (nonatomic, copy) NSString *groupid;
/** 号群图片路径 */
@property (nonatomic, copy) NSString *groupphoto;
/** 号群ID */
@property (nonatomic, copy) NSString *groupno;
/** 等待时间 */
@property (nonatomic, copy) NSString *waittime;
/** 号群地址 */
@property (nonatomic, copy) NSString *groupaddr;
/** 号群名称 */
@property (nonatomic, copy) NSString *groupname;
/** 纬度 */
@property (nonatomic, copy) NSString *lat;
/** 经度 */
@property (nonatomic, copy) NSString *lng;
/** 二维码 */
@property (nonatomic, copy) NSString * qrcode;
/** 提醒时间 */
@property (nonatomic, strong) NSNumber * minutes;

/** 电话号码 */
@property (nonatomic, copy) NSString * telephone;
/** 远程排队 */
@property (nonatomic, assign) NSInteger  isallowremote;

/** 号群状态为1时，号群为解散状态。当前不可排队 */
@property (nonatomic, assign) NSInteger  groupstatus;


/** 是否有套餐 */
@property (nonatomic, assign) BOOL  hasPackage;
/** 已经排队 */
@property (nonatomic, assign) BOOL  alreadyQueue;

@end
