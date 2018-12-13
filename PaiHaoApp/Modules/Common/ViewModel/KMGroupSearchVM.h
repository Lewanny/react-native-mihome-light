//
//  KMGroupSearchVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

#import "KMGroupBriefModel.h"

@interface KMGroupSearchVM : KMBaseViewModel

@property (nonatomic, assign) NSInteger  currentPage;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray * historyArr;
/** 搜索结果 */
@property (nonatomic, strong) NSMutableArray * resultArr;
/** 搜索 */
@property (nonatomic, strong) RACCommand * searchCommand;

@end
