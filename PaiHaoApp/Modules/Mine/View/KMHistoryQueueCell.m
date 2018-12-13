//
//  KMHistoryQueueCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHistoryQueueCell.h"
#import "KMHistoryQueueModel.h"

@interface KMHistoryQueueCell ()

/** 排队状态 */
@property (nonatomic, assign) KM_QueueState qeueState;

/** 队列图片 */
@property (strong, nonatomic)  UIImageView *iconImg;
/** 队列名称 */
@property (strong, nonatomic)  UILabel *nameLbl;
/** 队列ID */
@property (strong, nonatomic)  UILabel *idLabel;
/** 办理时间 */
@property (strong, nonatomic)  UILabel *timeLbl;
/** 呼叫员 */
@property (strong, nonatomic)  UILabel *callLbl;
/** 评价按钮 */
@property (strong, nonatomic)  UIButton *evaluateBtn;
/** 底部分割线 */
@property (strong, nonatomic)  UIView *bottomGrayLine;
/** 二维码按钮 */
@property (nonatomic, strong) UIButton * QRBtn;

@end

@implementation KMHistoryQueueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - BaseViewInterface

-(void)km_addSubviews{
    
    UIView *content                 = self.contentView;
    
    _iconImg                        = [UIImageView new];
    [content addSubview:_iconImg];
    
    _nameLbl                        = [UILabel new];
    _nameLbl.font                   = kFont32;
    _nameLbl.textColor              = kFontColorDark;
    _nameLbl.numberOfLines          = 0;
    [content addSubview:_nameLbl];
    
    _idLabel                        = [UILabel new];
    _idLabel.font                   = kFont28;
    _idLabel.textColor              = kMainThemeColor;
    [_idLabel setTextAlignment:NSTextAlignmentRight];
    [content addSubview:_idLabel];
    
    _timeLbl                        = [UILabel new];
    _timeLbl.font                   = kFont26;
    _timeLbl.textColor              = kFontColorGray;
    [content addSubview:_timeLbl];
    
    _callLbl                        = [UILabel new];
    _callLbl.font                   = kFont26;
    _callLbl.textColor              = kFontColorGray;
    [content addSubview:_callLbl];
    
    _evaluateBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [_evaluateBtn setTitleColor: kMainThemeColor forState:UIControlStateNormal];
    [_evaluateBtn setImage:IMAGE_NAMED(@"pjqu") forState:UIControlStateNormal];
    [_evaluateBtn setTitleColor:kFontColorLightGray forState:UIControlStateDisabled];
    [_evaluateBtn setImage:IMAGE_NAMED(@"pjyi") forState:UIControlStateDisabled];
    [_evaluateBtn.titleLabel setFont:kFont24];
    @weakify(self)
    [_evaluateBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.evaluateSubject sendNext:nil];
    }];
    [content addSubview:_evaluateBtn];
    
    _bottomGrayLine                 = [UIView new];
    [_bottomGrayLine setBackgroundColor:kFontColorLightGray];
    [content addSubview:_bottomGrayLine];
    
    _QRBtn                          = [UIButton buttonWithType:UIButtonTypeCustom];
    [_QRBtn setImage:IMAGE_NAMED(@"erweima") forState:UIControlStateNormal];
    [_QRBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [_QRBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.QRSubject sendNext:nil];
    }];
    [content addSubview:_QRBtn];
}

