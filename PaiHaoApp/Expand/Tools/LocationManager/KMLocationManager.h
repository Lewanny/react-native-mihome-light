//
//  KMLocationManager.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KSystemLocationBlock)(CLLocation *loction, NSError *error);

@interface KMLocationManager : NSObject

@property (nonatomic, strong) CLLocation * myLocation;

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;

/** 单例 */
+ (instancetype)shareInstance;

/**
 启动系统定位
 
 @param systemLocationBlock 系统定位成功或失败回调成功
 */
-(void)startSystemLocationWithRes:(KSystemLocationBlock)systemLocationBlock;

/** 目标定位地址 到 我的定位地址距离 */
+(NSString *)distanceWithTargetLocation:(CLLocation *)targetLocation;
/** 距离 */
+(CGFloat)distanceWithLocation:(CLLocation *)location;

+(NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
                                    TargetName:(NSString *)targetName;

+(void)showActionSheetWithMaps:(NSArray *)maps;

@end
