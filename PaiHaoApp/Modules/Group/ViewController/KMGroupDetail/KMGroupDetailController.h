//
//  KMGroupDetailController.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"

@interface KMGroupDetailController : KMBaseViewController
/** 队列ID */
@property (nonatomic, copy) NSString * groupID;
/** 批量人数 0就是单人模式 */
@property (nonatomic, assign) NSInteger  singlenumber;

@end
