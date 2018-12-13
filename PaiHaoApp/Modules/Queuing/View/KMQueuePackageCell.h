//
//  KMQueuePackageCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMQueuePackageCell : KMBaseTableViewCell
/** 查看套餐 */
@property (nonatomic, strong) RACSubject * seeSubject;

+(CGFloat)cellHeight;

@end
