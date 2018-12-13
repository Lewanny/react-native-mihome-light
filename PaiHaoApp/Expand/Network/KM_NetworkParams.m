//
//  KM_NetworkParams.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/20.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KM_NetworkParams.h"

@implementation KM_NetworkParams
+(NSDictionary *)paramsWithActionName:(NSString *)actionName
                            paramsSet:(NSArray *)paramsSet
                             entrySet:(NSArray *)entrySet{


    id km_paramsSet;
    id km_entrySet;

    if (paramsSet) {
    km_paramsSet             = paramsSet;
    }else{
    km_paramsSet             = @[];
    }
    if (entrySet) {
    km_entrySet              = entrySet;
    }else{
    km_entrySet              = @[];
    }

    NSDictionary *params     = @{
                             kActionName : actionName,
                             kTimeStamp : @"0", //为了使用URL 以及Params 作为缓存Key 暂时去掉时间戳
                             kStatus : @"0",
                             kToken : @"0", //暂未启用
                             kParamsSet : km_paramsSet,
                             kEntrySet : km_entrySet
                             };
    KMLog(@"参数是 ====  \n%@",params);
    NSDictionary *tureParams = @{@"json" : [params jsonStringEncoded]};
    return tureParams;

}
/** 获取当前时间的时间戳 */
+(NSString *)getTimeStamp{
    NSDate* dat              = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString     = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

@end
