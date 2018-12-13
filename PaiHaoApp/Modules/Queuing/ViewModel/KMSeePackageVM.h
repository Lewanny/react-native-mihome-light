//
//  KMSeePackageVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMPackageStatusInfo : NSObject
/** 号群名称 */
@property (nonatomic, copy) NSString *groupName;
/** 状态 */
@property (nonatomic, assign) NSInteger status;
/** 序号 */
@property (nonatomic, assign) NSInteger sort;

@end

@interface KMSeePackageVM : KMBaseViewModel

@property (nonatomic, strong) NSMutableArray * infoArr;

@property (nonatomic, strong) RACCommand * packageCommand;

@end
