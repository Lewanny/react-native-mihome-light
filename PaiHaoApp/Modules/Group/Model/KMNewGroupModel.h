//
//  KMNewGroupModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMNewGroupModel : NSObject
/** 创建人（登录账号） */
@property (nonatomic, copy) NSString *creater;
/** 行业类型即 分类ID 对照商户类型Merchanttype的ID */
@property (nonatomic, copy) NSString *industrytype;
/** 关键字 */
@property (nonatomic, copy) NSString *keyword;
/** 限制人数（0不限制，大于0限制，且限制为这个字段的值数量） */
@property (nonatomic, assign) NSInteger groupCount;
/** 号群有效期开始时间（日期+开始时间） */
@property (nonatomic, copy) NSString *startWaitTime;
/** 市（应包含市） */
@property (nonatomic, copy) NSString *groupCity;
/** 纬度 */
@property (nonatomic, copy) NSString *latitude;
/** 平均排队时间 */
@property (nonatomic, copy) NSString *averagetime;
/** 每批次人数（0，单人模式，大于0 批量模式，并且每批为这个数据的值） */
@property (nonatomic, assign) NSInteger singleNumber;
/** 号群有效期结束时间（日期+结束时间） */
@property (nonatomic, copy) NSString *endWaitTime;
/** 经度 */
@property (nonatomic, copy) NSString *longitude;
/** 联系电话 */
@property (nonatomic, copy) NSString *phone;
/** 号群地址，应包括省市县/区及详细地址街道楼栋门牌号等尽量详细。 */
@property (nonatomic, copy) NSString *groupAddress;
/** 县/区域（应包含区或县） */
@property (nonatomic, copy) NSString *groupArea;
/** 号群名称 */
@property (nonatomic, copy) NSString *groupName;
/** 是否允许远程排队（0允许，1不允许，默认0） */
@property (nonatomic, assign) NSInteger isAllowRemote;
/** 简介 */
@property (nonatomic, copy) NSString *introduction;
/** 省(应包含省) */
@property (nonatomic, copy) NSString *groupProvince;
/** 图片路径 */
@property (nonatomic, copy) NSString *photo;
/** 用户ID 关联用户表的ID */
@property (nonatomic, copy) NSString *userId;
@end
