//
//  KMGroupAddressCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupAddressCell.h"

@implementation KMGroupAddressCell

+(CGFloat)cellHeight{
    return AdaptedHeight(104);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    [self.contentView addSubview:self.iconImg];
    [self.contentView addSubview:self.textLbl];
}

-(void)km_layoutSubviews{
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(AdaptedWidth(60));
    }];

    [self.textLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.iconImg.mas_right);
    }];
}

#pragma mark - Lazy
-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg             = [UIImageView new];
        _iconImg.contentMode = UIViewContentModeCenter;
    }
    return _iconImg;
}
-(UILabel *)textLbl{
    if (!_textLbl) {
        _textLbl             = [UILabel new];
        _textLbl.font        = kFont28;
        _textLbl.textColor   = kFontColorBlack;
    }
    return _textLbl;
}

@end
