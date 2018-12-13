//
//  KMCategoryViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMCategoryViewModel : KMBaseViewModel

@property (nonatomic, assign) NSInteger  currentPage;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray * groupList;
/** 行业类型 队列 */
@property (nonatomic, strong) RACCommand * requestCategoryList;

@property (nonatomic, assign) KMCategorySortType  sortType;

@property (nonatomic, assign) KMCategoryQueueSort  queueSort;

/** 筛选的区域 */
@property (nonatomic, copy) NSString * sortArea;

/** 根据排序类型获取数据源 */
-(NSArray *)dataArr;

@end
