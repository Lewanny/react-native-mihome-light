//
//  KMEditPackageInfo.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMEditPackageInfo.h"

@implementation KMPackageRelate

@end

@implementation KMEditPackageInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"relate" : [KMPackageRelate class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end
