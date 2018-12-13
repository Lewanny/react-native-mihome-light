//
//  KMCityHeaderView.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCityHeaderView.h"

@interface KMCityHeaderView ()<UISearchBarDelegate>

@property (nonatomic, strong) UIView * searchBarBG;

@property (nonatomic, strong) UISearchBar * searchBar;

@property (nonatomic, strong) UIView * currentBG;

@property (nonatomic, strong) UILabel * curCityLbl;

@property (nonatomic, strong) UIButton * areaBtn;

@end

@implementation KMCityHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self                         = [super initWithFrame:frame];
    if (self) {
        [self km_addSubviews];
    }
    return self;
}

-(void)setCityName:(NSString *)cityName{
    _cityName                    = [cityName copy];
    [self.curCityLbl setText:NSStringFormat(@"当前：%@",cityName)];
    if (_areaBtn.selected) { [self clickAreaBtn:_areaBtn]; }
}

#pragma mark - Private Method -
-(void)clickAreaBtn:(UIButton *)sender{
    if (_cityName.length == 0 || [_cityName containsString:@"正在定位"]) {
        return;
    }
    sender.selected              = !sender.selected;
    if (sender.selected) {
        [sender setImage:[IMAGE_NAMED(@"xiajiant") imageByRotate180] forState:UIControlStateNormal];
    }else{
        [sender setImage:IMAGE_NAMED(@"xiajiant") forState:UIControlStateNormal];
    }
    self.areaSelect ? self.areaSelect(_cityName, sender.selected) : nil;
}

#pragma mark - AddSubViews -
-(void)km_addSubviews{
    [self addSubview:self.searchBarBG];
    [_searchBarBG addSubview:self.searchBar];
    [self addSubview:self.currentBG];
    [_currentBG addSubview:self.curCityLbl];
    [_currentBG addSubview:self.areaBtn];
}

#pragma mark - UISearchBarDelegate -
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(beginSearch)]) {
        [_delegate beginSearch];
    }
}
// 点击键盘搜索按钮时调用
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (_delegate && [_delegate respondsToSelector:@selector(searchWithKeyword:)]) {
        [_delegate searchWithKeyword:searchBar.text];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text               = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(endSearch)]) {
        [_delegate endSearch];
    }
}

#pragma mark - Lazy -
-(UIView *)searchBarBG{
    if (!_searchBarBG) {
    _searchBarBG                 = [UIView new];
        [_searchBarBG setFrame:CGRectMake(0, 0, KScreenWidth, AdaptedHeight(92))];
    _searchBarBG.backgroundColor = kBackgroundColor;
    }
    return _searchBarBG;
}
-(UIView *)currentBG{
    if (!_currentBG) {
    _currentBG                   = [UIView new];
        [_currentBG setFrame:CGRectMake(0, self.searchBarBG.bottom, KScreenWidth, AdaptedHeight(92))];
        [_currentBG setBackgroundColor:[UIColor whiteColor]];
    UIView *line1                = [UIView new];
    line1.backgroundColor        = kFontColorLightGray;
        [line1 setFrame:CGRectMake(0, 0, _currentBG.width, 0.5)];

    UIView *line2                = [UIView new];
    line2.backgroundColor        = kFontColorLightGray;
        [line2 setFrame:CGRectMake(0, _currentBG.height - 0.5, _currentBG.width, 0.5)];
        [_currentBG addSubview:line1];
        [_currentBG addSubview:line2];
    }
    return _currentBG;
}
-(UISearchBar *)searchBar{
    if (!_searchBar) {
    _searchBar                   = [[UISearchBar alloc]initWithFrame:CGRectMake(AdaptedWidth(24), AdaptedHeight(18), AdaptedWidth(702), AdaptedHeight(56))];

    UIImage *searchBarBG         = [[UIImage imageWithColor:[UIColor whiteColor]] imageByResizeToSize:CGSizeMake(1, _searchBar.height)];
        [_searchBar setBackgroundImage:searchBarBG];
        [_searchBar setSearchFieldBackgroundImage:searchBarBG forState:UIControlStateNormal];
        [_searchBar setBackgroundColor:[UIColor clearColor]];

        [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        [_searchBar setPlaceholder:@"输入城市名"];
        [_searchBar setDelegate:self];

    UITextField *searchField     = [_searchBar valueForKey:@"_searchField"];
    UIImage *image               = [UIImage imageNamed:@"sousuo"];
    UIImageView *iconView        = [[UIImageView alloc] initWithImage:image];
    iconView.frame               = CGRectMake(0, 0, image.size.width , image.size.height);
    searchField.leftView         = iconView;

        [_searchBar cornerRadius:_searchBar.height/2.0 strokeSize:0.5 color:kFontColorLightGray];
        [_searchBar.layer setMasksToBounds:YES];
    }
    return _searchBar;
}
-(UILabel *)curCityLbl{
    if (!_curCityLbl) {
    _curCityLbl                  = [[UILabel alloc]initWithFrame:CGRectMake(AdaptedWidth(24), 0, KScreenWidth - AdaptedWidth(24) - self.areaBtn.width, self.currentBG.height)];
        [_curCityLbl setText:@"当前:"];
        [_curCityLbl setFont:kFont28];
        [_curCityLbl setTextColor:kFontColorDarkGray];

    }
    return _curCityLbl;
}
-(UIButton *)areaBtn{
    if (!_areaBtn) {
    _areaBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat w                    = [@"选择区县" widthForFont:kFont22] + 40;
        [_areaBtn setFrame:CGRectMake(self.currentBG.width - w, 0, w, self.currentBG.height)];
        [_areaBtn setTitle:@"选择区县" forState:UIControlStateNormal];
        [_areaBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
        [_areaBtn setImage:IMAGE_NAMED(@"xiajiant") forState:UIControlStateNormal];
        [_areaBtn.titleLabel setFont:kFont22];
        [_areaBtn addTarget:self action:@selector(clickAreaBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_areaBtn jk_setImagePosition:LXMImagePositionRight spacing:10];
    }
    return _areaBtn;
}
@end
