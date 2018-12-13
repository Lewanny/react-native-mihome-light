//
//  KMSegmentView.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSegmentView.h"

#define KMSegmentViewBtnTag 233

@interface KMSegmentView ()

@property (nonatomic, copy) NSArray * titles;

@property (nonatomic, assign) BOOL  verticalLineShow;

@property (nonatomic, copy) NSMutableArray * btns;

@property (nonatomic, strong) UIView * line;

@property (nonatomic, strong) UIView * hLine;

@end


@implementation KMSegmentView

-(instancetype)initWithFrame:(CGRect)frame
                      Titles:(NSArray<NSString *> *)titles
            VerticalLineShow:(BOOL)show{
    if (self                 = [super initWithFrame:frame]) {
    self.titles              = titles;
    self.verticalLineShow    = show;
    self.backgroundColor     = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

-(void)setup{
    if (_titles.count == 0) {
        return;
    }

    _hLine                   = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 0.5)];
    _hLine.backgroundColor   = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    [self addSubview:_hLine];


    CGFloat btnW             = 1.0 * self.width/_titles.count;
    CGFloat btnH             = self.height;

    [_titles enumerateObjectsUsingBlock:^(NSString * title, NSUInteger idx, BOOL * _Nonnull stop) {
    UIButton *btn            = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:kFontColorGray forState:UIControlStateNormal];
        [btn setTitleColor:kMainThemeColor forState:UIControlStateHighlighted];
        [btn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    btn.titleLabel.font      = kFont32;
        [btn setFrame:CGRectMake(idx * btnW, 0, btnW, btnH)];

    btn.tag                  = KMSegmentViewBtnTag + idx;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btns addObject:btn];
        if (idx != 0) {
    UIView * lineView        = [UIView new];
    lineView.backgroundColor = kFontColorLightGray;
    lineView.frame           = CGRectMake(idx * btnW, 0, AdaptedWidth(2), AdaptedHeight(40));
    lineView.hidden          = !self.verticalLineShow;
    lineView.centerY         = btn.centerY;
            [self addSubview:lineView];
        }
    }];

    [self addSubview:self.line];
    [self setSelectedIndex:0];
}
/** 自行调用 初始化选择位置 */
-(void)setSelectedIndex:(NSInteger)index{
    if (_titles.count == 0) {
        return;
    }
    UIButton * btn           = [_btns objectAtIndex:index];
    [UIView animateWithDuration:0.25 animations:^{
    _line.centerX            = btn.centerX;
    }];

    for (UIButton *button in _btns) {
    button.selected          = [btn isEqual:button];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentViewDidClick:)]) {
        [self.delegate segmentViewDidClick:index];
    }

}

-(void)btnClick:(UIButton *)sender{
    [self setSelectedIndex:sender.tag - KMSegmentViewBtnTag];
}

#pragma mark - Lazy
-(NSMutableArray *)btns{
    if (!_btns) {
    _btns                    = [NSMutableArray array];
    }
    return _btns;
}
-(UIView *)line{
    if (!_line) {
    _line                    = [UIView new];
    _line.frame              = CGRectMake(0, self.height - AdaptedHeight(20 + 4), AdaptedWidth(64), AdaptedHeight(4));
    _line.backgroundColor    = kMainThemeColor;
    }
    return _line;
}
@end
