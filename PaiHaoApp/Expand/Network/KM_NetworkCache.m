//
//  KM_NetworkCache.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KM_NetworkCache.h"
static NSString *const KMNetworkResponseCache = @"KMNetworkResponseCache";
@implementation KM_NetworkCache
+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters {
NSString *cacheKey                            = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [[self dataCache] setObject:httpData forKey:cacheKey withBlock:nil];
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
NSString *cacheKey                            = [self cacheKeyWithURL:URL parameters:parameters];
    return [[self dataCache] objectForKey:cacheKey];
}

+ (NSInteger)getAllHttpCacheSize {
    return [[self dataCache].diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [[self dataCache].diskCache removeAllObjects];
}

+ (YYCache *)dataCache {
    return [YYCache cacheWithName:KMNetworkResponseCache];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters){return URL;};
    // 将参数字典转换成字符串
NSData *stringData                            = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
NSString *paraString                          = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];

    // 将URL与转换好的参数字符串拼接在一起,成为最终存储的KEY值
NSString *cacheKey                            = [NSString stringWithFormat:@"%@%@",URL,paraString];

    return cacheKey;
}

@end
