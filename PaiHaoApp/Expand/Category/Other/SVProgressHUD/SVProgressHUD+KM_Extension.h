//
//  SVProgressHUD+KM_Extension.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (KM_Extension)

+(void)showWithDuration:(double)duration;

+(void)showWithStatus:(NSString *)status Duration:(double)duration;

+(void)showInfoWithStatus:(NSString *)status Duration:(double)duration;

+(void)showSuccessWithStatus:(NSString *)status Duration:(double)duration;

+(void)showErrorWithStatus:(NSString *)status Duration:(double)duration;
@end
