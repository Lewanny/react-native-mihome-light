//
//  KMOriginalGroupInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMOriginalGroupInfo : NSObject
/** 队列有效期开始时间（日期+开始时间） */
@property (nonatomic, copy) NSString *startWaitTime;
/** 是否允许远程排队（0允许，1不允许，默认0） */
@property (nonatomic, assign) NSInteger isAllowRemote;
/** 用户ID 关联用户表的ID */
@property (nonatomic, copy) NSString *userId;

//@property (nonatomic, copy) NSString *weekDate;

//@property (nonatomic, copy) NSString *numberhead;

//@property (nonatomic, copy) NSString *remark;
/** 队列地址，应包括省市县/区及详细地址街道楼栋门牌号等尽量详细。 */
@property (nonatomic, copy) NSString *groupAddress;

@property (nonatomic, copy) NSString *industrytype;

//@property (nonatomic, copy) NSString *isEnable;

//@property (nonatomic, copy) NSString *QRCode;

//@property (nonatomic, assign) NSInteger currentCount;

@property (nonatomic, copy) NSString *editor;

//@property (nonatomic, copy) NSString *isBespeak;
/** 县/区域（应包含区或县） */
@property (nonatomic, copy) NSString *groupArea;

@property (nonatomic, copy) NSString *isWords;
/** 图片路径 */
@property (nonatomic, copy) NSString *photo;

@property (nonatomic, assign) NSInteger groupState;

@property (nonatomic, assign) NSInteger tickets;

@property (nonatomic, copy) NSString *groupNo;

@property (nonatomic, copy) NSString *Industrylabel;
/** 省(应包含省) */
@property (nonatomic, copy) NSString *groupProvince;

//@property (nonatomic, assign) NSInteger dealCount;

@property (nonatomic, copy) NSString *editTime;
/** 创建人（登录账号） */
@property (nonatomic, copy) NSString *creater;
/** 简介 */
@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, copy) NSString *isComment;

@property (nonatomic, assign) NSInteger isviewtotal;
/** 限制人数（0不限制，大于0限制，且限制为这个字段的值数量） */
@property (nonatomic, assign) NSInteger groupCount;

//@property (nonatomic, copy) NSString *isValid;
/** 市（应包含市） */
@property (nonatomic, copy) NSString *groupCity;
/** 经度 */
//@property (nonatomic, assign) CGFloat longitude;
/** 关键字 */
@property (nonatomic, copy) NSString *keyword;

//@property (nonatomic, assign) NSInteger recommend;
/** 行业类型即 分类ID 对照商户类型Merchanttype的ID */
@property (nonatomic, copy) NSString *matchID;

@property (nonatomic, copy) NSString *reserve;
/** 每批次人数（0，单人模式，大于0 批量模式，并且每批为这个数据的值） */
@property (nonatomic, assign) NSInteger singleNumber;

@property (nonatomic, copy) NSString *createTime;

//@property (nonatomic, copy) NSString *editExplain;

@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, copy) NSString *isScreen;

//@property (nonatomic, copy) NSString *Pid;

@property (nonatomic, copy) NSString *Id;
/** 联系电话 */
@property (nonatomic, copy) NSString *phone;
/** 队列有效期结束时间（日期+结束时间） */
@property (nonatomic, copy) NSString *endWaitTime;

//@property (nonatomic, assign) NSInteger expirecount;
/** 平均排队时间 */
@property (nonatomic, assign) NSInteger averagetime;
/** 纬度 */
//@property (nonatomic, assign) CGFloat latitude;

@end
