//
//  KMRecoveryMsgCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMRecoveryMsgCell.h"
#import "KMRecoveryMsgModel.h"
@interface KMRecoveryMsgCell ()
/** 头像 */
@property (nonatomic, strong) UIImageView * headerImg;
/** 名称 */
@property (nonatomic, strong) UILabel * nameLbl;
/** 时间 */
@property (nonatomic, strong) UILabel * timeLbl;
/** <#say something#> */
@property (nonatomic, strong) UILabel * hostTitleLbl;
/** 消息 */
@property (nonatomic, strong) YYLabel * messageLbl;
/** 分割线 */
@property (nonatomic, strong) UIView * separatorLine;
/** 更多 */
@property (nonatomic, strong) UIButton * moreBtn;
/** 关闭 */
@property (nonatomic, strong) UIButton * closeBtn;

@end

@implementation KMRecoveryMsgCell

+(CGFloat)cellHeight{
    return UITableViewAutomaticDimension;
}

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    UIView *content            = self.contentView;
    //头像
    _headerImg                 = [UIImageView new];
    [content addSubview:_headerImg];

    //名称
    _nameLbl                   = [UILabel new];
    [_nameLbl setFont:kFont26];
    [_nameLbl setTextColor:kFontColorDark];
    [content addSubview:_nameLbl];

    //时间
    _timeLbl                   = [UILabel new];
    [_timeLbl setFont:kFont26];
    [_timeLbl setTextColor:kFontColorGray];
    [content addSubview:_timeLbl];

    //hostTitle
    _hostTitleLbl              = [UILabel new];
    [_hostTitleLbl setFont:kFont28];
    [_hostTitleLbl setTextColor:kFontColorDark];
    [_hostTitleLbl setNumberOfLines:0];
    [content addSubview:_hostTitleLbl];

    //消息
    _messageLbl                = [YYLabel new];
    [_messageLbl setFont:kFont28];
    [_messageLbl setTextColor:kFontColorDark];
    [_messageLbl setBackgroundColor:kBackgroundColor];
    [_messageLbl setNumberOfLines:0];
    [_messageLbl setPreferredMaxLayoutWidth:AdaptedWidth(336)];
    [_messageLbl setTextVerticalAlignment:YYTextVerticalAlignmentTop];
    [content addSubview:_messageLbl];

    //分割线
    _separatorLine             = [UIView new];
    [_separatorLine setBackgroundColor:kFontColorLightGray];
    [content addSubview:_separatorLine];

    //更多
    _moreBtn                   = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setTitle:@"更多回复" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_moreBtn.titleLabel setFont:kFont22];
    @weakify(self)
    [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.moreSubject sendNext:nil];
    }];
    [content addSubview:_moreBtn];

    //关闭
    _closeBtn                  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[IMAGE_NAMED(@"chac") imageByResizeToSize:CGSizeMake(AdaptedWidth(30), AdaptedHeight(30))] forState:UIControlStateNormal];
    [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.closeSuject sendNext:nil];
    }];
    [content addSubview:_closeBtn];
    
    [_closeBtn setHidden:YES];
}
-(void)km_setupSubviewsLayout{
    UIView *content            = self.contentView;
    //头像
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(content).offset(AdaptedHeight(20));
        make.width.mas_equalTo(AdaptedWidth(80));
        make.height.mas_equalTo(AdaptedHeight(80));
    }];
    //名称
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerImg.mas_right).offset(AdaptedWidth(20));
        make.right.mas_equalTo(content);
        make.top.mas_equalTo(_headerImg.mas_top).offset(AdaptedHeight(8));
        make.bottom.mas_equalTo(_headerImg.mas_centerY);
    }];
    //时间
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.right.mas_equalTo(_nameLbl.mas_right);
        make.top.mas_equalTo(_headerImg.mas_centerY);
        make.bottom.mas_equalTo(_headerImg.mas_bottom).offset(AdaptedHeight(-8));
    }];
    //hostTitle
    [_hostTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerImg.mas_left);
        make.top.mas_equalTo(_headerImg.mas_bottom).offset(AdaptedHeight(27));
        make.right.mas_equalTo(_messageLbl.mas_left).offset(AdaptedWidth(-30));
        make.bottom.mas_lessThanOrEqualTo(_separatorLine.mas_top).offset(AdaptedHeight(-15));
    }];
    //消息
    [_messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(content).offset(AdaptedHeight(111));
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(AdaptedHeight(130)).priorityHigh();
        make.width.mas_equalTo(AdaptedWidth(336));
    }];
    //分割线
    [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_messageLbl.mas_bottom).offset(AdaptedHeight(15)).priorityHigh();
        make.left.right.mas_equalTo(content);
        make.height.mas_equalTo(0.5);
    }];
    //更多
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptedWidth(24));
        make.top.mas_equalTo(_separatorLine.mas_bottom).priorityHigh();
        make.width.mas_equalTo([_moreBtn.currentTitle widthForFont:_moreBtn.titleLabel.font] + 10);
        make.height.mas_equalTo(AdaptedHeight(44)).priorityHigh();
        make.bottom.mas_equalTo(content.mas_bottom);
    }];
    //关闭
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(content);
        make.top.mas_equalTo(_moreBtn.mas_top);
        make.bottom.mas_equalTo(_moreBtn.mas_bottom);
        make.width.mas_equalTo(content.mas_width).multipliedBy(1.0/3);
    }];

    [_messageLbl layoutIfNeeded];
    [_messageLbl cornerRadius:0 strokeSize:0.5 color:kFontColorLightGray];
    [_messageLbl setTextContainerInset:UIEdgeInsetsMake(AdaptedHeight(10), AdaptedWidth(10), AdaptedHeight(10), AdaptedWidth(10))];

    [_headerImg layoutIfNeeded];
    [_headerImg setRoundedCorners:UIRectCornerAllCorners radius:_headerImg.height/2.0];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMRecoveryMsgModel class]]) {
    KMRecoveryMsgModel *rModel = data;
        [_headerImg setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(rModel.headPortrait?rModel.headPortrait:@"")] placeholder:GetHeaderPlaceholderImage];
        [_nameLbl setText:rModel.replyPerson];
        [_timeLbl setText:rModel.releaseTime];
        [_hostTitleLbl setText:rModel.hostTitle];
        [_messageLbl setText:rModel.message];
    }
}

#pragma mark - Lazy -
-(RACSubject *)moreSubject{
    if (!_moreSubject) {
    _moreSubject               = [RACSubject subject];
    }
    return _moreSubject;
}

-(RACSubject *)closeSuject{
    if (!_closeSuject) {
    _closeSuject               = [RACSubject subject];
    }
    return _closeSuject;
}

@end
