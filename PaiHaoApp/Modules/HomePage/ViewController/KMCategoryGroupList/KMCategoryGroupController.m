//
//  KMCategoryGroupController.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCategoryGroupController.h"
#import "KMCategoryViewModel.h"

#import "KMAddressPicker.h"
#import <ActionSheetPicker_3_0/ActionSheetStringPicker.h>
#import "KMCategorySortView.h"//筛选

#import "KMGroupQueueDetail.h"//队列排队 其他入口
#import "KMGroupQueueInfoVC.h"//队列排队 我的排号入口
@interface KMCategoryGroupController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KMCategoryViewModel * viewModel;

@property (nonatomic, strong) KMCategorySortView * sortView;



@end

@implementation KMCategoryGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method

-(void)addTableViewFoot{
    @weakify(self)
    _tableView.mj_footer             = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.viewModel.currentPage ++;
        [self km_requestData];
    }];
}

-(void)showAddressPicker{
    @weakify(self)
    [KMAddressPicker showWithCallBack:^(NSString *province, NSString *city, NSString *area) {
        @strongify(self)
    self.viewModel.sortArea          = area;
    self.viewModel.sortType          = KMCategorySortTypeScreen;
    self.viewModel.queueSort         = KMCategoryQueueSortNone;
        [self.tableView.mj_header beginRefreshing];
    }];
}

-(void)showQueueStatusPicker{
    @weakify(self)
    [ActionSheetStringPicker showPickerWithTitle:@"排队状态" rows:@[@"正在排队", @"将要开始", @"已经结束"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        if (selectedIndex == 0) {
    self.viewModel.queueSort         = KMCategoryQueueSortBeing;
        }
        if (selectedIndex == 1) {
    self.viewModel.queueSort         = KMCategoryQueueSortNotyet;
        }
        if (selectedIndex == 2) {
    self.viewModel.queueSort         = KMCategoryQueueSortEnd;
        }
    self.viewModel.sortType          = KMCategorySortTypeIntellect;
    self.viewModel.sortArea          = @"";
        [self.tableView.mj_header beginRefreshing];
    } cancelBlock:nil origin:self.view];
}

#pragma mark - Push
-(void)pushGroupQueueWithGroupID:(NSString *)groupID{
    KMGroupQueueDetail *detail       = [[KMGroupQueueDetail alloc]init];
    detail.groupID                   = groupID;
    [self.navigationController cyl_pushViewController:detail animated:YES];
}
//队列详情 已排队
-(void)pushMineQueueInfoWithGroupID:(NSString *)groupID QueueID:(NSString *)queueID{
    KMGroupQueueInfoVC *vc           = [[KMGroupQueueInfoVC alloc]init];
    vc.groupID                       = groupID;
    vc.queueID                       = queueID;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSMutableAttributedString *attr  = [[NSMutableAttributedString alloc]initWithString:@"暂无相关数据"];
    [attr setFont:kFont32];
    [attr setColor:kFontColorGray];
    return attr;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.sortView setSortType:self.viewModel.sortType];
    return [self.viewModel dataArr].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMBasePaiHaoTableViewCell cellHeight];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self km_configTableCellWithIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KMGroupBriefModel * brief        = [[self.viewModel dataArr] objectAtIndex:indexPath.row];
    [KMUserManager pushDetailWithGroupID:brief.ID];
}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle([KMTool categoryNameWithID:self.categoryID]);
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sortView];
}
-(void)km_requestData{
    [self.viewModel.requestCategoryList execute:self.categoryID];
}
-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            //列表不为空再添加下拉刷新
            if ([x integerValue] > 0 && self.tableView.mj_footer == nil) {
                [self addTableViewFoot];
            }
            //结束头部刷新
            if ([self.tableView.mj_header isRefreshing]) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
            }
            //结束尾部刷新
            if ([self.tableView.mj_footer isRefreshing]) {
                [x integerValue] > 0 ? [self.tableView.mj_footer endRefreshing] : [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        });
    }];
}

-(void)km_bindEvent{
    @weakify(self)
    [[self.sortView.reloadSubject takeUntil:self.sortView.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        switch ([x integerValue]) {
            case KMCategorySortTypeNearToFar:{  //由近到远排序
                if (![KMLocationManager shareInstance].myLocation) {
                    [SVProgressHUD showInfoWithStatus:@"正在定位，请确认已开启定位服务" Duration:1];
                    return;
                }
    self.viewModel.sortType          = KMCategorySortTypeNearToFar;
                [self.tableView reloadData];
            }
                break;
            case KMCategorySortTypeIntellect:   //智能排序
                [self showQueueStatusPicker];
                break;
            case KMCategorySortTypeScreen:      //筛选排序
                [self showAddressPicker];
                break;
            default:
                break;
        }
    }];
}

-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    KMBasePaiHaoTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[KMBasePaiHaoTableViewCell cellID]];
    KMGroupBriefModel *data          = [[self.viewModel dataArr] objectAtIndex:indexPath.row];
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
    NSString *targetName             = @"";
    KMGroupBriefModel *model         = data;
    coor                             = CLLocationCoordinate2DMake(model.lat, model.lng);
    targetName                       = model.groupname;
        if (coor.latitude && coor.longitude) {
            [KMLocationManager showActionSheetWithMaps:[KMLocationManager getInstalledMapAppWithEndLocation:coor TargetName:targetName]];
        }
    }];
    return cell;
}

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                       = [[UITableView alloc]initWithFrame:CGRectMake(0, self.sortView.bottom, KScreenWidth, KScreenHeight - kNavHeight - self.sortView.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor       = [UIColor clearColor];
    _tableView.delegate              = self;
    _tableView.dataSource            = self;
    _tableView.emptyDataSetSource    = self;
    _tableView.emptyDataSetDelegate  = self;
    _tableView.layoutMargins         = UIEdgeInsetsZero;
    _tableView.tableFooterView       = [UIView new];
    _tableView.sectionFooterHeight   = 0.01;
        [_tableView registerClass:[KMBasePaiHaoTableViewCell class] forCellReuseIdentifier:[KMBasePaiHaoTableViewCell cellID]];
        @weakify(self)
    _tableView.mj_header             = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
    self.viewModel.currentPage       = 1;
            [self km_requestData];
        }];

    }
    return _tableView;
}

-(KMCategoryViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                       = [[KMCategoryViewModel alloc]init];
    }
    return _viewModel;
}

-(KMCategorySortView *)sortView{
    if (!_sortView) {
    _sortView                        = [[KMCategorySortView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, AdaptedHeight(82))];
    }
    return _sortView;
}
@end
