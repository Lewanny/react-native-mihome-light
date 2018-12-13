//
//  KMBaseDictModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseDictModel.h"

@implementation KMBaseDictModel
-(instancetype)initWithName:(NSString *)name
                      Value:(NSString *)value{
    if (self = [super init]) {
        self.name = name;
        self.value = value;
    }
    return self;
}
@end
