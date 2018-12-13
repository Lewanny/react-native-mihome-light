//
//  KM_NetworkConfig.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KM_NetworkConfig.h"

@implementation KM_NetworkConfig

+(instancetype)hideHUDCofig{
    KM_NetworkConfig * config = nil; 
    config                           = [[KM_NetworkConfig alloc]init];
    config.isCtrlHub                 = YES;
    config.HUDDuration               = -1;
    config.HttpMethod                = KM_GET;
    return config;
}

+(instancetype)showHUDConfig{
    KM_NetworkConfig * config = nil;
    config                           = [[KM_NetworkConfig alloc]init];
    config.isCtrlHub                 = YES;
    config.HUDDuration               = 0;
    config.HttpMethod                = KM_GET;
    return config;
}
/** 外界修改时 用这个 */
+(instancetype)changeConfig{
    KM_NetworkConfig * config = nil;
    config                           = [[KM_NetworkConfig alloc]init];
    config.isCtrlHub                 = YES;
    config.HUDDuration               = 0;
    config.HttpMethod                = KM_GET;
    return config;
}

//-(void)dealloc{
//    KMLog(@"%s", __func__);
//}

@end
