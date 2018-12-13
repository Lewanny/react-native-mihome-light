//
//  NSObject+KM_Extension.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "NSObject+KM_Extension.h"

@implementation NSObject (KM_Extension)
- (NSString *)stringByReplaceUnicode:(NSString *)unicodeString
{
    NSMutableString *convertedString = [unicodeString mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}

@end
