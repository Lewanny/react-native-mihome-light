//
//  KMSettingWindowCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMSettingWindowCell : KMBaseTableViewCell
/** 左边文字 */
@property (nonatomic, strong) UILabel * leftLbl;
/** 选择按钮 */
@property (nonatomic, strong) UIButton * selectedBtn;

+(CGFloat)cellHeight;

@end
