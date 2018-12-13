//
//  KMNewGroupCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMNewGroupCell.h"

@interface KMNewGroupCell ()

/** 右边箭头 */
@property (nonatomic, strong) UIImageView * rightArrow;
/** 号群图片 */
@property (nonatomic, strong) UIImageView * photo;
/** 左边文字 */
@property (nonatomic, strong) UILabel * leftText;
/** 右边文字 */
@property (nonatomic, strong) YYLabel * rightText;
/** 输入 TextField */
@property (nonatomic, strong) UITextField * textF;
/** 开关 */
@property (nonatomic, strong) UISwitch * rightSwitch;
/** 占位文字 */
@property (nonatomic, copy) NSString * placeHolder;
/** 类型 */
@property (nonatomic, assign) NewGroupCellStyle  cellStyle;


@end

@implementation KMNewGroupCell

#pragma mark -

-(void)layoutWithCellStyle:(NewGroupCellStyle)cellStyle{
    UIView * rightView  = nil;
    UIView *contentView = self.contentView;
    _textF.hidden       = YES;
    _rightArrow.hidden  = YES;
    _rightText.hidden   = YES;
    _rightSwitch.hidden = YES;
    _photo.hidden       = YES;
    _rightText.text     = @"";


    [@[_rightArrow, _rightText, _rightSwitch, _textF, _photo] mas_remakeConstraints:^(MASConstraintMaker *make) {

    }];

    /** 箭头 */
    if (cellStyle & NewGroupCellStyleArrow) {
    _rightArrow.hidden  = NO;
        [_rightArrow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(contentView);
            make.width.mas_equalTo(10);
            make.right.mas_equalTo(contentView).offset(AdaptedWidth(-24));
        }];
    rightView           = _rightArrow;
    }
    /** 右Label */
    if (cellStyle & NewGroupCellStyleLabel) {
    _rightText.hidden   = NO;
        [_rightText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView).offset(AdaptedHeight(24));
            make.bottom.mas_equalTo(contentView).offset(AdaptedHeight(-24));
            make.right.mas_equalTo(rightView ? rightView.mas_left : contentView).offset(AdaptedWidth(-24));
            make.left.mas_greaterThanOrEqualTo(_leftText.mas_right);
            make.height.mas_greaterThanOrEqualTo(30).priorityHigh();
            make.width.mas_greaterThanOrEqualTo(30);
        }];
    rightView           = _rightText;
    }
    /** Switch开关 */
    if (cellStyle & NewGroupCellStyleSwitch) {
    _rightSwitch.hidden = NO;
        [_rightSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightView ? rightView.mas_left : contentView).offset(AdaptedWidth(-24));
            make.top.mas_equalTo(contentView).offset(AdaptedHeight(24));
            make.bottom.mas_equalTo(contentView).offset(AdaptedHeight(-24));
            make.height.mas_greaterThanOrEqualTo(30).priorityHigh();
        }];
    rightView           = _rightSwitch;
    }
    /** textField输入 */
    if (cellStyle & NewGroupCellStyleTextField) {
    _textF.hidden       = NO;
        [_textF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView).offset(AdaptedHeight(24));
            make.bottom.mas_equalTo(contentView).offset(AdaptedHeight(-24));
            make.height.mas_greaterThanOrEqualTo(30).priorityHigh();
            make.left.mas_equalTo(_leftText.mas_right).offset(AdaptedWidth(24));
            make.right.mas_equalTo(rightView ? rightView.mas_left : contentView).offset(AdaptedWidth(-24));
        }];
    }
    /** 照片 */
    if (cellStyle & NewGroupCellStylePhoto) {
    _photo.hidden       = NO;
        [_photo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView).offset(AdaptedHeight(27));
            make.width.mas_equalTo(AdaptedWidth(90));
            make.height.mas_equalTo(AdaptedHeight(90)).priorityHigh();
            make.right.mas_equalTo(_rightArrow.mas_left).offset(-AdaptedWidth(160));
            make.bottom.mas_lessThanOrEqualTo(contentView).offset(AdaptedHeight(-27));
        }];
    }
}

-(void)bindRightText:(NSString *)text
              PlaceHolder:(NSString *)placeHolder
               Style:(NewGroupCellStyle)style
            SwitchOn:(BOOL)switchOn{
    if (style & NewGroupCellStyleTextField) {
        [_textF setPlaceholder:placeHolder];
        [_textF setText:text];
    }else{
        [_textF setPlaceholder:@""];
        [_textF setText:@""];
    }

    if (style & NewGroupCellStyleLabel) {
        [_rightText setText:text.length ? text : placeHolder];
    }else{
        [_rightText setText:@""];
    }

    if (style & NewGroupCellStyleSwitch) {
        [_rightSwitch setOn:switchOn];
        if (_cellStyle & NewGroupCellStyleTextField) {
            _textF.hidden = !switchOn;
        }
    }else{
        [_rightSwitch setOn:NO];
    }
}

