//
//  KMHomePageViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMHomePageViewModel : KMBaseViewModel

@property (nonatomic, assign) NSInteger  messageCount;

/** 行业类型 */
@property (nonatomic, strong) NSMutableArray * categoryArr;

@property (nonatomic, assign) KM_GroupType  groupType;

/** 获取行业类别 */
@property (nonatomic, strong) RACCommand * requestCategory;
/** 获取推荐列表 */
@property (nonatomic, strong) RACCommand * requestRecommend;
/** 获取我的排号 */
@property (nonatomic, strong) RACCommand * requestMine;
/** 获取历史 */
@property (nonatomic, strong) RACCommand * requestHistory;

/** 获取未读消息数量 */
@property (nonatomic, strong) RACCommand * messagesNumberCommand;
/** 队列列表数据 */
-(NSArray *)groupArr;

@end
