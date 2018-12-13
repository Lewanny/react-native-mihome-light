//
//  KMSettingWindowController.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSettingWindowController.h"
#import "KMSettingWindowCell.h"
#import "KMSetWinVM.h"
#import "KMSegmentView.h"
@interface KMSettingWindowController ()<UITableViewDelegate, UITableViewDataSource, KMSegmentViewDelegate>

@property (nonatomic, strong) KMSegmentView * segment;

/** 提交 */
@property (nonatomic, strong) UIButton * commitBtn;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMSetWinVM * viewModel;

@end

@implementation KMSettingWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMSettingWindowCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self km_configTableCellWithIndexPath:indexPath];
}

#pragma mark - KMSegmentViewDelegate
-(void)segmentViewDidClick:(NSInteger)index{
    if (index == 0) {
    self.viewModel.bindState   = KM_WindowBindStateNot;
        [self.viewModel.unabsorbedWin execute:nil];
    }else if (index == 1){
    self.viewModel.bindState   = KM_WindowBindStateAlready;
        [self.viewModel.bindedWin execute:self.groupID];
    }
    [self.viewModel.reloadSubject sendNext:nil];
}


#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"设置窗口");
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.segment];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
    [self.segment setSelectedIndex:0];
}

-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            [self.tableView reloadData];
        });
    }];
}
-(void)km_bindEvent{
    @weakify(self)
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([self.viewModel verifyData]) {
            [self.viewModel.commitCommand execute:self.groupID];
        }
    }];
}
-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    KMSettingWindowCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[KMSettingWindowCell cellID]];
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];
    KMWindowInfo *info         = [self.viewModel.dataArr objectAtIndex:indexPath.row];

    [cell km_bindData:info];

    @weakify(self, info)
    [[[cell.selectedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self, info)
    info.selected              = !info.selected;
        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
    return cell;
}
#pragma mark - Lazy
-(KMSegmentView *)segment{
    if (!_segment) {
    _segment                   = [[KMSegmentView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, 50)
                                                Titles:@[@"窗口分配", @"窗口解绑"]
                                      VerticalLineShow:YES];
    _segment.delegate          = self;
    }
    return _segment;
}

-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                 = [[UITableView alloc]initWithFrame:CGRectMake(0, self.segment.bottom, KScreenWidth, self.commitBtn.top - kNavHeight - AdaptedHeight(30) - self.segment.height) style:UITableViewStyleGrouped];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.layoutMargins   = UIEdgeInsetsZero;
        [_tableView registerClass:[KMSettingWindowCell class] forCellReuseIdentifier:[KMSettingWindowCell cellID]];
    }
    return _tableView;
}
-(KMSetWinVM *)viewModel{
    if (!_viewModel) {
    _viewModel                 = [[KMSetWinVM alloc]init];
    }
    return _viewModel;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    _commitBtn.titleLabel.font = kFont32;
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setFrame:CGRectMake(AdaptedWidth(55), KScreenHeight - AdaptedHeight(40 + 84 + 30), KScreenWidth - AdaptedWidth(55 * 2), AdaptedHeight(84))];
        [_commitBtn setBackgroundImage:[[[UIImage imageWithColor:kMainThemeColor] imageByResizeToSize:_commitBtn.size] imageByRoundCornerRadius:_commitBtn.height / 2.0] forState:UIControlStateNormal];
    }
    return _commitBtn;
}
@end
