//
//  KMGroupQueueInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueInfoCell.h"
#import "KMGroupBaseInfo.h"

@interface KMGroupQueueInfoCell ()
/** 号群图片 */
@property (nonatomic, strong) UIImageView * iconImg;
/** 号群名称 */
@property (nonatomic, strong) UILabel * nameLbl;
/** 距离 */
@property (nonatomic, strong) UILabel * distanceLbl;
/** 号群ID */
@property (nonatomic, strong) UILabel * IDLbl;
/** 时间段 */
@property (nonatomic, strong) UILabel * timeLbl;
/** 地址 */
@property (nonatomic, strong) UILabel * addressLbl;
/** 二维码按钮 */
@property (nonatomic, strong) UIButton * QRBtn;
/** 电话 */
@property (nonatomic, strong) UIButton * callBtn;
@end


@implementation KMGroupQueueInfoCell

+(CGFloat)cellHeight{
    return AdaptedHeight(214);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    UIView *contentView        = self.contentView;
    //号群图片
    _iconImg                   = [UIImageView new];
    [contentView addSubview:_iconImg];
    //号群名称
    _nameLbl                   = [UILabel new];
    _nameLbl.font              = kFont30;
    _nameLbl.textColor         = kFontColorDark;
    _nameLbl.numberOfLines     = 0;
    [contentView addSubview:_nameLbl];
    //距离
    _distanceLbl               = [UILabel new];
    _distanceLbl.font          = kFont24;
    _distanceLbl.textColor     = kFontColorGray;
    _distanceLbl.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:_distanceLbl];
    //ID
    _IDLbl                     = [UILabel new];
    _IDLbl.font                = kFont24;
    _IDLbl.textColor           = kMainThemeColor;
    _IDLbl.textAlignment       = NSTextAlignmentRight;
    [contentView addSubview:_IDLbl];
    //时间段
    _timeLbl                   = [UILabel new];
    _timeLbl.font              = kFont26;
    _timeLbl.textColor         = kFontColorGray;
    [contentView addSubview:_timeLbl];
    //地址
    _addressLbl                = [UILabel new];
    _addressLbl.font           = kFont26;
    _addressLbl.textColor      = kFontColorGray;
    [contentView addSubview:_addressLbl];
    //二维码按钮
    _QRBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_QRBtn setImage:IMAGE_NAMED(@"erweima") forState:UIControlStateNormal];
    [_QRBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [contentView addSubview:_QRBtn];
    //电话
    _callBtn                   = [UIButton buttonWithType:UIButtonTypeCustom];
    [_callBtn setImage:IMAGE_NAMED(@"dianhua") forState:UIControlStateNormal];
    [_callBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [contentView addSubview:_callBtn];
}

-(void)km_setupSubviewsLayout{
    UIView *contentView = self.contentView;
    //号群图片
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView).offset(AdaptedWidth(24));
        make.top.mas_equalTo(contentView).offset(AdaptedHeight(20));
        make.width.mas_equalTo(AdaptedWidth(174));
        make.height.mas_equalTo(AdaptedHeight(174));
    }];
    //号群名称
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImg.mas_right).offset(AdaptedWidth(20));
        make.top.mas_equalTo(_iconImg.mas_top);
        make.height.mas_lessThanOrEqualTo(_iconImg.mas_height).multipliedBy(0.5);
        make.right.mas_equalTo(_distanceLbl.mas_left);
    }];
    //距离
    [_distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImg.mas_top);
        make.right.mas_equalTo(contentView).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(_iconImg.mas_height).multipliedBy(0.25);
    }];
    //ID
    [_IDLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_distanceLbl.mas_bottom);
        make.right.mas_equalTo(_distanceLbl.mas_right);
        make.width.mas_equalTo(_distanceLbl.mas_width);
        make.height.mas_equalTo(_distanceLbl.mas_height);
    }];
    //时间段
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.top.mas_equalTo(_IDLbl.mas_bottom);
        make.height.mas_equalTo(_iconImg.mas_height).multipliedBy(0.25);
        make.right.mas_equalTo(_QRBtn.mas_left);
    }];
    //地址
    [_addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.top.mas_equalTo(_timeLbl.mas_bottom);
        make.height.mas_equalTo(_timeLbl.mas_height);
        make.right.mas_equalTo(_callBtn.mas_left);
    }];
    //二维码按钮
    [_QRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_IDLbl.mas_bottom);
        make.right.mas_equalTo(_distanceLbl.mas_right);
        make.height.mas_equalTo(_timeLbl.mas_height);
        make.width.mas_equalTo(40);
    }];
    //电话
    [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_QRBtn.mas_bottom);
        make.right.mas_equalTo(_distanceLbl.mas_right);
        make.height.mas_equalTo(_QRBtn.mas_height);
        make.width.mas_equalTo(_QRBtn.mas_width);
    }];
    
    [self layoutIfNeeded];
    [_iconImg setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
}

-(void)km_layoutSubviews{
    CGFloat distanceW         = [_distanceLbl.text widthForFont:_distanceLbl.font] + 3;
    CGFloat IDLblW            = [_IDLbl.text widthForFont:_IDLbl.font] + 3;
    [_distanceLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MAX(distanceW, IDLblW));
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMGroupBaseInfo class]]) {
        KMGroupBaseInfo *info = data;
        //号群图片
        [_iconImg setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(info.groupphoto ? info.groupphoto : @"")] placeholder:GetNormalPlaceholderImage];
        //号群名称
        [_nameLbl setText:info.groupname];
        //号群ID
        [_IDLbl setText:NSStringFormat(@"ID:%@",info.groupno)];
        //时间段
        [_timeLbl setText:info.timespan];
        //号群地址
        [_addressLbl setText:info.groupaddr];
        
        //计算距离
        CLLocation *location  = [[CLLocation alloc]initWithLatitude:[info.lat floatValue] longitude:[info.lng floatValue]];
        NSString * distance   = [KMLocationManager distanceWithTargetLocation:location];
        [_distanceLbl setText:distance];
    }
}

-(void)km_bindRacEvent{
    @weakify(self)
    [[_QRBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.QRSubject sendNext:nil];
    }];
    
    [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.telSubject sendNext:nil];
    }];
}
#pragma mark - Lazy
-(RACSubject *)QRSubject{
    if (!_QRSubject) {
        _QRSubject            = [RACSubject subject];
    }
    return _QRSubject;
}
-(RACSubject *)telSubject{
    if (!_telSubject) {
        _telSubject           = [RACSubject subject];
    }
    return _telSubject;
}
@end
