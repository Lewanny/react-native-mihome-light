//
//  KMPackageSettingVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageSettingVC.h"
#import "KMPackageSettingTopCell.h"
#import "KMPackageSettingItemCell.h"
@interface KMPackageSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * commitBtn;

@property (nonatomic, strong) UILabel * tipsLbl;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMPackageSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method -
-(void)clickCommitBtn{

    KMPackageSettingTopCell *topCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    NSString *pName                  = topCell.name;
    NSString *pInfo                  = topCell.info;
    KMLog(@"====  %@ \n  %@",pName,pInfo);

    if (_style == PackageSettingStyleNew) {
        //新建套餐
    _viewModel.packageName           = pName;
    _viewModel.packageInfo           = pInfo;
        if ([_viewModel verifyNewPackageData]) {
            @weakify(self)
            [[_viewModel.addNewPackageCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else if (_style == PackageSettingStyleEdit){
        //编辑套餐
        if ([_viewModel verifyEditPackageData]) {
            @weakify(self)
            [[_viewModel.commitEditCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }

    if (_style == PackageSettingStyleNew) {
        return self.viewModel.groupArr.count;
    }

    return self.viewModel.editPackageInfo.relate.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
           return [KMPackageSettingTopCell cellHeight];
    }
    return [KMPackageSettingItemCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    KMPackageSettingTopCell *cell    = [tableView dequeueReusableCellWithIdentifier:[KMPackageSettingTopCell cellID]];
        if (_style == PackageSettingStyleEdit) {
            [cell km_bindData:self.viewModel.editPackageInfo];
        }
        return cell;
    }
    KMPackageSettingItemCell *cell   = [tableView dequeueReusableCellWithIdentifier:[KMPackageSettingItemCell cellID]];
    if (_style == PackageSettingStyleNew) {
        //新建套餐
    KMGroupOrderInfo *info           = [self.viewModel.groupArr objectAtIndex:indexPath.row];
        [cell km_bindData:info];
    }else{
        //编辑套餐
    KMPackageRelate *item            = [self.viewModel.editPackageInfo.relate objectAtIndex:indexPath.row];
        [cell km_bindData:item];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_style == PackageSettingStyleNew) {
        //新建套餐
        if (indexPath.section == 1) {
    KMGroupOrderInfo *info           = [self.viewModel.groupArr objectAtIndex:indexPath.row];
    info.select                      = !info.select;
            [tableView reloadData];
        }
    }else if (_style == PackageSettingStyleEdit){
        //编辑套餐
    KMPackageRelate *item            = [self.viewModel.editPackageInfo.relate objectAtIndex:indexPath.row];
    item.selected                    = !item.selected;
        [tableView reloadData];
    }
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"套餐设置");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.commitBtn];
    [self.view addSubview:self.tipsLbl];
    [self.view addSubview:self.tableView];
}
-(void)km_requestData{
    if (_style == PackageSettingStyleNew) {
        //新增套餐
        @weakify(self)
        [[self.viewModel.groupListCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            DISPATCH_ON_MAIN_THREAD(^{
                @strongify(self)
                [self.tableView reloadData];
            });
        }];
    }else if(_style == PackageSettingStyleEdit){
        //编辑套餐
        @weakify(self)
        [[self.viewModel.editInfoCommand execute:@(self.packageID)] subscribeNext:^(id  _Nullable x) {
            DISPATCH_ON_MAIN_THREAD(^{
                @strongify(self)
                [self.tableView reloadData];
            });
        }];
    }
}

#pragma mark - Lazy -
-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn.titleLabel setFont:kFont32];
        [_commitBtn setFrame:CGRectMake(AdaptedWidth(55), KScreenHeight - AdaptedHeight(60 + 84), KScreenWidth - AdaptedWidth(55 * 2), AdaptedHeight(84))];
        [_commitBtn setBackgroundImage:[[[UIImage imageWithColor:kMainThemeColor] imageByResizeToSize:_commitBtn.size] imageByRoundCornerRadius:_commitBtn.height/2.0] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

-(UILabel *)tipsLbl{
    if (!_tipsLbl) {
    _tipsLbl                         = [[UILabel alloc]initWithFrame:CGRectMake(0, self.commitBtn.top - AdaptedHeight(62), KScreenWidth, AdaptedHeight(62))];
        [_tipsLbl setText:@"注:有序号的按序号先后排队,无序号的自动分流,人少时间快的优先"];
        [_tipsLbl setTextAlignment:NSTextAlignmentCenter];
        [_tipsLbl setFont:kFont22];
        [_tipsLbl setTextColor:kMainThemeColor];
    }
    return _tipsLbl;
}
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                       = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, self.tipsLbl.top - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor       = self.view.backgroundColor;
    _tableView.delegate              = self;
    _tableView.dataSource            = self;
        [_tableView registerClass:[KMPackageSettingTopCell class] forCellReuseIdentifier:[KMPackageSettingTopCell cellID]];
        [_tableView registerClass:[KMPackageSettingItemCell class] forCellReuseIdentifier:[KMPackageSettingItemCell cellID]];
    }
    return _tableView;
}
@end
