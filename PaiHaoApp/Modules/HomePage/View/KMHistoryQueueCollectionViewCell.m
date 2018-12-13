//
//  KMHistoryQueueCollectionViewCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHistoryQueueCollectionViewCell.h"
#import "KMHistoryQueueModel.h"
@interface KMHistoryQueueCollectionViewCell ()
/** 排队状态 */
@property (nonatomic, assign) KM_QueueState qeueState;
@end

@implementation KMHistoryQueueCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - BaseViewInterface

-(void)km_addSubviews{
    _nameLbl.font                   = kFont32;
    _nameLbl.textColor              = kFontColorDark;

    _idLabel.font                   = kFont28;
    _idLabel.textColor              = kMainThemeColor;

    _timeLbl.font                   = kFont26;
    _timeLbl.textColor              = kFontColorGray;

    _callLbl.font                   = kFont26;
    _callLbl.textColor              = kFontColorGray;

    [_evaluateBtn setTitleColor: kMainThemeColor forState:UIControlStateNormal];
    [_evaluateBtn setImage:IMAGE_NAMED(@"pjqu") forState:UIControlStateNormal];

    [_evaluateBtn setTitleColor:kFontColorLightGray forState:UIControlStateDisabled];
    [_evaluateBtn setImage:IMAGE_NAMED(@"pjyi") forState:UIControlStateDisabled];

    _evaluateBtn.titleLabel.font    = kFont24;

    [_topGrayLine setBackgroundColor:kFontColorLightGray];
}

-(void)km_layoutSubviews{
    _iconTop.constant               = AdaptedHeight(24);
    _iconBottom.constant            = AdaptedHeight(24);
    _iconLeft.constant              = AdaptedWidth(24);

    _labelLeft.constant             = AdaptedWidth(24);
    _labelRight.constant            = AdaptedWidth(24);

    _callLblRight.constant          = AdaptedWidth(24);

    _evaluateBtnWidth.constant      = AdaptedWidth(140);
    _evaluateBtnHeight.constant     = AdaptedHeight(54);

    [_evaluateBtn jk_setImagePosition:LXMImagePositionLeft spacing:AdaptedWidth(10)];
    [_evaluateBtn setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
    if (_evaluateBtn.enabled) {
        [_evaluateBtn cornerRadius:AdaptedWidth(8) strokeSize:AdaptedWidth(1) color:kMainThemeColor];
    }else{
        [_evaluateBtn cornerRadius:AdaptedWidth(8) strokeSize:AdaptedWidth(1) color:kFontColorLightGray];
    }
    [_iconImg setRoundedCorners:UIRectCornerAllCorners radius:5];
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
    enable                          = NO;
    title                           = @"已评价";
        }
            break;
        case KM_QueueStateWaitProcessed:
        case KM_QueueStateDismiss:{
    enable                          = YES;
    title                           = @"去评价";
        }
            break;
        case KM_QueueStateMiss:{
    enable                          = NO;
    title                           = @"已过号";
        }
            break;
        case KM_QueueStateQuit:{
    enable                          = NO;
    title                           = @"已退出";
        }
            break;
        case KM_QueueStateAlreadyCall:{
    enable                          = NO;
    title                           = @"已呼叫";
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
@end
