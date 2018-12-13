//
//  KMPackageSettingTopCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageSettingTopCell.h"
#import "KMEditPackageInfo.h"
@interface KMPackageSettingTopCell ()<YYTextViewDelegate>

@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UILabel * infoLbl;

@property (nonatomic, strong) YYTextView * nameTextView;

@property (nonatomic, strong) YYTextView * infoTextView;

@property (nonatomic, strong) KMEditPackageInfo * packageInfo;

@end

@implementation KMPackageSettingTopCell

+(CGFloat)cellHeight{
    return AdaptedHeight(102 + 206);
}

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    UIView *content                             = self.contentView;
    _nameLbl                                    = [UILabel new];
    [_nameLbl setFont:kFont32];
    [_nameLbl setTextColor:kFontColorDarkGray];
    [_nameLbl setText:@"套餐名称:"];
    [content addSubview:_nameLbl];
    
    _infoLbl                                    = [UILabel new];
    [_infoLbl setFont:kFont32];
    [_infoLbl setTextColor:kFontColorDarkGray];
    [_infoLbl setText:@"套餐说明:"];
    [content addSubview:_infoLbl];
    
    _nameTextView                               = [YYTextView new];
    [_nameTextView setPlaceholderText:@"请输入套餐名称"];
    [_nameTextView setFont:kFont24];
    [_nameTextView setPlaceholderFont:kFont24];
    [_nameTextView setTextColor:kFontColorGray];
    [_nameTextView setTextVerticalAlignment:YYTextVerticalAlignmentCenter];
    _nameTextView.delegate                      = self;
    [content addSubview:_nameTextView];
    
    _infoTextView                               = [YYTextView new];
    [_infoTextView setPlaceholderText:@"请输入套餐说明"];
    [_infoTextView setFont:kFont24];
    [_infoTextView setPlaceholderFont:kFont24];
    [_infoTextView setTextColor:kFontColorGray];
    _infoTextView.delegate                      = self;
    [content addSubview:_infoTextView];
}

-(void)km_setupSubviewsLayout{
    UIView *content                             = self.contentView;
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(content);
        make.height.mas_equalTo(AdaptedHeight(102));
    }];
    [_nameTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLbl.mas_right);
        make.top.mas_equalTo(_nameLbl.mas_top).offset(AdaptedHeight(20));
        make.bottom.mas_equalTo(_nameLbl.mas_bottom).offset(AdaptedHeight(-20));
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
    }];
    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(_nameLbl.mas_bottom);
        make.height.mas_equalTo(AdaptedHeight(102));
    }];
    
    [_infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_infoLbl.mas_right);
        make.top.mas_equalTo(_nameTextView.mas_bottom).offset(AdaptedHeight(20 * 2));
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(AdaptedHeight(136));
    }];
    
    UIView *line                                = [UIView new];
    [line setBackgroundColor:kFontColorLightGray];
    [content addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(content);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(_nameLbl.mas_bottom);
    }];
    
    [_nameTextView layoutIfNeeded];
    [_nameTextView cornerRadius:1 strokeSize:0.5 color:kFontColorLightGray];
    [_infoTextView layoutIfNeeded];
    [_infoTextView cornerRadius:1 strokeSize:0.5 color:kFontColorLightGray];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMEditPackageInfo class]]) {
        self.packageInfo                        = data;
        [_nameTextView setText:self.packageInfo.packageName];
        [_infoTextView setText:self.packageInfo.explain];
        self.name                               = self.packageInfo.packageName;
        self.info                               = self.packageInfo.explain;
    }
}

#pragma mark - YYTextViewDelegate -
- (void)textViewDidChange:(YYTextView *)textView{
    if ([textView isEqual:_nameTextView]) {
        _name                                   = textView.text;
        _packageInfo ? _packageInfo.packageName = textView.text : nil;
    }else if ([textView isEqual:_infoTextView]){
        _info                                   = textView.text;
        _packageInfo ? _packageInfo.explain     = textView.text : nil;
    }
}
@end
