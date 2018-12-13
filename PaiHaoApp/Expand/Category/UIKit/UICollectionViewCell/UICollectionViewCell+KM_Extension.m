//
//  UICollectionViewCell+KM_Extension.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "UICollectionViewCell+KM_Extension.h"

@implementation UICollectionViewCell (KM_Extension)
+(NSString *)cellID{
    return NSStringFromClass([self class]);
}
@end
