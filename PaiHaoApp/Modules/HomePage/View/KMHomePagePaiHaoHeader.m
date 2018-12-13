//
//  KMHomePagePaiHaoHeader.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHomePagePaiHaoHeader.h"

@implementation KMHomePagePaiHaoHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//初始设置
-(void)setupDefalut{
    BOOL ret                      = NO;
    for (UIButton *btn in @[_recommendBtn, _mineBtn, _historyBtn]) {
        if (btn.selected) {
    ret                           = YES;
            break;
        }
    }

    //如果按钮一个都没被选中
    if (!ret) {
        //判断登录
//        if (KMUserDefault.isLogin) {
//            [self btnClick:_mineBtn];
//        }else{
//            [self btnClick:_recommendBtn];
//        }

        //不管怎样都默认选中推荐队列
        [self btnClick:_recommendBtn];
    }
}

-(void)btnClick:(UIButton *)sender{
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptedWidth(64));
        make.height.mas_equalTo(AdaptedHeight(4));
        make.bottom.mas_equalTo(self).offset(AdaptedHeight(-10));
        make.centerX.mas_equalTo(sender.mas_centerX);
    }];

    [UIView animateWithDuration:0.25 animations:^{
        for (UIButton *btn in @[_recommendBtn, _mineBtn, _historyBtn]) {
            if ([btn isEqual:sender]) {
    btn.selected                  = YES;
            }else{
    btn.selected                  = NO;
            }
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];

    if ([sender isEqual:_recommendBtn]) {
        [self.btnClickSubject sendNext:@(KM_GroupTypeRecommend)];
    }else if ([sender isEqual:_historyBtn]){
        [self.btnClickSubject sendNext:@(KM_GroupTypeHistory)];
    }else if ([sender isEqual:_mineBtn]){
        [self.btnClickSubject sendNext:@(KM_GroupTypeMyArranging)];
    }
}


+(CGFloat)viewHeight{
    return AdaptedHeight(100);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{

    self.backgroundColor          = [UIColor whiteColor];

    //调整间距
    [_recommendBtn jk_setImagePosition:LXMImagePositionLeft spacing:AdaptedWidth(10)];
    [_mineBtn jk_setImagePosition:LXMImagePositionLeft spacing:AdaptedWidth(10)];
    [_historyBtn jk_setImagePosition:LXMImagePositionLeft spacing:AdaptedWidth(10)];
    //设置文字颜色
    [_recommendBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_recommendBtn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    [_recommendBtn setTitleColor:kMainThemeColor forState:UIControlStateHighlighted];

    [_historyBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_historyBtn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    [_historyBtn setTitleColor:kMainThemeColor forState:UIControlStateHighlighted];

    [_mineBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_mineBtn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    [_mineBtn setTitleColor:kMainThemeColor forState:UIControlStateHighlighted];

    //设置字体大小
    _recommendBtn.titleLabel.font = kFont32;
    _historyBtn.titleLabel.font   = kFont32;
    _mineBtn.titleLabel.font      = kFont32;

    [_lineView setBackgroundColor:kMainThemeColor];

    [_mineBtn addTarget:self
                      action:@selector(btnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [_recommendBtn addTarget:self
                      action:@selector(btnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [_historyBtn addTarget:self
                    action:@selector(btnClick:)
          forControlEvents:UIControlEventTouchUpInside];

}

-(void)km_layoutSubviews{
    [self setupDefalut];
}


#pragma mark - Lazy
-(RACSubject *)btnClickSubject{
    if (!_btnClickSubject) {
    _btnClickSubject              = [RACSubject subject];
    }
    return _btnClickSubject;
}

@end
