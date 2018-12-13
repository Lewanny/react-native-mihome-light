//
//  KMQRCodeVC.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"
#import "KMGroupInfo.h"
@interface KMQRCodeVC : KMBaseViewController
/** 队列图片 */
@property (nonatomic, copy) NSString * groupIcon;
/** 队列名称 */
@property (nonatomic, copy) NSString * groupName;
/** 队列ID */
@property (nonatomic, copy) NSString * groupID;
/** 队列编号 */
@property (nonatomic, copy) NSString * groupNo;
/** 队列二维码 */
@property (nonatomic, copy) NSString * groupQRIcon;

@end