-(void)switchValueChange:(UISwitch *)sender{
    //同时有 switch 和 textField
    [self.editSubject sendNext:@(sender.on)];
    if (_cellStyle & NewGroupCellStyleTextField) {
    _textF.hidden                      = !sender.on;
    }
}


#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    UIView *contentView                = self.contentView;
    [contentView addSubview:self.leftText];
    [contentView addSubview:self.rightText];
    [contentView addSubview:self.textF];
    [contentView addSubview:self.rightArrow];
    [contentView addSubview:self.rightSwitch];
    [contentView addSubview:self.photo];
}
-(void)km_layoutSubviews{
    CGFloat labelW                     = [self.leftText.text widthForFont:self.leftText.font] + 5;
    _rightText.preferredMaxLayoutWidth = KScreenWidth - labelW - AdaptedWidth(24 * 3 + 10);
    [self.leftText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptedWidth(24));
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(labelW);
        make.right.mas_lessThanOrEqualTo(self.rightText.mas_left).priorityHigh();
        make.height.mas_greaterThanOrEqualTo(30).priorityHigh();
    }];
    if (!_photo.hidden) {
        [_photo setRoundedCorners:UIRectCornerAllCorners radius:5];
    }
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[RACTuple class]]) {
        RACTuple *tuple                                                                                                                                                                           = data;
        RACTupleUnpack(NSNumber *styleNum, NSString *placeHolder, NSString *leftText, NSString *rightText, NSNumber *swcithOn, NSString *photo, NSNumber *keyboardType, NSNumber *rightTapEnable) = tuple;

        _cellStyle                                                                                                                                                                                = [styleNum integerValue];
        _placeHolder                                                                                                                                                                              = placeHolder;
        [_textF setKeyboardType:[keyboardType integerValue]];
        [_leftText setText:leftText];
        _rightText.userInteractionEnabled                                                                                                                                                         = [rightTapEnable integerValue];
        NewGroupCellStyle style                                                                                                                                                                   = [styleNum integerValue];
        //先布局样式
        [self layoutWithCellStyle:style];
        //绑定数据
        [self bindRightText:rightText
                PlaceHolder:placeHolder
                      Style:style
                   SwitchOn:[swcithOn boolValue]];
        //图片
        if (!_photo.hidden) {
            if (photo.length) {
                [_photo setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(photo ? photo : @"")] placeholder:GetNormalPlaceholderImage];
            }else{
                [_photo setImage:GetNormalPlaceholderImage];
            }
        }
    }
}
#pragma mark - Lazy
-(UILabel *)leftText{
    if (!_leftText) {
        _leftText                = [UILabel new];
        _leftText.font           = kFont32;
        _leftText.textColor      = kFontColorDarkGray;
    }
    return _leftText;
}
-(UIImageView *)photo{
    if (!_photo) {
        _photo                   = [UIImageView new];
    }
    return _photo;
}
-(YYLabel *)rightText{
    if (!_rightText) {
        _rightText               = [YYLabel new];
        _rightText.font          = kFont28;
        _rightText.textColor     = kFontColorGray;
        _rightText.textAlignment = NSTextAlignmentRight;
        _rightText.numberOfLines = 0;
        @weakify(self)
        _rightText.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self)
        NSRange midRange         = [text.string rangeOfString:@" － "];
            if (range.location < midRange.location) {
                [self.editSubject sendNext:@(YES)];
            }else if (range.location > midRange.location){
                [self.editSubject sendNext:@(NO)];
            }
        };
    }
    return _rightText;
}
-(UITextField *)textF{
    if (!_textF) {
        _textF                   = [UITextField new];
        _textF.font              = kFont28;
        _textF.textColor         = kFontColorGray;
        _textF.textAlignment     = NSTextAlignmentRight;
        _textF.borderStyle       = UITextBorderStyleNone;
        @weakify(self)
        [[_textF.rac_textSignal skip:1] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self)
            [self.editSubject sendNext:x];
        }];
    }
    return _textF;
}
-(UIImageView *)rightArrow{
    if (!_rightArrow) {
        _rightArrow              = [UIImageView new];
        _rightArrow.image        = IMAGE_NAMED(@"youjt");
        _rightArrow.contentMode  = UIViewContentModeRight;
    }
    return _rightArrow;
}
-(UISwitch *)rightSwitch{
    if (!_rightSwitch) {
        _rightSwitch             = [UISwitch new];
        _rightSwitch.tintColor   = kMainThemeColor;
        _rightSwitch.onTintColor = kMainThemeColor;
        [_rightSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}


-(RACSubject *)editSubject{
    if (!_editSubject) {
        _editSubject             = [RACSubject subject];
    }
    return _editSubject;
}
@end
