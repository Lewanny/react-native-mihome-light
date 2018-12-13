//
//  KMSettingWindowCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSettingWindowCell.h"
#import "KMWindowInfo.h"
@implementation KMSettingWindowCell

+(CGFloat)cellHeight{
    return 50.0;
}

#pragma mark - BaseViewInterface

-(void)km_addSubviews{
    [self.contentView addSubview:self.leftLbl];
    [self.contentView addSubview:self.selectedBtn];
}

-(void)km_layoutSubviews{
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptedWidth(64));
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(_selectedBtn.mas_left);
    }];
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(AdaptedWidth(-24));
        make.width.mas_equalTo(_selectedBtn.mas_height).priorityHigh();
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMWindowInfo class]]) {
        KMWindowInfo * info       = data;
        self.selectedBtn.selected = info.selected;
        [self.leftLbl setText:info.windowName];
        if (info.selected) {
            [self.leftLbl setTextColor:kMainThemeColor];
        }else{
            [self.leftLbl setTextColor:kFontColorDarkGray];
        }
    }else if ([data isKindOfClass:[NSNumber class]]){
        BOOL ret                  = [data boolValue];
        self.selectedBtn.selected = ret;
        if (ret) {
            [self.leftLbl setTextColor:kMainThemeColor];
        }else{
            [self.leftLbl setTextColor:kFontColorDarkGray];
        }
    }
}

#pragma mark - Lazy
-(UILabel *)leftLbl{
    if (!_leftLbl) {
        _leftLbl                  = [UILabel new];
        _leftLbl.font             = kFont28;
    }
    return _leftLbl;
}
-(UIButton *)selectedBtn{
    if (!_selectedBtn) {
        _selectedBtn              = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:IMAGE_NAMED(@"gou") forState:UIControlStateNormal];
        [_selectedBtn setImage:IMAGE_NAMED(@"goua") forState:UIControlStateSelected];
    }
    return _selectedBtn;
}
@end
