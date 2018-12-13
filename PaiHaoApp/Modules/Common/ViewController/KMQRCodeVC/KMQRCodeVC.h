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
/** 号群图片 */
@property (nonatomic, copy) NSString * groupIcon;
/** 号群名称 */
@property (nonatomic, copy) NSString * groupName;
/** 号群ID */
@property (nonatomic, copy) NSString * groupID;
/** 号群编号 */
@property (nonatomic, copy) NSString * groupNo;
/** 号群二维码 */
@property (nonatomic, copy) NSString * groupQRIcon;

@end
