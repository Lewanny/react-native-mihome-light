//
//  KMGroupCallController.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"
#import "KMGroupDetailInfo.h"
@interface KMGroupCallController : KMBaseViewController
/** 号群ID */
@property (nonatomic, copy) NSString * groupID;
/** 号群详情 */
@property (nonatomic, strong) KMGroupDetailInfo * detailInfo;
/** 批量叫号人数 */
@property (nonatomic, assign) NSInteger singleNumber;

@end