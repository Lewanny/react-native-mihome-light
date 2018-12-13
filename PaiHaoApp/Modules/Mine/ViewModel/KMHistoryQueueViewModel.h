//
//  KMHistoryQueueViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMHistoryQueueModel.h"
@interface KMHistoryQueueViewModel : KMBaseViewModel
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * historyList;
/** 请求历史排队列表 */
@property (nonatomic, strong) RACCommand * requestHistory;
/** 删除历史排队 */
@property (nonatomic, strong) RACCommand * deleHistory;
@end
