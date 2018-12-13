//
//  KMGroupInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMGroupInfo : NSObject
/** 队列名称 */
@property (nonatomic, copy) NSString *groupname;
/** 二维码名称 */
@property (nonatomic, copy) NSString *qrcode;
/** 创建时间 */
@property (nonatomic, copy) NSString *createtime;
/** 排队开始时间 */
@property (nonatomic, copy) NSString *startwaittime;
/** 时段 */
@property (nonatomic, copy) NSString *timespan;
/** 排队结束时间 */
@property (nonatomic, copy) NSString *endwaittime;
/** 结束续建日期 */
@property (nonatomic, copy) NSString *untilendtime;
/** 叫号方式 0为单人叫号 大于0 为批量叫号，批量人数为这个数据的值 */
@property (nonatomic, assign) NSInteger singlenumber;
/** 等待人数 */
@property (nonatomic, assign) NSInteger waitingcount;
/** 一周续建情况设置；默认值为’000000’ 每天都不续建
 1是续建 0不续建 第一位置对应星期一，依次类推。 */
@property (nonatomic, copy) NSString *weekdate;
/** 队列编号（ID） */
@property (nonatomic, copy) NSString *groupno;
/** 队列ID（数据标识） */
@property (nonatomic, copy) NSString *groupid;
/** 开始续建日期 */
@property (nonatomic, copy) NSString *untilstarttime;
/** 队列图片http://112.124.3.157:8100/Image/+ 队列图片 为图片完整路径 */
@property (nonatomic, copy) NSString *photo;
/** 续建模式，0 不续建，1 当前只有一个时段，晚上12点以后自动续建，2 当天有多个时段（早中晚）多次自动续建。 */
@property (nonatomic, assign) NSInteger untilmode;
@end
