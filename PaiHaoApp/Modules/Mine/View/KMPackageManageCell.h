//
//  KMPackageManageCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMPackageManageCell : KMBaseTableViewCell

@property (nonatomic, strong) RACSubject * editSubject;

@property (nonatomic, strong) RACSubject * deleSubject;

+(CGFloat)cellHeight;

@end
