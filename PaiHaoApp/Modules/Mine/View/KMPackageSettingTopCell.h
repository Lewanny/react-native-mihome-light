//
//  KMPackageSettingTopCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMPackageSettingTopCell : KMBaseTableViewCell

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * info;

+(CGFloat)cellHeight;

@end