-(void)km_setupSubviewsLayout{
    UIView *content                 = self.contentView;
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AdaptedHeight(24));
        make.left.mas_equalTo(AdaptedWidth(24));
        make.width.mas_equalTo(AdaptedWidth(196));
        make.height.mas_equalTo(AdaptedHeight(196));
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImg.mas_top);
        make.left.mas_equalTo(_iconImg.mas_right).offset(AdaptedWidth(24));
        make.height.mas_lessThanOrEqualTo(_iconImg.mas_height).multipliedBy(0.5);
        make.right.mas_equalTo(_idLabel.mas_left).offset(-5);
    }];
    
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImg.mas_top).offset(AdaptedHeight(196)/4.0);
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(_iconImg.mas_height).multipliedBy(0.25);
    }];
    
    [_QRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_idLabel.mas_bottom);
        make.right.mas_equalTo(_idLabel.mas_right);
        make.height.mas_equalTo(_iconImg.mas_height).multipliedBy(0.25);
        make.width.mas_equalTo(AdaptedWidth(80));
    }];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_idLabel.mas_bottom);
        make.right.mas_equalTo(_QRBtn.mas_left).offset(-5);
        make.left.mas_equalTo(_nameLbl.mas_left);
        make.height.mas_equalTo(_iconImg.mas_height).multipliedBy(0.25);
    }];
    
    [_callLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLbl.mas_bottom);
        make.left.mas_equalTo(_timeLbl.mas_left);
        make.right.mas_equalTo(_evaluateBtn.mas_left);
        make.height.mas_equalTo(_iconImg.mas_height).multipliedBy(0.25);
    }];
    
    [_evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_QRBtn.mas_bottom);
        make.right.mas_equalTo(_QRBtn.mas_right);
        make.height.mas_equalTo(_QRBtn.mas_height);
        make.width.mas_equalTo(AdaptedWidth(140));
    }];
    
    [_bottomGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(content);
        make.height.mas_equalTo(0.5);
    }];
    
    [_evaluateBtn layoutIfNeeded];
    [_evaluateBtn jk_setImagePosition:LXMImagePositionLeft spacing:AdaptedWidth(10)];
    [_evaluateBtn setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
    if (_evaluateBtn.enabled) {
        [_evaluateBtn cornerRadius:AdaptedWidth(8) strokeSize:AdaptedWidth(1) color:kMainThemeColor];
    }else{
        [_evaluateBtn cornerRadius:AdaptedWidth(8) strokeSize:AdaptedWidth(1) color:kFontColorLightGray];
    }
    [_iconImg layoutIfNeeded];
    [_iconImg setRoundedCorners:UIRectCornerAllCorners radius:5];
}

-(void)km_layoutSubviews{
    CGFloat idLblW                  = [_idLabel.text widthForFont:_idLabel.font] + 3;
    [_idLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(idLblW);
    }];
}

-(void)km_bindData:(id)data{
    KMHistoryQueueModel *queue      = data;
    _qeueState                      = [queue.queueState integerValue];
    [_iconImg setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(queue.groupImg ? queue.groupImg : @"")] placeholder:GetNormalPlaceholderImage];
    [_nameLbl setText:queue.groupName];
    [_idLabel setText:NSStringFormat(@"ID:%@",queue.groupNo)];
    [_timeLbl setText:NSStringFormat(@"办理时间: %@",queue.processTime)];
    
    NSString *callStr               = NSStringFormat(@"呼叫员: %@",queue.callClerk);
    NSRange callRange               = [callStr rangeOfString:queue.callClerk options:NSBackwardsSearch];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:callStr];
    [attr setFont:kFont32 range:callRange];
    [attr setColor:kAppRedColor range:callRange];
    [_callLbl setAttributedText:attr];
    
    _qeueState                      = [queue.queueState integerValue];
    [self configEvaluateBtnWithQueueState:_qeueState];
}

-(void)configEvaluateBtnWithQueueState:(KM_QueueState)queueState{
    
    NSString *title                 = @"";
    BOOL enable                     = NO;
    
    switch (queueState) {
        case KM_QueueStateAlreadyEvaluate:{
            enable                  = NO;
            title                   = @"已评价";
        }
            break;
        case KM_QueueStateWaitProcessed:
        case KM_QueueStateDismiss:{
            enable                  = YES;
            title                   = @"去评价";
        }
            break;
        case KM_QueueStateMiss:{
            enable                  = NO;
            title                   = @"已过号";
        }
            break;
        case KM_QueueStateQuit:{
            enable                  = NO;
            title                   = @"已退出";
        }
            break;
        case KM_QueueStateAlreadyCall:{
            enable                  = NO;
            title                   = @"已呼叫";
        }
            break;
        default:
            break;
    }
    
    [_evaluateBtn setTitle:title forState:UIControlStateNormal];
    [_evaluateBtn setTitle:title forState:UIControlStateDisabled];
    _evaluateBtn.enabled            = enable;
    
}
+(CGFloat)cellHeight{
    return AdaptedHeight(244);
}

#pragma mark - Lazy -
-(RACSubject *)QRSubject{
    if (!_QRSubject) {
        _QRSubject                  = [RACSubject subject];
    }
    return _QRSubject;
}
-(RACSubject *)evaluateSubject{
    if (!_evaluateSubject) {
        _evaluateSubject            = [RACSubject subject];
    }
    return _evaluateSubject;
}
@end
