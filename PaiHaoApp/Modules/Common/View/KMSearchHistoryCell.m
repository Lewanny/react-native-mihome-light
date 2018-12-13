//
//  KMSearchHistoryCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSearchHistoryCell.h"

@interface KMSearchHistoryCell ()

@property (nonatomic, strong) UIImageView * leftIcon;

@property (nonatomic, strong) UILabel * textLbl;

@property (nonatomic, strong) UIButton * deleBtn;

@end

@implementation KMSearchHistoryCell

+(CGFloat)cellHeight{
    return AdaptedHeight(76);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{

//    _leftIcon = [UIImageView new];
//    _leftIcon.contentMode = UIViewContentModeCenter;
//    _leftIcon.image = IMAGE_NAMED(@"lsjvv");
//    [self.contentView addSubview:_leftIcon];

    _textLbl            = [UILabel new];
    _textLbl.font       = kFont28;
    _textLbl.textColor  = kFontColorDarkGray;
    [self.contentView addSubview:_textLbl];

    _deleBtn            = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleBtn setImage:IMAGE_NAMED(@"sscha") forState:UIControlStateNormal];
    @weakify(self)
    [[_deleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.deleSubject sendNext:nil];
    }];
    [self.contentView addSubview:_deleBtn];
}
-(void)km_setupSubviewsLayout{
    UIView *contentView = self.contentView;
//    [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(contentView).offset(AdaptedWidth(20));
//        make.top.bottom.mas_equalTo(contentView);
//        make.width.mas_equalTo(15);
//    }];
    [_deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentView);
        make.top.bottom.mas_equalTo(contentView);
        make.width.mas_equalTo(40);
    }];
    [_textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(AdaptedWidth(24));
        make.top.bottom.mas_equalTo(contentView);
        make.right.mas_equalTo(_deleBtn.mas_left);
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[NSString class]]) {
        [_textLbl setText:data];
    }
}

#pragma mark - Lazy
-(RACSubject *)deleSubject{
    if (!_deleSubject) {
    _deleSubject        = [RACSubject subject];
    }
    return _deleSubject;
}

@end
