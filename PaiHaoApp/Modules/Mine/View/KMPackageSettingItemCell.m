//
//  KMPackageSettingItemCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageSettingItemCell.h"
#import "KMGroupOrderInfo.h"
#import "KMEditPackageInfo.h"
@interface KMPackageSettingItemCell ()
/** 选中 */
@property (nonatomic, strong) UIImageView * selectIcon;

@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UILabel * orderLbl;

@property (nonatomic, strong) UITextField * orderTF;

@property (nonatomic, strong) KMGroupOrderInfo * info;

@property (nonatomic, strong) KMPackageRelate * relate;

@end

@implementation KMPackageSettingItemCell

+(CGFloat)cellHeight{
    return AdaptedHeight(80);
}

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    UIView *content          = self.contentView;
    _selectIcon              = [UIImageView new];
    [_selectIcon setContentMode:UIViewContentModeCenter];
    [_selectIcon setImage:IMAGE_NAMED(@"xuanzean1")];
    [content addSubview:_selectIcon];
    
    _nameLbl                 = [UILabel new];
    [_nameLbl setFont:kFont28];
    [_nameLbl setTextColor:kFontColorDarkGray];
    [content addSubview:_nameLbl];
    
    _orderLbl                = [UILabel new];
    [_orderLbl setFont:kFont24];
    [_orderLbl setTextColor:kFontColorGray];
    [_orderLbl setText:@"序号"];
    [content addSubview:_orderLbl];
    
    _orderTF                 = [UITextField new];
    [_orderTF setFont:kFont24];
    [_orderTF setTextColor:kFontColorDarkGray];
    [_orderTF setTextAlignment:NSTextAlignmentCenter];
    _orderTF.keyboardType    = UIKeyboardTypeNumberPad;
    @weakify(self)
    [_orderTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (self.info) {
            self.info.order  = [x integerValue];
        }
        if (self.relate) {
            self.relate.sort = [x integerValue];
        }
        [self km_layoutSubviews];
    }];
    [content addSubview:_orderTF];
}

-(void)km_setupSubviewsLayout{
    UIView *content          = self.contentView;
    [_selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(content);
        make.width.mas_equalTo(AdaptedWidth(60));
    }];
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(content);
        make.left.mas_equalTo(_selectIcon.mas_right);
        make.right.mas_equalTo(_orderLbl.mas_left);
    }];
    
    [_orderTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.centerY.mas_equalTo(content.mas_centerY);
        make.width.mas_equalTo(AdaptedWidth(AdaptedWidth(80)));
        make.height.mas_equalTo(AdaptedHeight(40));
    }];
    
    [_orderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(content);
        make.right.mas_equalTo(_orderTF.mas_left);
        make.width.mas_equalTo([_orderLbl.text widthForFont:_orderLbl.font]);
    }];
    
    [_orderTF layoutIfNeeded];
    [_orderTF cornerRadius:1 strokeSize:0.5 color:kFontColorDarkGray];
}

-(void)km_layoutSubviews{
   _orderTF.textColor        = [_orderTF.text integerValue] == 0 ? kFontColorDarkGray : kMainThemeColor;
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMPackageRelate class]]) {
        self.relate          = data;
        _selectIcon.image    = self.relate.selected ? IMAGE_NAMED(@"xuanzean") : IMAGE_NAMED(@"xuanzean1");
        [_nameLbl setText:self.relate.groupName];
        [_orderTF setText:NSStringFormat(@"%ld",self.relate.sort)];
    }else if ([data isKindOfClass:[KMGroupOrderInfo class]]){
        self.info            = data;
        _selectIcon.image    = _info.select ? IMAGE_NAMED(@"xuanzean") : IMAGE_NAMED(@"xuanzean1");
        [_nameLbl setText:_info.groupName];
        [_orderTF setText:NSStringFormat(@"%ld",_info.order)];
    }
    [self km_layoutSubviews];
}

#pragma mark - Lazy -
-(RACSubject *)textSubject{
    if (!_textSubject) {
        _textSubject         = [RACSubject subject];
    }
    return _textSubject;
}
@end
