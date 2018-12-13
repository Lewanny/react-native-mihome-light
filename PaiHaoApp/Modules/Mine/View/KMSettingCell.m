//
//  KMSettingCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSettingCell.h"

@implementation KMSettingCell

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    self.backgroundColor        = [UIColor whiteColor];
    UIView *contentView         = self.contentView;
    
    _leftLabel                  = [UILabel new];
    [contentView addSubview:_leftLabel];
    
    _rightLabel                 = [UILabel new];
    [contentView addSubview:_rightLabel];
    
    _rightSwitch                = [UISwitch new];
    [contentView addSubview:_rightSwitch];
    
    _fullLabel                  = [UILabel new];
    [contentView addSubview:_fullLabel];
    
    [_leftLabel setFont:kFont32];
    [_leftLabel setTextColor:kFontColorDarkGray];
    
    [_rightLabel setFont:kFont28];
    [_rightLabel setTextColor:kFontColorDarkGray];
    [_rightLabel setTextAlignment:NSTextAlignmentRight];
    
    [_fullLabel setFont:kFont36];
    [_fullLabel setTextColor:kFontColorDarkGray];
    [_fullLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_rightSwitch setTintColor:kMainThemeColor];
    [_rightSwitch setOnTintColor:kMainThemeColor];
}
-(void)km_layoutSubviews{
    UIView *contentView         = self.contentView;
    [_leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(AdaptedWidth(24));
        make.top.bottom.mas_equalTo(contentView);
    }];
    [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView).offset(AdaptedWidth(-24));
        make.top.bottom.mas_equalTo(contentView);
    }];
    [_fullLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [_rightSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView).offset(AdaptedWidth(-24));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    
    [self configRightMode];
}

-(void)configRightMode{
    _leftLabel.hidden           = NO;
    switch (self.rightMode) {
        case RightModeNone:{
            _rightSwitch.hidden = YES;
            _rightLabel.hidden  = YES;
            _fullLabel.hidden   = YES;
        }
            break;
        case RightModeLabel:{
            _rightSwitch.hidden = YES;
            _rightLabel.hidden  = NO;
            _fullLabel.hidden   = YES;
        }
            break;
        case RightModeSwitch:{
            _rightSwitch.hidden = NO;
            _rightLabel.hidden  = YES;
            _fullLabel.hidden   = YES;
        }
            break;
        case RightModeFull:{
            _rightSwitch.hidden = YES;
            _rightLabel.hidden  = YES;
            _fullLabel.hidden   = NO;
            _leftLabel.hidden   = YES;
        }
            break;
        default:
            break;
    }
}

@end
