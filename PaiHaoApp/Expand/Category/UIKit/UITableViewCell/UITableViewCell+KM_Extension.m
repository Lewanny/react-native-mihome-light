//
//  UITableViewCell+KM_Extension.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "UITableViewCell+KM_Extension.h"

@implementation UITableViewCell (KM_Extension)

-(void)km_setSeparatorLineInset:(UIEdgeInsets)inset{
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:inset];
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:inset];
    }
}

+(NSString *)cellID{
    return NSStringFromClass([self class]);
}
@end
