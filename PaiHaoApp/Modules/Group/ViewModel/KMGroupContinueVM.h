//
//  KMGroupContinueVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

#import "KMTimeSectionModel.h"
/** 续建分类 */
typedef NS_ENUM(NSUInteger, ContinueStyle) {
    ContinueStyleManual = 0,    //手动续建
    ContinueStyleAuto           //自动续建
};
/** 自动续建分类 */
typedef NS_ENUM(NSUInteger, AutoStyle) {
    AutoStyleNormal = 0,        //普通续建
    AutoStyleSection            //分段续建
};

@interface KMGroupContinueVM : KMBaseViewModel

@property (nonatomic, copy) NSArray * timeSections;


@property (nonatomic, assign) ContinueStyle  continueStyle;

@property (nonatomic, assign) AutoStyle  autoStyle;

/** 手动续建 日期 */
@property (nonatomic, strong) NSDate * manualDay;
/** 手动续建 开始时间 */
@property (nonatomic, strong) NSDate * manualDateStart;
/** 手动续建 结束时间 */
@property (nonatomic, strong) NSDate * manualDateEnd;

/** 自动续建 开始日期 */
@property (nonatomic, strong) NSDate * autoDayStart;
/** 自动续建 结束日期 */
@property (nonatomic, strong) NSDate * autoDayEnd;

/** 自动续建 开始时间 */
@property (nonatomic, strong) NSDate * autoDateStart;
/** 自动续建 结束时间 */
@property (nonatomic, strong) NSDate * autoDateEnd;

/** 自动续建 AM 开始时间 */
@property (nonatomic, strong) NSDate * autoAMSatrt;
/** 自动续建 AM 结束时间 */
@property (nonatomic, strong) NSDate * autoAMEnd;
/** 自动续建 PM 开始时间 */
@property (nonatomic, strong) NSDate * autoPMSatrt;
/** 自动续建 PM 结束时间 */
@property (nonatomic, strong) NSDate * autoPMEnd;
/** 自动续建 Night 开始时间 */
@property (nonatomic, strong) NSDate * autoNightStart;
/** 自动续建 Night 结束时间 */
@property (nonatomic, strong) NSDate * autoNightEnd;

/** 星期 */
@property (nonatomic, assign) KMWeek  weeks;

/** 加载续建信息 */
@property (nonatomic, strong) RACCommand * autoInfoCommand;
/** 还是加载续建信息 */
@property (nonatomic, strong) RACCommand * autoTimeInfoCommand;

/** 手动续建 提交 */
@property (nonatomic, strong) RACCommand * manualCommit;
/** 自动续建 提交 */
@property (nonatomic, strong) RACCommand * autoCommit;

/** 提交前 检查数据 */
-(BOOL)verifyData;
/** 更新 时间 */
//-(void)updateDate;

@end
