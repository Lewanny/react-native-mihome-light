//
//  KMLogService.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMLoggerFormatter.h"
//#define LOG_LEVEL_DEF ddLogLevel
//
//
//static const DDLogLevel ddLogLevel = DDLogLevelDebug;
//// 默认的宏，方便使用
//#define XXXLog(frmt, ...)           XXXLogInfo(frmt, ...)
//
//// 提供不同的宏，对应到特定参数的对外接口
//#define XXXLogError(frmt, ...)      DDLogError(frmt, ##__VA_ARGS__)
//#define XXXLogWarning(frmt, ...)    DDLogWarn(frmt, ##__VA_ARGS__)
//#define XXXLogInfo(frmt, ...)       DDLogInfo(frmt, ##__VA_ARGS__)
//#define XXXLogDebug(frmt, ...)      DDLogDebug(frmt, ##__VA_ARGS__)
//#define XXXLogVerbose(frmt, ...)    DDLogVerbose(frmt, ##__VA_ARGS__)




@interface KMLogService : NSObject

+ (void)start;

@end
