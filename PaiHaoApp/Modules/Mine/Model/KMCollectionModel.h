//
//  KMCollectionModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMCollectionModel : NSObject
/** 时段 */
@property (nonatomic, copy) NSString *timespan;
/** 等待人数 */
@property (nonatomic, assign) NSInteger frontnumber;
/** 号群ID(数据标识) */
@property (nonatomic, copy) NSString *groupid;
/** 图片 */
@property (nonatomic, copy) NSString *groupphoto;
/** 号群编号（ID） */
@property (nonatomic, copy) NSString *groupno;
/** 等待时间 */
@property (nonatomic, assign) CGFloat waittime;
/** 地址 */
@property (nonatomic, copy) NSString *groupaddr;
/** 名称 */
@property (nonatomic, copy) NSString *groupname;
/** 纬度 */
@property (nonatomic, copy) NSString *lat;
/** 经度 */
@property (nonatomic, copy) NSString *lng;
/** 收藏ID */
@property (nonatomic, copy) NSString * collecteid;
/** 二维码 */
@property (nonatomic, copy) NSString * qrcode;
@end
