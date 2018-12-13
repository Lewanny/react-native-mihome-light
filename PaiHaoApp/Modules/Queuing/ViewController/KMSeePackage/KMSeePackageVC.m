//
//  KMSeePackageVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSeePackageVC.h"
#import "KMSeePackageCell.h"
#import "KMSeePackageVM.h"
@interface KMSeePackageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMSeePackageVM * viewModel;

@end

@implementation KMSeePackageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.infoArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20) ;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMSeePackageCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMSeePackageCell *cell    = [tableView dequeueReusableCellWithIdentifier:[KMSeePackageCell cellID]];

    KMPackageStatusInfo *info = [self.viewModel.infoArr objectAtIndex:indexPath.row];
    NSString *num             = NSStringFormat(@"%ld",info.sort);
    NSString *name            = info.groupName;
    NSNumber *status          = @(info.status);
    
    [cell km_bindData:RACTuplePack(num, name, status)];
    
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];
    [cell.contentView setBackgroundColor:indexPath.row % 2 == 0 ? [UIColor whiteColor] : kFontColorLightGray];
    return cell;
}


#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"查看套餐");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
-(void)km_requestData{
    [self.viewModel.packageCommand execute:_packageId];
}
-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}
#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 50.0;
        _tableView.delegate           = self;
        _tableView.dataSource         = self;
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        [_tableView registerClass:[KMSeePackageCell class] forCellReuseIdentifier:[KMSeePackageCell cellID]];
    }
    return _tableView;
}
-(KMSeePackageVM *)viewModel{
    if (!_viewModel) {
        _viewModel                    = [[KMSeePackageVM alloc]init];
    }
    return _viewModel;
}
@end
