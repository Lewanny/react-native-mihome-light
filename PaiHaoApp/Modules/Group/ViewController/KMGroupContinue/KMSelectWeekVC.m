//
//  KMSelectWeekVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSelectWeekVC.h"
#import "KMSettingWindowCell.h"
@interface KMSelectWeekVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * commitBtn;

@end

@implementation KMSelectWeekVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(NSArray <NSString *> *)weekText{
    return @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
}

-(void)commit{
    self.action ? self.action([NSNumber numberWithInteger:self.selectWeek]) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMSettingWindowCell cellHeight];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMSettingWindowCell *cell = [tableView dequeueReusableCellWithIdentifier:[KMSettingWindowCell cellID]];
    [cell.leftLbl setText:[@"星期" stringByAppendingString:[[self weekText] objectAtIndex:indexPath.row]]];
    KMWeek selectW            = 1 << indexPath.row;
    //检查是否包含某选型
    if ( _selectWeek & selectW ){
        [cell km_bindData:[NSNumber numberWithBool:YES]];
    }else{
        [cell km_bindData:[NSNumber numberWithBool:NO]];
    }

    //点击按钮
    @weakify(tableView, indexPath)
    [[[cell.selectedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(tableView, indexPath)
    KMWeek select             = 1 << indexPath.row;
        //检查是否包含某选型
        if ( _selectWeek & select ){
            //包含
            //减少选项
    _selectWeek               = _selectWeek & (~select);
        }else{
            //不包含
            //增加选项:
    _selectWeek               = _selectWeek | select;
        }
        [tableView beginUpdates];
        [tableView reloadData];
        [tableView endUpdates];
    }];
    return cell;
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"设置");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
}

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - self.commitBtn.height - AdaptedHeight(20)) style:UITableViewStyleGrouped];
    _tableView.delegate       = self;
    _tableView.dataSource     = self;
        [_tableView registerClass:[KMSettingWindowCell class] forCellReuseIdentifier:[KMSettingWindowCell cellID]];
    }
    return _tableView;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setFrame:CGRectMake(AdaptedWidth(55), KScreenHeight - AdaptedHeight(60 + 84), AdaptedWidth(640), AdaptedHeight(84))];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_commitBtn.titleLabel setFont:kFont32];
        [_commitBtn setBackgroundImage:[[UIImage imageWithColor:kMainThemeColor size:_commitBtn.size] imageByRoundCornerRadius:_commitBtn.height / 2.0] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
@end
