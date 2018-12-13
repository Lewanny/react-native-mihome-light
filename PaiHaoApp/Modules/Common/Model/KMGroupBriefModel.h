//
//  KMGroupBriefModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 队列列表 */

@interface KMGroupBriefModel : NSObject
/** 前面等待人数 */
@property (nonatomic, assign) NSInteger waitcount;
/** 队列ID（数据标识） */
@property (nonatomic, copy) NSString *ID;
/** 开始排队时间 */
@property (nonatomic, copy) NSString *startwaittime;
/** 队列图片 */
@property (nonatomic, copy) NSString *groupphoto;
/** 查询ID （类似于标签，关键字等） */
@property (nonatomic, copy) NSString *groupno;
/** 预计等待时间 */
@property (nonatomic, assign) NSInteger waittime;
/** 地址 */
@property (nonatomic, copy) NSString *groupaddr;
/** 名称 */
@property (nonatomic, copy) NSString *groupname;
/** 经度 */
@property (nonatomic, assign) CGFloat lat;
/** 纬度 */
@property (nonatomic, assign) CGFloat lng;
/** 二维码 */
@property (nonatomic, copy) NSString * qrcode;


/************** 搜索接口才有 ******************/
/** 省 */
@property (nonatomic, copy) NSString * province;
/** 市 */
@property (nonatomic, copy) NSString * city;
/** 区 */
@property (nonatomic, copy) NSString * area;



@end
