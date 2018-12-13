//
//  KMPackageSettingItemCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMPackageSettingItemCell : KMBaseTableViewCell
/** 文字编辑事件 */
@property (nonatomic, strong) RACSubject * textSubject;

+(CGFloat)cellHeight;

@end
