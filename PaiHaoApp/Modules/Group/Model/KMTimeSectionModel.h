//
//  KMTimeSectionModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMTimeSectionModel : NSObject
/** 队列ID(数据标识) */
@property (nonatomic, copy) NSString *groupId;
/** 时段ID(数据标识)（若为空则是新增；存在则是修改） */
@property (nonatomic, copy) NSString *ID;
/** 开始时间 */
@property (nonatomic, copy) NSString *startTime;
/** 结束时间 */
@property (nonatomic, copy) NSString *endTime;
/** 模式(0,只有一个时段的时候，
 1，上午，2，下午，3，晚上) */
@property (nonatomic, assign) NSInteger mode;
@end
