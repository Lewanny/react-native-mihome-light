//
//  NSString+KM_Extension.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KM_Extension)

/** 邮箱的有效性 */
- (BOOL)isEmailAddress;
/** 是否手机号码 只验证是11位的数字 */
- (BOOL)isMobilePhone;
/** 逆序 */
-(NSString *)reversed;

/** 十进制转二进制 */
+ (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal;

/** 二进制转十进制 */
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

@end
