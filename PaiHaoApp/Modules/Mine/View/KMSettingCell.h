//
//  KMSettingCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, RightMode) {
    RightModeNone = 0,   //什么都没有
    RightModeLabel,      //Label
    RightModeSwitch,     //Switch
    RightModeFull        //Full
};

typedef void(^SwitchChangeBlock)(BOOL value);

@interface KMSettingCell : KMBaseTableViewCell

@property (nonatomic, assign) RightMode  rightMode;

@property (nonatomic, strong) UILabel * leftLabel;

@property (nonatomic, strong) UILabel * rightLabel;

@property (nonatomic, strong) UISwitch * rightSwitch;

@property (nonatomic, strong) UILabel * fullLabel;

@property (nonatomic, copy) SwitchChangeBlock valueChange;

@end
