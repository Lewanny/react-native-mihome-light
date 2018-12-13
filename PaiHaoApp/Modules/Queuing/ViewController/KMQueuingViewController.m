//
//  KMQueuingViewController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMQueuingViewController.h"

#import "KMQueuingViewModel.h"

#import "KMBasePaiHaoTableViewCell.h"

#import "KMGroupQueueInfoVC.h"
#import "KMGroupSearchVC.h"
@interface KMQueuingViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KMQueuingViewModel * viewModel;

@end

@implementation KMQueuingViewController
#pragma mark - Lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self km_refreshData];
}

#pragma mark - Push
/** 跳转 排号详情 */
-(void)pushQueueInfoWithQueueID:(NSString *)queueID GroupID:(NSString *)groupID{
    KMGroupQueueInfoVC *vc = [[KMGroupQueueInfoVC alloc]init];
    vc.groupID             = groupID;
    vc.queueID             = queueID;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
/** 跳转 搜索 */
-(void)pushSearchVC{
    KMGroupSearchVC *vc = [[KMGroupSearchVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"您还没有参与排队\n\n立即体验吧......" attributes:@{NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kFontColorGray}];
    return attr;
}

-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"搜  索" attributes:@{NSFontAttributeName : kFont32, NSForegroundColorAttributeName : [UIColor whiteColor]}];
    return attr;
}

-(UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return [[[UIImage imageWithColor:kMainThemeColor] imageByResizeToSize:CGSizeMake(KScreenWidth - AdaptedWidth(55 + 55), AdaptedHeight(84))] imageByRoundCornerRadius:AdaptedHeight(84)/2.0];
}

-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
   return AdaptedHeight(200);
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self pushSearchVC];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMBasePaiHaoTableViewCell cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self km_configTableCellWithIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KMQueueInfo *info = [self.viewModel.dataArr objectAtIndex:indexPath.row];
    [self pushQueueInfoWithQueueID:info.queueid GroupID:info.groupid];
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"排号");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
-(void)km_refreshData{
    if (KMUserDefault.isLogin) {
       [self.viewModel.requestMyQueue execute:nil];
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
-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    KMBasePaiHaoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[KMBasePaiHaoTableViewCell cellID]];
    [cell.bottomGrayLine setHidden:NO];
    KMQueueInfo *data               = [self.viewModel.dataArr objectAtIndex:indexPath.row];
    [cell km_bindData:data];
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];
    @weakify(data)
    [[cell.QRSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(data)
        [KMUserManager pushQRCodeVCWithData:data];
    }];
    [[cell.mapSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(data)
        CLLocationCoordinate2D coor;
        NSString *targetName        = @"";
        KMQueueInfo *model          = data;
        coor                        = CLLocationCoordinate2DMake(model.lat.floatValue, model.lng.floatValue);
        targetName                  = model.groupname;
        if (coor.latitude && coor.longitude) {
            [KMLocationManager showActionSheetWithMaps:[KMLocationManager getInstalledMapAppWithEndLocation:coor TargetName:targetName]];
        }
    }];
    return cell;
}

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                      = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor      = [UIColor clearColor];
        _tableView.delegate             = self;
        _tableView.dataSource           = self;
        _tableView.emptyDataSetSource   = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.layoutMargins        = UIEdgeInsetsZero;
        _tableView.tableFooterView      = [UIView new];
        _tableView.sectionFooterHeight  = 0.01;
        [_tableView registerClass:[KMBasePaiHaoTableViewCell class] forCellReuseIdentifier:[KMBasePaiHaoTableViewCell cellID]];
    }
    return _tableView;
}
-(KMQueuingViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                      = [[KMQueuingViewModel alloc]init];
    }
    return _viewModel;
}
@end
