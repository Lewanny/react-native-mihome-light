//
//  KMCitySelectTool.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoadCityData)(NSArray * characterArr, NSDictionary * sectionDic);
typedef void(^AreaDataBlock)(NSArray * areaArr);
typedef void(^RelustBlock)(NSArray * relustArr);
typedef void(^CityDataBlock)(NSString * province, NSString * city, NSString * area);
@interface KMCitySelectTool : NSObject


/**
 获取城市对应的区域

 @param cityName 城市
 @param callBack 回调
 */
+(void)loadAreaData:(NSString *)cityName CallBack:(AreaDataBlock)callBack;

/**
 按A-Z字母加载城市数据

 @param cityData 回调
 */
+(void)loadCityData:(LoadCityData)cityData;

/**
 搜索城市

 @param cityName 搜索关键字
 @param callBack 回调
 */
+(void)searchCityData:(NSString *)cityName CallBack:(RelustBlock)callBack;

/**
 跳转城市选择控制器
 */
+(void)presentCitySelectVC;

/**
 选择城市

 @param cityName 城市
 */
+(void)didSelectCity:(NSString *)cityName;

@end
