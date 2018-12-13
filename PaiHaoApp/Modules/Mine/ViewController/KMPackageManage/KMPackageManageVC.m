//
//  KMPackageManageVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageManageVC.h"
#import "KMPackageVM.h"
#import "KMPackageManageCell.h"
#import "KMPackageSettingVC.h"
@interface KMPackageManageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) KMPackageVM * viewModel;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UILabel * tipsLbl;

@end

@implementation KMPackageManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method -
//跳转套餐设置
-(void)pushPackageSettingVCWithPackageID:(NSInteger)packageID{
    KMPackageSettingVC *vc     = [[KMPackageSettingVC alloc]init];
    vc.style                   = PackageSettingStyleEdit;
    vc.packageID               = packageID;
    vc.viewModel               = self.viewModel;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.packageArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMPackageManageCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMPackageManageCell *cell  = [tableView dequeueReusableCellWithIdentifier:[KMPackageManageCell cellID]];
    KMPackageInfo *info        = [self.viewModel.packageArr objectAtIndex:indexPath.section];
    [cell km_bindData:info];
    //编辑
    @weakify(self, info)
    [[cell.editSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self, info)
        [self pushPackageSettingVCWithPackageID:info.ID];
    }];
    //删除
    [[cell.deleSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self, info)
        [[self.viewModel.deleCommand execute:@(info.ID)] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self km_requestData];
        }];
    }];

    return cell;
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"套餐管理");
}

#pragma mark - BaseViewControllerInterface -

-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tipsLbl];
}

-(void)km_requestData{
    //请求套餐列表
    [self.viewModel.packageListCommand execute:nil];
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

#pragma mark - Lazy -
-(KMPackageVM *)viewModel{
    if (!_viewModel) {
    _viewModel                 = [[KMPackageVM alloc]init];
    }
    return _viewModel;
}
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                 = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, self.tipsLbl.top - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
        [_tableView registerClass:[KMPackageManageCell class] forCellReuseIdentifier:[KMPackageManageCell cellID]];
    }
    return _tableView;
}
-(UILabel *)tipsLbl{
    if (!_tipsLbl) {
    _tipsLbl                   = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight - AdaptedHeight(60) - 25, KScreenWidth, 25)];
        [_tipsLbl setText:@"注:有序号的按序号先后排队,无序号的自动分流,人少时间快的优先"];
        [_tipsLbl setTextAlignment:NSTextAlignmentCenter];
        [_tipsLbl setFont:kFont22];
        [_tipsLbl setTextColor:kMainThemeColor];
    }
    return _tipsLbl;
}
@end
