//
//  KMFindPrinterTopCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMFindPrinterTopCell.h"

@interface KMFindPrinterTopCell ()

@property (nonatomic, strong) UIImageView * iconImg;

@property (nonatomic, strong) UILabel * statusLbl;

@property (nonatomic, strong) UILabel * tipsLbl;

@end

@implementation KMFindPrinterTopCell

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    _iconImg                                               = [UIImageView new];
    _iconImg.image                                         = IMAGE_NAMED(@"lanyatubiao");
    [self.contentView addSubview:_iconImg];
    
    _statusLbl                                             = [UILabel new];
    _statusLbl.font                                        = kFont32;
    _statusLbl.textColor                                   = kFontColorDark;
    _statusLbl.textAlignment                               = NSTextAlignmentCenter;
    [self.contentView addSubview:_statusLbl];
    
    _tipsLbl                                               = [UILabel new];
    _tipsLbl.font                                          = kFont24;
    _tipsLbl.textColor                                     = kFontColorGray;
    _tipsLbl.textAlignment                                 = NSTextAlignmentCenter;
    [self.contentView addSubview:_tipsLbl];
}
-(void)km_setupSubviewsLayout{
    UIView *content                                        = self.contentView;
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AdaptedHeight(24));
        make.centerX.mas_equalTo(content.mas_centerX);
        make.width.mas_equalTo(AdaptedWidth(90));
        make.height.mas_equalTo(AdaptedHeight(90));
    }];
    [_statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImg.mas_bottom).offset(AdaptedHeight(24));
        make.left.right.mas_equalTo(content);
        make.height.mas_equalTo([@"123" heightForFont:_statusLbl.font width:CGFLOAT_MAX]);
    }];
    [_tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_statusLbl.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.mas_equalTo(content);
        make.bottom.mas_equalTo(content).offset(AdaptedHeight(-24));
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[RACTuple class]]) {
        RACTuple *t                                        = data;
        RACTupleUnpack(NSString * status, NSString * tips) = t;
        [_statusLbl setText:status];
        [_tipsLbl setText:tips];
    }
}

@end
