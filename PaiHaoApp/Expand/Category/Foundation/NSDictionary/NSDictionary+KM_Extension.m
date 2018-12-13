//
//  NSDictionary+KM_Extension.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "NSDictionary+KM_Extension.h"

@implementation NSDictionary (KM_Extension)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(descriptionWithLocale:indent:) with:@selector(km_descriptionWithLocale:indent:)];
        
    });
    
}

- (NSString *)km_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    return [self stringByReplaceUnicode:[self km_descriptionWithLocale:locale indent:level]];
}

/**
 *  @brief  将url参数转换成NSDictionary
 *
 *  @param query url参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *parameters = [[query componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"&"];
    for(NSString *parameter in parameters) {
        NSArray *contents = [parameter componentsSeparatedByString:@"="];
        if([contents count] == 2) {
            NSString *key = contents.firstObject;
            NSString *value = contents.lastObject;
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (key && value) {
                [dict setObject:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
