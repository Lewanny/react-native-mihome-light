//
//  KMGroupQueueInfoCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMGroupQueueInfoCell : KMBaseTableViewCell

/** 点击二维码 */
@property (nonatomic, strong) RACSubject * QRSubject;

/** 点击电话 */
@property (nonatomic, strong) RACSubject * telSubject;
+(CGFloat)cellHeight;

@end
