//
//  KMSelectWeekVC.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"

@interface KMSelectWeekVC : KMBaseViewController
@property (nonatomic, assign) KMWeek  selectWeek;
@property (nonatomic, copy) Block_Obj action;
-(NSArray <NSString *> *)weekText;
@end
