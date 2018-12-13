//
//  KMEvaluateCommitVC.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"

@interface KMEvaluateCommitVC : KMBaseViewController
/** 排号ID */
@property (nonatomic, copy) NSString * queueID;
/** 刷新 */
@property (nonatomic, strong) RACSubject * refreshSubject;
@end
