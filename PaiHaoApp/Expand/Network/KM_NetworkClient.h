//
//  KM_NetworkClient.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/21.
//  Copyright © 2017年 KM. All rights reserved.
//
//  默认URL 直接传nil 就可以


#import <Foundation/Foundation.h>
@class KM_NetworkConfig;

typedef AFHTTPSessionManager *(^AFManagerSetting)(AFHTTPSessionManager * manager);

typedef KM_NetworkConfig *(^NetworkConfig)(KM_NetworkConfig * config);

typedef void (^KM_Progress)(NSProgress * progress);

@interface KM_NetworkClient : NSObject


/** 大部分请求都是同一个URL */
+(RACSignal *)requestParams:(id)params;
/** 基本请求 可配置网络缓存 */
+(RACSignal *)requestParams:(id)params Cache:(BOOL)cache;

/** 使用默认 AFHTTPSessionManager 和 NetworkConfig */
+(RACSignal *)requestWithURLString:(NSString *)url
                            Params:(id)params;

/** 使用默认 AFHTTPSessionManager 发起请求 */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                             URLString:(NSString *)url
                                Params:(id)params;

/** 使用默认 AFHTTPSessionManager 发起请求 带进度回调 */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                             URLString:(NSString *)url
                                Params:(id)params
                              Progress:(KM_Progress)progress;


/** 修改 AFHTTPSessionManager 和 默认 NetworkConfig  */
+(RACSignal *)requestWithAFManagerSetting:(AFManagerSetting)setting
                             URLString:(NSString *)url
                                Params:(id)params;

/** 修改 AFHTTPSessionManager */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                      AFManagerSetting:(AFManagerSetting)setting
                             URLString:(NSString *)url
                                Params:(id)params;

/** 修改 AFHTTPSessionManager 带进度回调 */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                      AFManagerSetting:(AFManagerSetting)setting
                             URLString:(NSString *)url
                                Params:(id)params
                              Progress:(KM_Progress)progress;
/** 上传图片 */
+(RACSignal *)uploadImages:(NSArray<UIImage *> *)imageArr
                FieldNames:(NSArray<NSString *> *)fieldNameArr
                       URL:(NSString *)uploadUrl
                  Progress:(KM_Progress)progress;

@end
