//
//  KMRemindMsgCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMRemindMsgCell.h"

#import "KMRemindMsgModel.h"

@interface KMRemindMsgCell ()
/** 显示日期 */
@property (nonatomic, strong) UILabel * dateLbl;

@property (nonatomic, strong) YYLabel * contentLbl;

@property (nonatomic, strong) UIButton * closeBtn;

@end

@implementation KMRemindMsgCell

#pragma mark - BaseViewInterface -

-(void)km_addSubviews{
    
    self.contentView.backgroundColor = kBackgroundColor;
    
    UIView *content = self.contentView;
    
    _dateLbl = [UILabel new];
    [_dateLbl setTextAlignment:NSTextAlignmentCenter];
    [_dateLbl setFont:kFont24];
    [_dateLbl setTextColor:kFontColorDarkGray];
    [content addSubview:_dateLbl];
    
    _contentLbl = [YYLabel new];
    [_contentLbl setBackgroundColor:[UIColor whiteColor]];
    [_contentLbl setFont:kFont28];
    [_contentLbl setTextColor:kFontColorDarkGray];
    [_contentLbl setNumberOfLines:0];
    [_contentLbl setPreferredMaxLayoutWidth:KScreenWidth - AdaptedWidth(24 * 2)];
    CGFloat w = AdaptedWidth(20);
    CGFloat h = AdaptedHeight(20);
    [_contentLbl setTextContainerInset:UIEdgeInsetsMake(h, w, h, w)];
    [content addSubview:_contentLbl];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[IMAGE_NAMED(@"chac") imageByResizeToSize:CGSizeMake(AdaptedWidth(30), AdaptedHeight(30))] forState:UIControlStateNormal];
    [_closeBtn setContentMode:UIViewContentModeRight];
    @weakify(self)
    [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.closeSubject sendNext:nil];
    }];
    [content addSubview:_closeBtn];
}

-(void)km_setupSubviewsLayout{
    UIView *content = self.contentView;
    
    [_dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content);
        make.top.mas_equalTo(content);
        make.right.mas_equalTo(content);
        make.height.mas_equalTo(AdaptedHeight(76));
    }];
    
    CGFloat h = [@"123" heightForFont:kFont32 width:CGFLOAT_MAX];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLbl.mas_top).offset(AdaptedHeight(15));
        make.right.mas_equalTo(_contentLbl.mas_right).offset(AdaptedWidth(-15));
        make.height.mas_equalTo(h);
        make.width.mas_equalTo(h);
    }];
    
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_dateLbl.mas_bottom);
        make.left.mas_equalTo(content).offset(AdaptedWidth(22));
        make.right.mas_equalTo(content).offset(AdaptedWidth(-22));
        make.height.mas_greaterThanOrEqualTo(30).priorityHigh();
        make.bottom.mas_equalTo(content);
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMRemindMsgModel class]]) {
        KMRemindMsgModel *rModel = data;
        NSDate *rDate = [NSDate dateWithString:rModel.CreateTime format:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [rDate stringWithFormat:@"yyyy-MM-dd"];
        [_dateLbl setText:dateStr];
        if (rModel.mode == 0) {
            //1
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"排号网提醒\n"];
            [attr setFont:kFont32];
            [attr setColor:kFontColorDark];
            
            //2
            NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"您参加的 \"%@\" 排队，",rModel.groupName)];
            [nameAttr setFont:kFont28];
            [nameAttr setColor:kFontColorDarkGray];
            [attr appendAttributedString:nameAttr];
            
            //3
            NSMutableAttributedString *numberAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"您的号位是：%@，",rModel.queueNo)];
            [numberAttr setFont:kFont28];
            [numberAttr setColor:kFontColorDarkGray];
            [numberAttr setColor:kMainThemeColor range:[numberAttr.string rangeOfString:rModel.queueNo options:NSBackwardsSearch]];
            [attr appendAttributedString:numberAttr];
            
            //4
            NSString *window = NSStringFormat(@"(%@)",rModel.windowName);
            NSMutableAttributedString *winAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"%@，",window)];
            [winAttr setFont:kFont28];
            [winAttr setColor:kFontColorDarkGray];
            [winAttr setColor:kMainThemeColor range:[winAttr.string rangeOfString:window]];
            [attr appendAttributedString:winAttr];
            
            //5
            NSMutableAttributedString *waitCountAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"前面人数 %ld 人，",rModel.waitCount)];
            [waitCountAttr setFont:kFont28];
            [waitCountAttr setColor:kFontColorDarkGray];
            [waitCountAttr setColor:kAppRedColor range:[waitCountAttr.string rangeOfString:NSStringFormat(@"%ld",rModel.waitCount) options:NSBackwardsSearch]];
            [attr appendAttributedString:waitCountAttr];
            
            //6
            NSMutableAttributedString *waitTimeAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"(预计 %ld 分钟)，",rModel.waitTime)];
            [waitTimeAttr setFont:kFont28];
            [waitTimeAttr setColor:kFontColorDarkGray];
            [waitTimeAttr setColor:kAppRedColor range:[waitTimeAttr.string rangeOfString:NSStringFormat(@"%ld",rModel.waitTime) options:NSBackwardsSearch]];
            [attr appendAttributedString:waitTimeAttr];
            
            //7
            NSString *time = [rDate stringWithFormat:@"HH:mm"];
            NSMutableAttributedString *timeAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"提醒时间 %@",time)];
            [timeAttr setFont:kFont28];
            [timeAttr setColor:kFontColorDarkGray];
            [timeAttr setColor:kAppRedColor range:[timeAttr.string rangeOfString:time options:NSBackwardsSearch]];
            [attr appendAttributedString:timeAttr];
            
            [_contentLbl setAttributedText:attr];
        }else{
            //1
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"解散提示\n"];
            [attr setFont:kFont32];
            [attr setColor:kFontColorDark];
            
            //2
            NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:@"很抱歉，您参与排号的队列"];
            [attr1 setFont:kFont28];
            [attr1 setColor:kFontColorDarkGray];
            [attr appendAttributedString:attr1];
            
            //3
            NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc]initWithString:rModel.groupName ? rModel.groupName : @""];
            [attr2 setFont:kFont28];
            [attr2 setColor:kMainThemeColor];
            [attr appendAttributedString:attr2];
            
            //4
            NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc]initWithString:@"已被管理员解散，给你造成不便，深表歉意，提醒时间"];
            [attr3 setFont:kFont28];
            [attr3 setColor:kFontColorDarkGray];
            [attr appendAttributedString:attr3];
            
            //5
            NSString *time = [rDate stringWithFormat:@"HH:mm"];
            NSMutableAttributedString *attr4 = [[NSMutableAttributedString alloc]initWithString:time ? time : @""];
            [attr4 setFont:kFont28];
            [attr4 setColor:kMainThemeColor];
            [attr appendAttributedString:attr4];
            
            [_contentLbl setAttributedText:attr];
        }
    }
}

#pragma mark - Lazy -
-(RACSubject *)closeSubject{
    if (!_closeSubject) {
        _closeSubject = [RACSubject subject];
    }
    return _closeSubject;
}

@end
