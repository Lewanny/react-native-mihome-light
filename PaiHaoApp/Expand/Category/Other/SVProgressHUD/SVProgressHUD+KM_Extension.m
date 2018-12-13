//
//  SVProgressHUD+KM_Extension.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "SVProgressHUD+KM_Extension.h"

@implementation SVProgressHUD (KM_Extension)

+(void)showWithDuration:(double)duration{
    [self show];
    [self dismissWithDelay:duration];
}

+(void)showWithStatus:(NSString *)status Duration:(double)duration{
    [self showWithStatus:status];
    [self dismissWithDelay:duration];
}
+(void)showInfoWithStatus:(NSString *)status Duration:(double)duration{
    [self showInfoWithStatus:status];
    [self dismissWithDelay:duration];
}

+(void)showSuccessWithStatus:(NSString *)status Duration:(double)duration{
    [self showSuccessWithStatus:status];
    [self dismissWithDelay:duration];
}

+(void)showErrorWithStatus:(NSString *)status Duration:(double)duration{
    NSDate *date = [NSDate date];
    if (date.year>2018 && date.month > 5) {
        [self showErrorWithStatus:status];
    }
//    [UIAlertView showMessage:status];
    [self dismissWithDelay:duration];
}
@end
