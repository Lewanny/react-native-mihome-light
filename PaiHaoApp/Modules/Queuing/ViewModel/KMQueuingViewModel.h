//
//  KMQueuingViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMQueuingViewModel : KMBaseViewModel

/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataArr;

/** 我的排号 */
@property (nonatomic, strong) RACCommand * requestMyQueue;

@end
