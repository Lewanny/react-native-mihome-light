//
//  KMReplyMsgCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMReplyMsgCell.h"
#import "KMReplyMsgModel.h"
@interface KMReplyMsgCell ()

@property (nonatomic, strong) UIImageView * headerImg;

@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UILabel * timeLbl;

@property (nonatomic, strong) UILabel * contentLbl;

@end

@implementation KMReplyMsgCell
#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    UIView *content         = self.contentView;
    //头像
    _headerImg              = [UIImageView new];
    [content addSubview:_headerImg];

    //名称
    _nameLbl                = [UILabel new];
    [_nameLbl setFont:kFont26];
    [_nameLbl setTextColor:kFontColorDark];
    [content addSubview:_nameLbl];

    //时间
    _timeLbl                = [UILabel new];
    [_timeLbl setFont:kFont26];
    [_timeLbl setTextColor:kFontColorGray];
    [content addSubview:_timeLbl];

    //内容
    _contentLbl             = [UILabel new];
    [_contentLbl setFont:kFont26];
    [_contentLbl setTextColor:kFontColorDark];
    [_contentLbl setNumberOfLines:0];
    [content addSubview:_contentLbl];
}
-(void)km_setupSubviewsLayout{
    UIView *content         = self.contentView;
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
    //内容
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.top.mas_equalTo(_timeLbl.mas_bottom).offset(AdaptedHeight(24));
        make.height.mas_greaterThanOrEqualTo([@"高度" heightForFont:_contentLbl.font width:CGFLOAT_MAX]);
        make.bottom.mas_equalTo(content).offset(AdaptedHeight(-24)).priorityHigh();
    }];
    [_headerImg layoutIfNeeded];
    [_headerImg setRoundedCorners:UIRectCornerAllCorners radius:_headerImg.height/2.0];
}
-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMReplyMsgModel class]]) {
    KMReplyMsgModel *rModel = data;
        switch (_replyMsgType) {
            case KMReplyMsgTypeFeedback:{//反馈
                [_headerImg setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(rModel.headPortrait?rModel.headPortrait:@"")] placeholder:GetHeaderPlaceholderImage];
                [_timeLbl setText:rModel.submitTime];
                [_nameLbl setText:rModel.submitPerson];
                [_contentLbl setText:rModel.hostMessage];
            }
                break;
            case KMReplyMsgTypeReply:{//回复
                [_headerImg setImage:IMAGE_NAMED(@"tongzhi")];
                [_timeLbl setText:rModel.releaseTime];
                [_nameLbl setText:@"系统回复"];
                [_contentLbl setText:rModel.message];
            }
                break;
            default:
                break;
        }
    }
}
@end
