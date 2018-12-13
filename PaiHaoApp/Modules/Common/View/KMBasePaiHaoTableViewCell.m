//
//  KMBasePaiHaoTableViewCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBasePaiHaoTableViewCell.h"

@interface KMBasePaiHaoTableViewCell ()

@end

@implementation KMBasePaiHaoTableViewCell

-(NSAttributedString *)setupStatusWithWaitNum:(NSInteger)waitNum waitTime:(NSInteger)waitTime{
    NSString *waitNumStr            = NSStringFormat(@"%ld",waitNum);
    NSString *waitTimeStr           = NSStringFormat(@"%ld",waitTime);
    NSString *str                   = NSStringFormat(@"前面人数%@人 (约%@分钟)",waitNumStr,waitTimeStr);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];

    [attr setFont:kFont26];
    [attr setColor:kFontColorGray];

    [attr setFont:kFont32 range:[str rangeOfString:waitNumStr]];
    [attr setColor:kAppRedColor range:[str rangeOfString:waitNumStr]];

    [attr setFont:kFont32 range:[str rangeOfString:waitTimeStr options:NSBackwardsSearch]];
    [attr setColor:kAppRedColor range:[str rangeOfString:waitTimeStr options:NSBackwardsSearch]];

    return attr;
}


+(CGFloat)cellHeight{
    return AdaptedHeight(244);
}

#pragma mark - BaseViewInterface

-(void)km_addSubviews{
    UIView *contentView             = self.contentView;
    [contentView setBackgroundColor:[UIColor whiteColor]];

    _iconImageView                  = [UIImageView new];
    [contentView addSubview:_iconImageView];

    _nameLabel                      = [UILabel new];
    [contentView addSubview:_nameLabel];

    _IDLabel                        = [UILabel new];
    [contentView addSubview:_IDLabel];

    _distanceLabel                  = [UILabel new];
    [contentView addSubview:_distanceLabel];

    _timeLabel                      = [UILabel new];
    [contentView addSubview:_timeLabel];

    _statusLabel                    = [UILabel new];
    [contentView addSubview:_statusLabel];

    _QRBtn                          = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:_QRBtn];

    _mapBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:_mapBtn];

    [_nameLabel setTextColor:kFontColorBlack];
    [_nameLabel setFont:kFont32];
    _nameLabel.numberOfLines        = 0;

    [_IDLabel setTextColor:kMainThemeColor];
    [_IDLabel setTextAlignment:NSTextAlignmentRight];
    [_IDLabel setFont:kFont26];

    [_distanceLabel setTextColor:kFontColorGray];
    [_distanceLabel setTextAlignment:NSTextAlignmentRight];
    [_distanceLabel setFont:kFont26];

    [_timeLabel setTextColor:kFontColorGray];
    [_timeLabel setFont:kFont26];

    [_QRBtn setImage:IMAGE_NAMED(@"erweima") forState:UIControlStateNormal];
    [_QRBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [_mapBtn setImage:IMAGE_NAMED(@"dingwei1") forState:UIControlStateNormal];
    [_mapBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [_statusLabel setFont:kFont26];
    [_statusLabel setTextColor:kFontColorGray];
    [_statusLabel setAdjustsFontSizeToFitWidth:YES];

    [_timeLabel setAdjustsFontSizeToFitWidth:YES];
}

-(void)km_setupSubviewsLayout{

    UIView *contentView             = self.contentView;

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(AdaptedHeight(24));
        make.left.mas_equalTo(contentView).offset(AdaptedWidth(24));
        make.width.mas_equalTo(AdaptedWidth(196));
        make.height.mas_equalTo(AdaptedHeight(196));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_top);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(AdaptedWidth(20));
        make.right.mas_equalTo(_distanceLabel.mas_left).offset(-5);
        make.height.mas_lessThanOrEqualTo(_iconImageView.mas_height).multipliedBy(0.5);
    }];

    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_top);
        make.right.mas_equalTo(contentView).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(_iconImageView.mas_height).multipliedBy(0.25);
    }];

    [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_distanceLabel.mas_bottom);
        make.left.mas_equalTo(_distanceLabel.mas_left);
        make.right.mas_equalTo(_distanceLabel.mas_right);
        make.height.mas_equalTo(_iconImageView.mas_height).multipliedBy(0.25);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_IDLabel.mas_bottom);
        make.right.mas_equalTo(_QRBtn.mas_left).offset(-5);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.height.mas_equalTo(_iconImageView.mas_height).multipliedBy(0.25);
    }];

    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_bottom);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(_timeLabel.mas_right);
        make.height.mas_equalTo(_iconImageView.mas_height).multipliedBy(0.25);
    }];


    [_QRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_IDLabel.mas_bottom);
        make.right.mas_equalTo(_distanceLabel.mas_right);
        make.height.mas_equalTo(_iconImageView.mas_height).multipliedBy(0.25);
        make.width.mas_equalTo(AdaptedWidth(60));
    }];
    [_mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_QRBtn.mas_bottom);
        make.right.mas_equalTo(_QRBtn.mas_right);
        make.height.mas_equalTo(_QRBtn.mas_height);
        make.width.mas_equalTo(_QRBtn.mas_width);
    }];

    [_iconImageView layoutIfNeeded];
    [_iconImageView setRoundedCorners:UIRectCornerAllCorners radius:5];
}

