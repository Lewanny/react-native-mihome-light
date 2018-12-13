//
//  NSDictionary+KM_Extension.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KM_Extension)

/**
 *  @brief  将url参数转换成NSDictionary
 *
 *  @param query url参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query;

@end
