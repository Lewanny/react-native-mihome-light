//
//  KMCitySearchView.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCitySearchView.h"

@interface KMCitySearchView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMCitySearchView

- (instancetype)initWithFrame:(CGRect)frame
{
self                       = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reslutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
UITableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell cellID] forIndexPath:indexPath];
NSString *cityName         = _reslutArr[indexPath.row];
cell.textLabel.text        = cityName;
cell.backgroundColor       = [UIColor clearColor];
cell.selectionStyle        = UITableViewCellSelectionStyleDefault;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
NSString *cityName         = _reslutArr[indexPath.row];
    if (![cityName containsString:@"抱歉"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(citySearchViewDidSelectCity:)]) {
            [self.delegate citySearchViewDidSelectCity:cityName];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(void)setReslutArr:(NSMutableArray *)reslutArr{
_reslutArr                 = reslutArr;
    [_tableView reloadData];
}

#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
_tableView                 = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
_tableView.delegate        = self;
_tableView.dataSource      = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell cellID]];
_tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
-(NSMutableArray *)reslutArr{
    if (!_reslutArr) {
_reslutArr                 = @[].mutableCopy;
    }
    return _reslutArr;
}

@synthesize reslutArr      = _reslutArr;

@end
