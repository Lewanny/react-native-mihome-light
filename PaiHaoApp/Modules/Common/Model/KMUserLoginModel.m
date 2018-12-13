//
//  KMUserLoginModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserLoginModel.h"

@implementation KMUserLoginParamsModel

@end

@implementation KMUserLoginModel

-(instancetype)initWithEntrySet:(NSArray *)entrySet
                      ParamsSet:(NSArray *)paramsSet{
    if (self = [super initWithEntrySet:entrySet ParamsSet:paramsSet]) {
        self = [[self class] modelWithJSON:entrySet.firstObject];
        self.info = [KMUserLoginParamsModel modelWithJSON:[KMTool normalDictWithWeirdDictArr:paramsSet]];
    }
     return self;
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}




@end
