//
//  KMStartEndCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, KMTimeSlot) {
    KMTimeSlotNone = 0, //不分时间段
    KMTimeSlotAM,       //上午
    KMTimeSlotPM,       //下午
    KMTimeSlotNight     //晚上
};

typedef NS_ENUM(NSUInteger, TimeStyle) {
    TimeStyleDay = 0,   //选择日期
    TimeStyleTime       //选择时间
};

typedef NS_ENUM(NSUInteger, DateOrder) {
    DateOrderNone = 0,  //不分次序
    DateOrderSatrt,     //开始
    DateOrderEnd        //结束
};

@interface KMStartEndCell : KMBaseTableViewCell
/** 时间段 */
@property (nonatomic, assign) KMTimeSlot  timeSlot;
/** 选择类型 */
@property (nonatomic, assign) TimeStyle  timeStyle;
/** 点击开始 */
@property (nonatomic, copy) Block_Void startAction;
/** 点击结束 */
@property (nonatomic, copy) Block_Void endAction;

+(CGFloat)cellHeight;
@end