-(void)km_layoutSubviews{
    CGFloat distanceW               = [_distanceLabel.text widthForFont:_distanceLabel.font] + 3;
    CGFloat IDLblW                  = [_IDLabel.text widthForFont:_IDLabel.font] + 3;
    [_distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MAX(distanceW, IDLblW));
    }];
}

-(void)km_bindRacEvent{
    @weakify(self)
    [[_QRBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.QRSubject sendNext:nil];
    }];
    [[_mapBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.mapSubject sendNext:nil];
    }];
}

-(void)km_bindData:(id)data{

    if ([data isKindOfClass:[KMGroupBriefModel class]]) {
    KMGroupBriefModel *model        = data;
        [_nameLabel setText:model.groupname];
        [_iconImageView setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(model.groupphoto ? model.groupphoto : @"")]
                               placeholder:GetNormalPlaceholderImage];
    CLLocation *location            = [[CLLocation alloc]initWithLatitude:model.lat longitude:model.lng];
    NSString * distance             = [KMLocationManager distanceWithTargetLocation:location];

        [_distanceLabel setText:distance];
        [_timeLabel setText:model.startwaittime];
        [_IDLabel setText:NSStringFormat(@"ID:%@",model.groupno)];
        [_statusLabel setAttributedText: [self setupStatusWithWaitNum:model.waitcount waitTime:model.waittime]];
    }else if ([data isKindOfClass:[KMQueueInfo class]]){
    KMQueueInfo *info               = data;
        [_nameLabel setText:info.groupname];
        [_iconImageView setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(info.groupphoto ? info.groupphoto : @"")]
                               placeholder:GetNormalPlaceholderImage];
    CLLocation *location            = [[CLLocation alloc]initWithLatitude:[info.lat floatValue] longitude:[info.lng floatValue]];
    NSString * distance             = [KMLocationManager distanceWithTargetLocation:location];

        [_distanceLabel setText:distance];
        [_IDLabel setText:NSStringFormat(@"ID:%@",info.groupno)];
        [_timeLabel setAttributedText: [self setupStatusWithWaitNum:info.waitcount waitTime:info.waittime]];
        [_statusLabel setText:NSStringFormat(@"我的号位%@号，当前办理%@号",info.currentno,info.currenthandle)];
    }
    else{
//        [_nameLabel setText:@"时代城四季椰子鸡"];
//        [_iconImageView setImage:[UIImage imageNamed:@"20搜索号群图片_03"]];
//        [_distanceLabel setText:@"1.9km"];
//        [_timeLabel setText:@"9:00-18:00"];
//        [_IDLabel setText:@"ID:9998"];
//       [_statusLabel setAttributedText:[self setupStatusWithWaitNum:888 waitTime:1234]];
    }
}

#pragma mark - Lazy
-(RACSubject *)QRSubject{
    if (!_QRSubject) {
    _QRSubject                      = [RACSubject subject];
    }
    return _QRSubject;
}
-(RACSubject *)mapSubject{
    if (!_mapSubject) {
    _mapSubject                     = [RACSubject subject];
    }
    return _mapSubject;
}
@end
