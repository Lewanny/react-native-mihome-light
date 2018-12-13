//
//  KMGroupCommentCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupCommentCell.h"
#import "HCSStarRatingView.h"
#import "KMGroupCommentModel.h"
@interface KMGroupCommentCell ()
//头像
@property (nonatomic, strong) UIImageView * header;
//名称
@property (nonatomic, strong) UILabel * nameLbl;
//时间
@property (nonatomic, strong) UILabel * timeLbl;
//评论星星
@property (nonatomic, strong) HCSStarRatingView * starView;
//评论内容
@property (nonatomic, strong) UILabel * commentLbl;
@end

@implementation KMGroupCommentCell


+(CGFloat)cellHeight{
    return AdaptedHeight(236);
}
#pragma mark - BaseViewInterface
-(void)km_addSubviews{
   
    _header                          = [UIImageView new];
    _nameLbl                         = [UILabel new];
    _timeLbl                         = [UILabel new];
    _starView                        = [HCSStarRatingView new];
    _commentLbl                      = [UILabel new];
    
    UIView *contentView              = self.contentView;
    
    [contentView addSubview:_header];
    [contentView addSubview:_nameLbl];
    [contentView addSubview:_timeLbl];
    [contentView addSubview:_starView];
    [contentView addSubview:_commentLbl];
    
    _nameLbl.font                    = kFont26;
    _nameLbl.textColor               = kFontColorDark;
    
    _timeLbl.font                    = kFont26;
    _timeLbl.textColor               = kFontColorGray;
    
    _commentLbl.font                 = kFont26;
    _commentLbl.textColor            = kFontColorDark;
    _commentLbl.numberOfLines        = 0;
    
    _starView.emptyStarImage         = IMAGE_NAMED(@"xingb2");
    _starView.filledStarImage        = IMAGE_NAMED(@"xingb1");
    _starView.allowsHalfStars        = YES;
    _starView.userInteractionEnabled = NO;
}

-(void)km_setupSubviewsLayout{
    UIView * contentView             = self.contentView;
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(AdaptedWidth(24));
        make.top.mas_equalTo(contentView).offset(AdaptedHeight(24));
        make.width.mas_equalTo(AdaptedWidth(80));
        make.height.mas_equalTo(AdaptedHeight(80));
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_header.mas_top);
        make.left.mas_equalTo(_header.mas_right).offset(AdaptedWidth(20));
        make.right.mas_equalTo(contentView);
        make.height.mas_equalTo(AdaptedHeight(40));
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.bottom.mas_equalTo(_header.mas_bottom);
        make.width.mas_equalTo(AdaptedWidth(170));
        make.top.mas_equalTo(_nameLbl.mas_bottom).offset(AdaptedHeight(5));
    }];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_starView.mas_top);
        make.left.mas_equalTo(_starView.mas_right).offset(5);
        make.bottom.mas_equalTo(_starView.mas_bottom);
        make.right.mas_equalTo(contentView);
    }];
    
    [_commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.top.mas_equalTo(_header.mas_bottom).offset(AdaptedHeight(10));
        make.right.mas_equalTo(contentView).offset(AdaptedWidth(-24));
        make.bottom.mas_lessThanOrEqualTo(contentView).offset(AdaptedHeight(-24)).priorityHigh();
    }];
    [_header layoutIfNeeded];
    [_header setRoundedCorners:UIRectCornerAllCorners radius:_header.height/2.0];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMCommentItem class]]) {
        KMCommentItem *item          = data;
        [_nameLbl setText:item.raters];
        [_timeLbl setText:item.scoreTime];
        [_starView setValue:item.score];
        [_commentLbl setText:item.comment];
        [_header setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(item.headPortrait ? item.headPortrait : @"")] placeholder:GetHeaderPlaceholderImage];
    }
}



@end
