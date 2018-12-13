//
//  KMGroupViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMGroupInfo.h"
@interface KMGroupViewModel : KMBaseViewModel

@property (nonatomic, strong) NSMutableArray * groupList;

/** 请求我的号群 */
@property (nonatomic, strong) RACCommand * requestGroupList;

-(NSString *)emptyTitle;
-(NSString *)emptySubTitle;


@end
