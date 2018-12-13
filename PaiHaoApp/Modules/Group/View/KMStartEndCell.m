//
//  KMStartEndCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMStartEndCell.h"

@interface KMStartEndCell ()

@property (nonatomic, strong) UIView * starBG;

@property (nonatomic, strong) UIView * endBG;

@property (nonatomic, strong) UIView * verticalLine;

@property (nonatomic, strong) UILabel * startTitleLbl;

@property (nonatomic, strong) UILabel * startContentLbl;

@property (nonatomic, strong) UILabel * endTitleLbl;

@property (nonatomic, strong) UILabel * endContentLbl;

@end

@implementation KMStartEndCell

+(CGFloat)cellHeight{
   return AdaptedHeight(140);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    UIView *content                                    = self.contentView;
    content.backgroundColor                            = [UIColor whiteColor];

    _starBG                                            = [UIView new];
    _starBG.userInteractionEnabled                     = YES;
    @weakify(self)
    [_starBG addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self)
        self.startAction ? self.startAction() : nil;
    }];
    [content addSubview:_starBG];

    _endBG                                             = [UIView new];
    _endBG.userInteractionEnabled                      = YES;
    [_endBG addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self)
        self.endAction ? self.endAction() : nil;
    }];
    [content addSubview:_endBG];

    _verticalLine                                      = [UIView new];
    _verticalLine.backgroundColor                      = kFontColorLightGray;
    [content addSubview:_verticalLine];

    _startTitleLbl                                     = [UILabel new];
    _startTitleLbl.font                                = kFont28;
    _startTitleLbl.textColor                           = kFontColorGray;
    _startTitleLbl.textAlignment                       = NSTextAlignmentCenter;
    [_starBG addSubview:_startTitleLbl];

    _endTitleLbl                                       = [UILabel new];
    _endTitleLbl.font                                  = kFont28;
    _endTitleLbl.textColor                             = kFontColorGray;
    _endTitleLbl.textAlignment                         = NSTextAlignmentCenter;
    [_endBG addSubview:_endTitleLbl];

    _startContentLbl                                   = [UILabel new];
    _startContentLbl.font                              = kFont36;
    _startContentLbl.textColor                         = kFontColorDark;
    _startContentLbl.textAlignment                     = NSTextAlignmentCenter;
    [_starBG addSubview:_startContentLbl];

    _endContentLbl                                     = [UILabel new];
    _endContentLbl.font                                = kFont36;
    _endContentLbl.textColor                           = kFontColorDark;
    _endContentLbl.textAlignment                       = NSTextAlignmentCenter;
    [_endBG addSubview:_endContentLbl];
}
-(void)km_setupSubviewsLayout{
    UIView *content                                    = self.contentView;

    [_starBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(content);
        make.right.mas_equalTo(_verticalLine.mas_left);
    }];
    [_endBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(content);
        make.left.mas_equalTo(_verticalLine.mas_right);
    }];
    [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_starBG.mas_right);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(AdaptedHeight(76));
        make.centerY.mas_equalTo(content.mas_centerY);
        make.centerX.mas_equalTo(content.mas_centerX);
    }];
    [_startTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_starBG).offset(AdaptedWidth(60));
        make.right.mas_equalTo(_starBG).offset(AdaptedWidth(-60));
        make.top.mas_equalTo(_starBG).offset(AdaptedHeight(24));
        make.height.mas_equalTo(AdaptedHeight(40));
    }];
    [_startContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_starBG);
        make.right.mas_equalTo(_starBG);
        make.top.mas_equalTo(_startTitleLbl.mas_bottom).offset(AdaptedHeight(10));
        make.bottom.mas_equalTo(_starBG).offset(AdaptedHeight(-24));
    }];
    [_endTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_endBG).offset(AdaptedWidth(60));
        make.right.mas_equalTo(_endBG).offset(AdaptedWidth(-60));
        make.top.mas_equalTo(_endBG).offset(AdaptedHeight(24));
        make.height.mas_equalTo(AdaptedHeight(40));
    }];
    [_endContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_endBG);
        make.right.mas_equalTo(_endBG);
        make.top.mas_equalTo(_endTitleLbl.mas_bottom).offset(AdaptedHeight(10));
        make.bottom.mas_equalTo(_endBG).offset(AdaptedHeight(-24));
    }];
}

-(void)km_bindData:(id)data{
    NSString *timeSlot                                 = @"";
    switch (_timeSlot) {
        case KMTimeSlotNone:
    timeSlot                                           = @"";
            [_startTitleLbl setTextAlignment:NSTextAlignmentCenter];
            break;
        case KMTimeSlotAM:
    timeSlot                                           = @"上午:";
            [_startTitleLbl setTextAlignment:NSTextAlignmentLeft];
            break;
        case KMTimeSlotPM:
    timeSlot                                           = @"下午:";
            [_startTitleLbl setTextAlignment:NSTextAlignmentLeft];
            break;
        case KMTimeSlotNight:
    timeSlot                                           = @"晚上:";
            [_startTitleLbl setTextAlignment:NSTextAlignmentLeft];
            break;
        default:
            break;
    }

    RACTupleUnpack(NSDate *startDate, NSDate *endDate) = data;
    NSString *startTitle                               = @"开始日期";
    NSString *endTitle                                 = @"结束日期";
    switch (_timeStyle) {
        case TimeStyleDay:{
    startTitle                                         = @"开始日期";
    endTitle                                           = @"结束日期";
            [_startContentLbl setText:[startDate stringWithFormat:@"yyyy-MM-dd"]];
            [_endContentLbl setText:[endDate stringWithFormat:@"yyyy-MM-dd"]];
        }
            break;
        case TimeStyleTime:{
    startTitle                                         = @"开始时间";
    endTitle                                           = @"结束时间";
            [_startContentLbl setText:[startDate stringWithFormat:@"HH:mm"]];
            [_endContentLbl setText:[endDate stringWithFormat:@"HH:mm"]];
        }
            break;
        default:
            break;
    }

    if (timeSlot.length) {
    NSMutableAttributedString *attr                    = [KMTool attributedFullStr:[timeSlot stringByAppendingString:startTitle] FullStrAttributes:@{NSFontAttributeName : _startTitleLbl.font, NSForegroundColorAttributeName : kFontColorGray} RangeStr:timeSlot RangeStrAttributes:@{NSForegroundColorAttributeName : kMainThemeColor} Options:NSCaseInsensitiveSearch];
        [_startTitleLbl setAttributedText:attr];
    }else{
        [_startTitleLbl setText:startTitle];
    }

    [_endTitleLbl setText:endTitle];
}

@end
