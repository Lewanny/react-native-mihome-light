//
//  KMPlatformMsgCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPlatformMsgCell.h"

#import "KMPlatformMsgModel.h"

@interface KMPlatformMsgCell ()

/** 头像 */
@property (nonatomic, strong) UIImageView * headerImg;
/** 名称 */
@property (nonatomic, strong) UILabel * nameLbl;
/** 时间 */
@property (nonatomic, strong) UILabel * timeLbl;
/** 标题 */
@property (nonatomic, strong) UILabel * titleLbl;
/** 消息背景 */
@property (nonatomic, strong) UIView * messageBG;
/** 消息图片 */
@property (nonatomic, strong) UIImageView * msgIcon;
/** 消息内容 */
@property (nonatomic, strong) UILabel * msgContent;
/** 阅读数 */
@property (nonatomic, strong) UILabel * readLbl;
/** 分割线 */
@property (nonatomic, strong) UIView * separatorLine;
/** 点赞按钮 */
@property (nonatomic, strong) UIButton * zanBtn;
/** 评论按钮 */
@property (nonatomic, strong) UIButton * commentBtn;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton * closeBtn;
@end

@implementation KMPlatformMsgCell

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

    //标题
    _titleLbl                  = [UILabel new];
    [_titleLbl setFont:kFont28];
    [_titleLbl setTextColor:kFontColorDark];
    [_titleLbl setNumberOfLines:0];
    [content addSubview:_titleLbl];

    //消息背景
    _messageBG                 = [UIView new];
    [_messageBG setBackgroundColor:kBackgroundColor];
    [content addSubview:_messageBG];

    //消息图片
    _msgIcon                   = [UIImageView new];
    [_messageBG addSubview:_msgIcon];

    //消息内容
    _msgContent                = [UILabel new];
    [_msgContent setFont:kFont24];
    [_msgContent setTextColor:kFontColorGray];
    [_msgContent setNumberOfLines: 0];
    [_messageBG addSubview:_msgContent];

    //阅读数
    _readLbl                   = [UILabel new];
    [_readLbl setFont:kFont22];
    [_readLbl setTextColor:kFontColorGray];
    [content addSubview:_readLbl];

    //分割线
    _separatorLine             = [UIView new];
    [_separatorLine setBackgroundColor:kFontColorLightGray];
    [content addSubview:_separatorLine];

    //点赞按钮
    _zanBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zanBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_zanBtn setImage:IMAGE_NAMED(@"tuijl(1)") forState:UIControlStateNormal];
    [_zanBtn.titleLabel setFont:kFont22];
    @weakify(self)
    [[_zanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.zanSubject sendNext:nil];
    }];
    [content addSubview:_zanBtn];

    //评论按钮
    _commentBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_commentBtn setImage:[IMAGE_NAMED(@"pinglun") imageByResizeToSize:CGSizeMake(AdaptedWidth(30), AdaptedHeight(30))] forState:UIControlStateNormal];
    [_commentBtn.titleLabel setFont:kFont22];
    //禁止点击
    [_commentBtn setUserInteractionEnabled:NO];
    [[_commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.commentSubject sendNext:nil];
    }];
    [content addSubview:_commentBtn];

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
        make.height.mas_equalTo(AdaptedHeight(80)).priorityHigh();
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
    //标题
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(_headerImg.mas_bottom).offset(AdaptedHeight(27)).priorityHigh();
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
    }];
    //消息背景
    [_messageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(_titleLbl.mas_bottom).offset(AdaptedHeight(24));
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(AdaptedHeight(152)).priorityHigh();
    }];
    //消息图片
    [_msgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_messageBG).offset(AdaptedHeight(5));
        make.left.mas_equalTo(_messageBG).offset(AdaptedWidth(5));
        make.width.mas_equalTo(AdaptedWidth(140));
        make.height.mas_equalTo(AdaptedHeight(140));
    }];
    //消息内容
    [_msgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_msgIcon.mas_top);
        make.right.mas_equalTo(_messageBG).offset(AdaptedWidth(-10));
        make.left.mas_equalTo(_msgIcon.mas_right).offset(AdaptedWidth(20));
        make.bottom.mas_lessThanOrEqualTo(_msgIcon.mas_bottom);
    }];
    //阅读数
    [_readLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.right.mas_equalTo(content);
        make.height.mas_equalTo(AdaptedHeight(66)).priorityHigh();
        make.top.mas_equalTo(_messageBG.mas_bottom);
    }];
    //分割线
    [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(content);
        make.top.mas_equalTo(_readLbl.mas_bottom);
        make.height.mas_equalTo(0.5).priorityHigh();
    }];
    //点赞按钮 评论按钮 关闭
    [@[_zanBtn, _commentBtn, _closeBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[_zanBtn, _commentBtn, _closeBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_separatorLine.mas_bottom);
        make.height.mas_equalTo(AdaptedHeight(44)).priorityHigh();
    }];
    [_zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(content);
    }];
    [_msgIcon layoutIfNeeded];
    [_msgIcon setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];

    [_messageBG layoutIfNeeded];
    [_messageBG cornerRadius:0 strokeSize:0.5 color:kFontColorLightGray];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMPlatformMsgModel class]]) {
    KMPlatformMsgModel *pModel = data;
        [_headerImg setImage:IMAGE_NAMED(@"tongzhi")];
        [_nameLbl setText:pModel.publisher];
        [_timeLbl setText:pModel.releaseTime];
        [_titleLbl setText:pModel.title];
        [_msgIcon setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(pModel.thumbnail)] placeholder:GetNormalPlaceholderImage];
        [_msgContent setText:pModel.content];
        [_zanBtn setTitle:NSStringFormat(@"%ld",pModel.praise) forState:UIControlStateNormal];
        [_zanBtn jk_setImagePosition:0 spacing:10];
        [_commentBtn setTitle:NSStringFormat(@"%ld",pModel.commentCount) forState:UIControlStateNormal];
        [_commentBtn jk_setImagePosition:0 spacing:10];

        [_readLbl setText:NSStringFormat(@"%ld阅读",pModel.totalReading)];
    }
}
#pragma mark - Lazy -
-(RACSubject *)zanSubject{
    if (!_zanSubject) {
    _zanSubject                = [RACSubject subject];
    }
    return _zanSubject;
}
-(RACSubject *)commentSubject{
    if (!_commentSubject) {
    _commentSubject            = [RACSubject subject];
    }
    return _commentSubject;
}
-(RACSubject *)closeSuject{
    if (!_closeSuject) {
    _closeSuject               = [RACSubject subject];
    }
    return _closeSuject;
}
@end
