//
//  KMPackageInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageInfoCell.h"
#import "KMPackageItem.h"
@interface KMPackageInfoCell ()
/** 选择 */
@property (nonatomic, strong) UIImageView * selectIcon;
/** 套餐名称 */
@property (nonatomic, strong) UILabel * nameLbl;
/** 套餐内容 */
@property (nonatomic, strong) UILabel * contentLbl;
@end

@implementation KMPackageInfoCell


+(CGFloat)cellHeight{
    return UITableViewAutomaticDimension;
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    UIView *contentView       = self.contentView;
    //选择
    _selectIcon               = [UIImageView new];
    _selectIcon.contentMode   = UIViewContentModeCenter;
    [contentView addSubview:_selectIcon];
    //套餐名称
    _nameLbl                  = [UILabel new];
    _nameLbl.font             = kFont30;
    _nameLbl.textColor        = kFontColorDark;
    _nameLbl.numberOfLines    = 0;
//    _nameLbl.textAlignment    = NSTextAlignmentCenter;
    [contentView addSubview:_nameLbl];
    //套餐内容
    _contentLbl               = [UILabel new];
    _contentLbl.font          = kFont24;
    _contentLbl.textColor     = kFontColorDarkGray;
    _contentLbl.numberOfLines = 0;
    [contentView addSubview:_contentLbl];
}
-(void)km_setupSubviewsLayout{
    UIView *contentView       = self.contentView;
    //选择
    [_selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(contentView);
        make.width.height.mas_equalTo(30);
    }];
    //套餐名称
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectIcon.mas_right);
        make.top.mas_equalTo(contentView);
        make.right.mas_equalTo(contentView).offset(AdaptedWidth(-10));
        make.height.mas_greaterThanOrEqualTo(30).priorityMedium();
    }];
    //套餐内容
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(60);
        make.top.mas_equalTo(_nameLbl.mas_bottom).offset(AdaptedHeight(10));
        make.bottom.mas_equalTo(contentView).offset(AdaptedHeight(-10));
        make.right.mas_equalTo(contentView).offset(AdaptedWidth(-10));
//        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMPackageItem class]]) {
        KMPackageItem *item   = data;
        _selectIcon.image     = item.selected ? IMAGE_NAMED(@"xuanzean") : IMAGE_NAMED(@"xuanzean1");
        [_nameLbl setText:[item.packageName stringByAppendingString:@":"]];
        [_contentLbl setText:item.pg];
        [self.contentView layoutIfNeeded];
    }
}

@end
