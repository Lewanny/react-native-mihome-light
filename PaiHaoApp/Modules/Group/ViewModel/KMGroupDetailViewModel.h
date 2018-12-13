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
/** 号群ID */
@property (nonatomic, copy) NSString * groupID;
/** 号群详情 */
@property (nonatomic, strong) KMGroupDetailInfo * detailInfo;

/** 请求号群详情 */
@property (nonatomic, strong) RACCommand * detailCommand;
/** 删除号群 */
@property (nonatomic, strong) RACCommand * deleGroupCommand;
@end
