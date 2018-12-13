//
//  KMGroupDetailViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMGroupDetailInfo.h"
@interface KMGroupDetailViewModel : KMBaseViewModel
/** 队列ID */
@property (nonatomic, copy) NSString * groupID;
/** 队列详情 */
@property (nonatomic, strong) KMGroupDetailInfo * detailInfo;

/** 请求队列详情 */
@property (nonatomic, strong) RACCommand * detailCommand;
/** 删除队列 */
@property (nonatomic, strong) RACCommand * deleGroupCommand;
@end
