//
//  KMCitySelectTopCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMCitySelectTopCell : KMBaseTableViewCell

@property (nonatomic, copy) NSArray * cityNameArray;

@property (nonatomic, copy) Block_Str selectCity;

+(CGFloat)cellHeightWithCityNameArr:(NSArray *)cityNameArr;

@end
