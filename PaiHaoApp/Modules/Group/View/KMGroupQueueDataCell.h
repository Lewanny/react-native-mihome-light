//
//  KMGroupQueueDataCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMGroupQueueDataCell : KMBaseTableViewCell
/** 号码 */
@property (nonatomic, strong) UILabel * numberLbl;
/** 手机号码 */
@property (nonatomic, strong) UILabel * teleLbl;
/** 窗口 */
@property (nonatomic, strong) UILabel * windowLbl;

+(CGFloat)cellHeight;

@end
