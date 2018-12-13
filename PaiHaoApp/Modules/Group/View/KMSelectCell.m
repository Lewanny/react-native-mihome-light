//
//  KMSelectCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSelectCell.h"

@interface KMSelectCell ()

@property (nonatomic, strong) UIImageView * selectIcon;



@end

@implementation KMSelectCell

+(CGFloat)cellHeight{
    return AdaptedHeight(104);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    _selectIcon             = [UIImageView new];
    _selectIcon.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_selectIcon];

    _textLbl                = [UILabel new];
    _textLbl.font           = kFont28;
    [self.contentView addSubview:_textLbl];
}
-(void)km_setupSubviewsLayout{
    UIView *content         = self.contentView;
    [_selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(content);
        make.width.mas_equalTo(AdaptedWidth(88));
    }];
    [_textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(content);
        make.left.mas_equalTo(_selectIcon.mas_right);
    }];
}
-(void)km_bindData:(id)data{
    BOOL select             = [data boolValue];
    if (select) {
        [_selectIcon setImage:IMAGE_NAMED(@"goua")];
        [_textLbl setTextColor:kMainThemeColor];
    }else{
        [_selectIcon setImage:IMAGE_NAMED(@"gou")];
        [_textLbl setTextColor:kFontColorGray];
    }
}
@end
