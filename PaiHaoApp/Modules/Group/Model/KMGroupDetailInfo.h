//
//  KMGroupDetailInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMGroupDetailInfo : NSObject
/** 电话 */
@property (nonatomic, copy) NSString *phone;
/** 排队时间 */
@property (nonatomic, copy) NSString *queuingtime;
/** 等待时间 */
@property (nonatomic, copy) NSString *waitingtime;
/** 号群地址 */
@property (nonatomic, copy) NSString *groupaddress;
/** 等待人数 */
@property (nonatomic, copy) NSString *waitingcount;
/** 号群编号（ID） */
@property (nonatomic, copy) NSString *groupno;
/** 商户简介 */
@property (nonatomic, copy) NSString *synopsis;
/** 图片 */
@property (nonatomic, copy) NSString *photo;
/** 号群名称 */
@property (nonatomic, copy) NSString *groupname;
/** 排队总人数 */
@property (nonatomic, copy) NSString *currentcount;
/** 二维码 */
@property (nonatomic, copy) NSString *qrcode;
@end
