//
//  KMGroupQueueInfoVC.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"
/** 队列详情 我的排号入口 */
@interface KMGroupQueueInfoVC : KMBaseViewController
/** 队列ID */
@property (nonatomic, copy) NSString * groupID;
/** 排队ID */
@property (nonatomic, copy) NSString * queueID;
@end
