//
//  NSArray+KM_Extension.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "NSArray+KM_Extension.h"

@implementation NSArray (KM_Extension)

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


@end
