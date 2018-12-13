//
//  KMGroupOrderInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMGroupOrderInfo : NSObject

@property (nonatomic, assign) NSInteger  order;

@property (nonatomic, copy) NSString * groupName;

@property (nonatomic, copy) NSString * groupID;

@property (nonatomic, assign) BOOL  select;

@end
