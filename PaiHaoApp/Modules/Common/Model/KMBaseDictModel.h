//
//  KMBaseDictModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMBaseDictModel : NSObject

@property (nonatomic, copy) NSString *compare;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;

-(instancetype)initWithName:(NSString *)name
                      Value:(NSString *)value;

@end
