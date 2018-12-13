//
//  KMMerchantTypeModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMerchantTypeModel.h"

@implementation KMMerchantTypeModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
             @"ID" : @"id",
             @"typeName" : @"typename"
            };
}
@end
