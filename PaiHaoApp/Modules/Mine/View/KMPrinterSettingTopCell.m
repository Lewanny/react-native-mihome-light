//
//  KMPrinterSettingTopCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPrinterSettingTopCell.h"

@interface KMPrinterSettingTopCell ()

@property (nonatomic, strong) UIImageView * iconImg;

@property (nonatomic, strong) UILabel * nameLbel;
/** 连接 */
@property (nonatomic, strong) UIButton * connectBtn;
/** 断开连接 */
@property (nonatomic, strong) UIButton * disConnectBtn;

@end

@implementation KMPrinterSettingTopCell
#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    _iconImg                                               = [UIImageView new];
    _iconImg.image                                         = IMAGE_NAMED(@"dayinji");
    [self.contentView addSubview:_iconImg];
    
    _nameLbel                                              = [UILabel new];
    [_nameLbel setFont:kFont32];
    [_nameLbel setTextColor:kFontColorDark];
    [_nameLbel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_nameLbel];
    
    _connectBtn                                            = [UIButton buttonWithType:UIButtonTypeCustom];
    [_connectBtn.titleLabel setFont:kFont24];
    [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_connectBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_connectBtn];
    
    _disConnectBtn                                         = [UIButton buttonWithType:UIButtonTypeCustom];
    [_disConnectBtn.titleLabel setFont:kFont24];
    [_disConnectBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_disConnectBtn setTitle:@"断开连接" forState:UIControlStateNormal];
    @weakify(self)
    [[_disConnectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.disConnectSubject sendNext:nil];
    }];
    [self.contentView addSubview:_disConnectBtn];
}

-(void)km_setupSubviewsLayout{
    UIView *content                                        = self.contentView;
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AdaptedHeight(24));
        make.centerX.mas_equalTo(content.mas_centerX);
        make.width.mas_equalTo(AdaptedWidth(90));
        make.height.mas_equalTo(AdaptedHeight(90));
    }];
    [_nameLbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImg.mas_bottom).offset(AdaptedHeight(20));
        make.left.right.mas_equalTo(content);
        make.height.mas_equalTo([@"123" heightForFont:_nameLbel.font width:CGFLOAT_MAX]);
    }];
    
    [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLbel.mas_bottom).offset(AdaptedHeight(20));
        make.width.mas_equalTo(AdaptedWidth(140));
        make.height.mas_equalTo(AdaptedHeight(40));
        make.right.mas_equalTo(content.mas_centerX).offset(AdaptedWidth(-22));
    }];
    [_disConnectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_connectBtn.mas_top);
        make.width.mas_equalTo(AdaptedWidth(140));
        make.height.mas_equalTo(AdaptedHeight(40));
        make.left.mas_equalTo(content.mas_centerX).offset(AdaptedWidth(22));
        make.bottom.mas_equalTo(content).offset(AdaptedHeight(-20)).priorityHigh();
    }];
    
    [_connectBtn layoutIfNeeded];
    [_connectBtn setRoundedCorners:UIRectCornerAllCorners radius:_connectBtn.height/2.0];
    [_disConnectBtn layoutIfNeeded];
    [_disConnectBtn cornerRadius:_disConnectBtn.height/2.0 strokeSize:0.5 color:kFontColorLightGray];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[RACTuple class]]) {
        RACTuple *t                                        = data;
        RACTupleUnpack(NSString * name, NSString * status) = t;
        [_nameLbel setText:name];
        [_connectBtn setTitle:status forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy -
-(RACSubject *)disConnectSubject{
    if (!_disConnectSubject) {
        _disConnectSubject                                 = [RACSubject subject];
    }
    return _disConnectSubject;
}
@end
