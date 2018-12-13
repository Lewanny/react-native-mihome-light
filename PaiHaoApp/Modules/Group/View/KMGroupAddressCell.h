//
//  KMGroupAddressCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMGroupAddressCell : KMBaseTableViewCell

@property (nonatomic, strong) UIImageView * iconImg;

@property (nonatomic, strong) UILabel * textLbl;

+(CGFloat)cellHeight;

@end
