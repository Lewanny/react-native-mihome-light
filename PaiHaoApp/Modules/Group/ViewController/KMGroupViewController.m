//
//  KMGroupViewController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupViewController.h"
#import "KMGroupViewModel.h"
#import "KMGroupInfoCell.h"

#import "KMNewGroupController.h"
#import "KMGroupDetailController.h"
#import "KMQRCodeVC.h"
#import "KMMerchantServices.h"

@interface KMGroupViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 添加队列 */
@property (nonatomic, strong) UIButton * addBtn;
/** 商家服务 */
@property (nonatomic, strong) UIButton * serviceBtn;

@property (nonatomic, strong) KMGroupViewModel * viewModel;

@end

@implementation KMGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self km_refreshData];
}

#pragma mark - Push
/** 跳转 新建队列 */
-(void)pushNewGroupVC{
    KMNewGroupController * vc               = [[KMNewGroupController alloc]init];
    vc.titleStr                             = @"新建队列";
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

/** 跳转商户服务 */
-(void)pushServiceVC{
    //普通用户不能使用商户服务
    KMUserLoginModel *userModel             = [KMUserManager getLoginModel];
    if ([userModel.info.customerType integerValue] != KM_CustomerTypePersonal) {
        //商户服务
    KMMerchantServices *services            = [[KMMerchantServices alloc]init];
    services.customerType                   = [userModel.info.customerType integerValue];
        [self.navigationController cyl_pushViewController:services animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"普通用户不能使用商户服务" Duration:1];
    }
}

#pragma mark - Private Method -
-(void)setupNavRightButton{
    [self.addBtn addTarget:self action:@selector(pushNewGroupVC) forControlEvents:UIControlEventTouchUpInside];
    [self.serviceBtn addTarget:self action:@selector(pushServiceVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1                  = [[UIBarButtonItem alloc]initWithCustomView:_addBtn];
    UIBarButtonItem *item2                  = [[UIBarButtonItem alloc]initWithCustomView:_serviceBtn];
    //调整按钮位置
    UIBarButtonItem* spaceItem              = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width                         = -10;
    self.navigationItem.rightBarButtonItems = @[spaceItem, item1, item2];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (KMUserDefault.isLogin) {
        return self.viewModel.groupList.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMGroupInfoCell cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMGroupInfoCell *cell                   = [tableView dequeueReusableCellWithIdentifier:[KMGroupInfoCell cellID]];
    KMGroupInfo *info                       = [self.viewModel.groupList objectAtIndex:indexPath.row];
    [cell km_bindData:info];
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];

    @weakify(info)
    [[cell.QRSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(info)
        [KMUserManager pushQRCodeVCWithData:info];
    }];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KMGroupInfo * info                      = [self.viewModel.groupList objectAtIndex:indexPath.row];
    KMGroupDetailController *detail         = [[KMGroupDetailController alloc]init];
    detail.groupID                          = info.groupid;
    detail.singlenumber                     = info.singlenumber;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - DZNEmptyDataSetSource && DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSMutableAttributedString *attr         = [[NSMutableAttributedString alloc]initWithString:self.viewModel.emptyTitle];
    [attr setFont:AdaptedFontSizePx(52)];
    [attr setColor:kFontColorDark];
    return attr;
}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSMutableAttributedString *attr         = [[NSMutableAttributedString alloc]initWithString:self.viewModel.emptySubTitle];
    [attr setFont:kFont28];
    [attr setColor:kFontColorDark];
    return attr;
}
-(UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return IMAGE_NAMED(@"tianjia");
}
-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return AdaptedHeight(50);
}
-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return AdaptedHeight(-50);
}
-(void)emptyDataSetDidAppear:(UIScrollView *)scrollView{
    self.addBtn.hidden                      = YES;
}
-(void)emptyDataSetDidDisappear:(UIScrollView *)scrollView{
    self.addBtn.hidden                      = NO;
}
-(void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if ([KMUserManager checkLoginWithPresent:YES]) {
        [self pushNewGroupVC];
    }
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return [[NSMutableAttributedString alloc]initWithString:@"我的队列"
                                                 attributes:kNavTitleAttributes];
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self setupNavRightButton];
    [self.view addSubview:self.tableView];
}

-(void)km_refreshData{
    if (KMUserDefault.isLogin) {
        [self.viewModel.requestGroupList execute:nil];
    }
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
#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate                     = self;
    _tableView.dataSource                   = self;
    _tableView.emptyDataSetSource           = self;
    _tableView.emptyDataSetDelegate         = self;
    _tableView.layoutMargins                = UIEdgeInsetsZero;
        [_tableView registerClass:[KMGroupInfoCell class] forCellReuseIdentifier:[KMGroupInfoCell cellID]];
    }
    return _tableView;
}
-(UIButton *)addBtn{
    if (!_addBtn) {
    _addBtn                                 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:IMAGE_NAMED(@"xinjiana") forState:UIControlStateNormal];
        [_addBtn setFrame:CGRectMake(0, 0, 30, 44)];
    }
    return _addBtn;
}

-(UIButton *)serviceBtn{
    if (!_serviceBtn) {
    _serviceBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
        [_serviceBtn setImage:IMAGE_NAMED(@"shhufuwu") forState:UIControlStateNormal];
        [_serviceBtn setFrame:CGRectMake(0, 0, 30, 44)];
    }
    return _serviceBtn;
}

-(KMGroupViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                              = [KMGroupViewModel new];
    }
    return _viewModel;
}
@end
