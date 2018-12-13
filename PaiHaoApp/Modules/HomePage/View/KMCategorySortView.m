//
//  KMCategorySortView.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCategorySortView.h"

@interface KMCategorySortView ()
/** 附近 */
@property (nonatomic, strong) UIButton * nearbyBtn;
/** 智能 */
@property (nonatomic, strong) UIButton * intellectBtn;
/** 筛选 */
@property (nonatomic, strong) UIButton * screenBtn;
@end

@implementation KMCategorySortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self           = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    @weakify(self)
    [self setBackgroundColor:[UIColor whiteColor]];

    CGFloat btnW   = self.width/3.0;
    CGFloat btnH   = self.height;
    //附近
    _nearbyBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nearbyBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_nearbyBtn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    [_nearbyBtn.titleLabel setFont:kFont26];
    [_nearbyBtn setTitle:@"附近" forState:UIControlStateNormal];
    [_nearbyBtn setImage:IMAGE_NAMED(@"xiajiant") forState:UIControlStateNormal];
    [_nearbyBtn jk_setImagePosition:LXMImagePositionRight spacing:10];
    [_nearbyBtn setFrame:CGRectMake(0, 0, btnW, btnH)];
    [_nearbyBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.reloadSubject sendNext:@(KMCategorySortTypeNearToFar)];
    }];
    [self addSubview:_nearbyBtn];
    //智能排序
    _intellectBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_intellectBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_intellectBtn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    [_intellectBtn.titleLabel setFont:kFont26];
    [_intellectBtn setTitle:@"状态筛选" forState:UIControlStateNormal];
    [_intellectBtn setImage:IMAGE_NAMED(@"xiajiant") forState:UIControlStateNormal];
    [_intellectBtn jk_setImagePosition:LXMImagePositionRight spacing:10];
    [_intellectBtn setFrame:CGRectMake(btnW, 0, btnW, btnH)];
    [_intellectBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.reloadSubject sendNext:@(KMCategorySortTypeIntellect)];
    }];
    [self addSubview:_intellectBtn];
    //筛选
    _screenBtn     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_screenBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_screenBtn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    [_screenBtn.titleLabel setFont:kFont26];
    [_screenBtn setTitle:@"区域筛选" forState:UIControlStateNormal];
    [_screenBtn setImage:IMAGE_NAMED(@"xiajiant") forState:UIControlStateNormal];
    [_screenBtn jk_setImagePosition:LXMImagePositionRight spacing:10];
    [_screenBtn setFrame:CGRectMake(2 * btnW, 0, btnW, btnH)];
    [_screenBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.reloadSubject sendNext:@(KMCategorySortTypeScreen)];
    }];
    [self addSubview:_screenBtn];

    //分割线
    CGFloat lineY  = self.height/4.0;
    CGFloat lineH  = self.height/2.0;
    CGFloat lineW  = 0.5;

    UIView *line1  = [UIView new];
    [line1 setBackgroundColor:kFontColorLightGray];
    [line1 setFrame:CGRectMake(btnW, lineY, lineW, lineH)];
    [self addSubview:line1];

    UIView *line2  = [UIView new];
    [line2 setBackgroundColor:kFontColorLightGray];
    [line2 setFrame:CGRectMake(2 * btnW, lineY, lineW, lineH)];
    [self addSubview:line2];

    UIView *line3  = [UIView new];
    [line3 setBackgroundColor:kFontColorLightGray];
    [line3 setFrame:CGRectMake(0, self.height, self.width, 0.5)];
    [self addSubview:line3];
}
-(void)setSortType:(KMCategorySortType)sortType{
    [_nearbyBtn setSelected:sortType == KMCategorySortTypeNearToFar ? YES : NO ];
    [_intellectBtn setSelected:sortType == KMCategorySortTypeIntellect ? YES : NO];
    [_screenBtn setSelected:sortType == KMCategorySortTypeScreen ? YES : NO];
}
#pragma mark - Lazy -
-(RACSubject *)reloadSubject{
    if (!_reloadSubject) {
    _reloadSubject = [RACSubject subject];
    }
    return _reloadSubject;
}
@end
