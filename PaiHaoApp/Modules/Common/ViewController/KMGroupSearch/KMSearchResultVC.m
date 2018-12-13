//
//  KMSearchResultVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSearchResultVC.h"
#import "KMGroupQueueDetail.h"
#import "KMGroupQueueInfoVC.h"
#import "KMGroupSearchVM.h"
@interface KMSearchResultVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMGroupSearchVM * viewModel;

@end

@implementation KMSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [self.viewModel.resultArr removeAllObjects];
}

#pragma mark - Private Method -
-(void)addTableViewFoot{
    @weakify(self)
    _tableView.mj_footer             = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.viewModel.currentPage ++;
        [self km_requestData];
    }];
}
#pragma mark - DZNEmptyDataSetSource
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"暂无相关记录"];
    [title setFont:kFont28];
    [title setColor:kFontColorGray];
    return title;
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.resultArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMBasePaiHaoTableViewCell cellHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMBasePaiHaoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:[KMBasePaiHaoTableViewCell cellID]];
    KMGroupBriefModel *data          = [self.viewModel.resultArr objectAtIndex:indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KMGroupBriefModel *brief         = [self.viewModel.resultArr objectAtIndex:indexPath.row];
    [KMUserManager pushDetailWithGroupID:brief.ID];
}

#pragma mark - KMBaseViewControllerDataSource

-(NSMutableAttributedString *)setTitle{
    NSString *str                    = _keyword.length ? NSStringFormat(@"搜索-%@",_keyword) : @"搜索结果";
    return KMBaseNavTitle(str);
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}

-(void)km_requestData{
    [self.viewModel.searchCommand execute:self.keyword];
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
            }
            //结束尾部刷新
            if ([self.tableView.mj_footer isRefreshing]) {
                [x integerValue] > 0 ? [self.tableView.mj_footer endRefreshing] : [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                       = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate              = self;
    _tableView.dataSource            = self;
    _tableView.emptyDataSetDelegate  = self;
    _tableView.emptyDataSetSource    = self;
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
-(KMGroupSearchVM *)viewModel{
    if (!_viewModel) {
    _viewModel                       = [[KMGroupSearchVM alloc] init];
    }
    return _viewModel;
}
@end
