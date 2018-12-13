//
//  KMPackageManageCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageManageCell.h"
#import "KMPackageInfo.h"
@interface KMPackageManageCell ()

@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UILabel * infoLbl;

@property (nonatomic, strong) YYLabel * pNameLbl;

@property (nonatomic, strong) YYLabel * pInfoLbl;

@property (nonatomic, strong) UIButton * editBtn;

@property (nonatomic, strong) UIButton * deleBtn;

@end

@implementation KMPackageManageCell

+(CGFloat)cellHeight{
    return AdaptedHeight(92 * 3);
}

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    UIView *content         = self.contentView;
    //套餐名称
    _nameLbl                = [UILabel new];
    [_nameLbl setFont:kFont28];
    [_nameLbl setTextColor:kFontColorDarkGray];
    [_nameLbl setText:@"套餐名称: "];
    [content addSubview:_nameLbl];
    //套餐说明
    _infoLbl                = [UILabel new];
    [_infoLbl setFont:kFont28];
    [_infoLbl setTextColor:kFontColorDarkGray];
    [_infoLbl setText:@"套餐说明: "];
    [content addSubview:_infoLbl];
    
    //名称
    _pNameLbl               = [YYLabel new];
    [_pNameLbl setFont:kFont24];
    [_pNameLbl setTextColor:kFontColorGray];
    [_pNameLbl setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [_pNameLbl setTextContainerInset:UIEdgeInsetsMake(AdaptedHeight(5), AdaptedWidth(5), AdaptedHeight(5), AdaptedWidth(5))];
    [content addSubview:_pNameLbl];
    
    //说明
    _pInfoLbl               = [YYLabel new];
    [_pInfoLbl setFont:kFont24];
    [_pInfoLbl setTextColor:kFontColorGray];
    [_pInfoLbl setNumberOfLines:0];
    [_pInfoLbl setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [_pInfoLbl setTextContainerInset:UIEdgeInsetsMake(AdaptedHeight(5), AdaptedWidth(5), AdaptedHeight(5), AdaptedWidth(5))];
    [content addSubview:_pInfoLbl];
    
    //修改按钮
    _editBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editBtn.titleLabel setFont:kFont28];
    [_editBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
    @weakify(self)
    [_editBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.editSubject sendNext:nil];
    }];
    [content addSubview:_editBtn];
    
    //删除按钮
    _deleBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleBtn.titleLabel setFont:kFont28];
    [_deleBtn setBackgroundImage:[UIImage imageWithColor:kAppRedColor] forState:UIControlStateNormal];
    [_deleBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.deleSubject sendNext:nil];
    }];
    [content addSubview:_deleBtn];
}

-(void)km_setupSubviewsLayout{
    UIView *content         = self.contentView;
    CGFloat labelW          = [_nameLbl.text widthForFont:_nameLbl.font] + 3;
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(content).offset(AdaptedHeight(5));
        make.width.mas_equalTo(labelW);
    }];
    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pNameLbl.mas_bottom).offset(AdaptedHeight(10));
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.width.mas_equalTo(labelW);
    }];
    [_pNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(content).offset(AdaptedHeight(5));
        make.left.mas_equalTo(_nameLbl.mas_right);
        make.height.mas_equalTo(AdaptedHeight(92 - 10));
        make.right.mas_equalTo(content);
    }];
    [_pInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_infoLbl.mas_top);
        make.left.mas_equalTo(_infoLbl.mas_right);
        make.height.mas_equalTo(_pNameLbl.mas_height);
        make.right.mas_equalTo(content);
    }];
    [@[_editBtn, _deleBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptedWidth(116));
        make.height.mas_equalTo(AdaptedHeight(46));
        make.bottom.mas_equalTo(content).offset(AdaptedHeight(-23));
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(content.mas_centerX).offset(AdaptedWidth(-49));
    }];
    [_deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content.mas_centerX).offset(AdaptedWidth(49));
    }];
    UIView *lineA           = [UIView new];
    [lineA setBackgroundColor:kFontColorLightGray];
    [content addSubview:lineA];
    UIView *lineB           = [UIView new];
    [lineB setBackgroundColor:kFontColorLightGray];
    [content addSubview:lineB];
    
    [lineA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(_pNameLbl.mas_bottom).offset(AdaptedHeight(5));
    }];
    [lineB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(_pInfoLbl.mas_bottom).offset(AdaptedHeight(5));
    }];
    
    [_editBtn layoutIfNeeded];
    [_editBtn setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
    
    [_deleBtn layoutIfNeeded];
    [_deleBtn setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMPackageInfo class]]) {
        KMPackageInfo *info = data;
        [_pNameLbl setText:info.packagename];
        [_pInfoLbl setText:info.explain];
    }
}

#pragma mark - Lazy -
-(RACSubject *)editSubject{
    if (!_editSubject) {
        _editSubject        = [RACSubject subject];
    }
    return _editSubject;
}
-(RACSubject *)deleSubject{
    if (!_deleSubject) {
        _deleSubject        = [RACSubject subject];
    }
    return _deleSubject;
}
@end
