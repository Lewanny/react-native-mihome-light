//
//  KMPackageSelectVC.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"
#import "KMGroupQueueDetailVM.h"
@interface KMPackageSelectVC : KMBaseViewController
/** 套餐信息 */
@property (nonatomic, copy) NSArray * packageList;
/** 已选择的套餐ID */
@property (nonatomic, copy) NSString * selectedID;
/** VM */
@property (nonatomic, strong) KMGroupQueueDetailVM * viewModel;

@end
