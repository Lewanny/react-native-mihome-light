//
//  KM_NetworkParams.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/20.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KM_NetworkParams : NSObject

/** 参数集合 实体集合 有可能为1个 也有可能为多个 */

+(NSDictionary *)paramsWithActionName:(NSString *)actionName
                            paramsSet:(NSArray *)paramsSet
                             entrySet:(NSArray *)entrySet;
/** 获取当前时间的时间戳 */
+(NSString *)getTimeStamp;
@end
