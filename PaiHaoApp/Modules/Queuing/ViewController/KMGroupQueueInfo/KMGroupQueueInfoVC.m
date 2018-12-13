//
//  KMGroupQueueInfoVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueInfoVC.h"
#import "KMGroupQueueInfoVM.h"

#import "KMGroupQueueInfoCell.h"
#import "KMQueuePackageCell.h"
#import "KMQueueWaitInfoCell.h"
#import "KMGroupQueueDataCell.h"

#import "KMQueueDataModel.h"

#import "KMSeePackageVC.h"

#import "KMSystemShareTool.h"
@interface KMGroupQueueInfoVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMGroupQueueInfoVM * viewModel;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * exitBtn;

@end

@implementation KMGroupQueueInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self km_refreshData];
}

#pragma mark - Push
-(void)pushSeePackageVC{
    KMSeePackageVC *vc = [[KMSeePackageVC alloc]init];
    vc.packageId = self.viewModel.queueDetail.packageId;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - Private Method
-(void)exitQueue{
    @weakify(self)
    [LBXAlertAction showAlertWithTitle:@"提示" msg:@"退出和过号都会影响你的信用值，退出每次扣0.5分，过号每次扣1分，扣分过多，可能会被暂时封号，请谨慎操作，你确认要退出排号吗？" buttonsStatement:@[@"确认退出", @"返回"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 0) {
            //若已经在排队 则退出排队
            @strongify(self)
            [[self.viewModel.exitQueueCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSections];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.viewModel numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height  = 0;
    CellStyle style = [self.viewModel styleForIndexPath:indexPath];
    if (style == CellStyleGroupInfo) {
        height      = [KMGroupQueueInfoCell cellHeight];
    }else if (style == CellStylePackageInfo){
        height      = [KMQueuePackageCell cellHeight];
    }else if (style == CellStyleWaitInfo){
        height      = [KMQueueWaitInfoCell cellHeight];
    }else if (style == CellStyleQueueInfo){
        height      = [KMGroupQueueDataCell cellHeight];
    }
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self km_configTableCellWithIndexPath:indexPath];
}
#pragma mark - KMBaseViewControllerDataSource

-(UIButton *)set_rightButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setImage:IMAGE_NAMED(@"fxiang") forState:UIControlStateNormal];
    return btn;
}
-(void)right_button_event:(UIButton *)sender{
    if (!_viewModel.baseInfo) {
        return;
    }
    //http://weixin.paihao123.com/web/index/detailed.html?id=gro1504521318e338010dccd14ebab9654d4&groupNo=1145
    NSString *textToShare = NSStringFormat(@"http://weixin.paihao123.com/web/index/detailed.html?id=%@&groupNo=%@",_viewModel.baseInfo.groupid, _viewModel.baseInfo.groupno);
    NSURL *urlToShare = [NSURL URLWithString:textToShare];
    [KMSystemShareTool shareWithURL:urlToShare Text:textToShare Image:nil];
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.exitBtn];
}

-(void)km_refreshData{
    [self.viewModel.requestGroupInfo execute:self.groupID];
    [self.viewModel.requestQueueDetailInfo execute:nil];
    [self.viewModel.requestQueueInfo execute:nil];

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
    
    UITableViewCell *cell               = nil;
    
    CellStyle style                     = [self.viewModel styleForIndexPath:indexPath];
    if (style == CellStyleGroupInfo) {
        //队列信息
        KMGroupQueueInfoCell *gCell     = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupQueueInfoCell cellID]];
        [gCell km_bindData:self.viewModel.baseInfo];
        @weakify(self)
        [[gCell.QRSubject takeUntil:gCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [KMUserManager pushQRCodeVCWithData:self.viewModel.baseInfo];
        }];
        [[gCell.telSubject takeUntil:gCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [KMTool callWithTel:self.viewModel.baseInfo.telephone];
        }];
        
        cell                            = gCell;
    }else if (style == CellStylePackageInfo){
        //套餐信息
        KMQueuePackageCell *pCell       = [self.tableView dequeueReusableCellWithIdentifier:[KMQueuePackageCell cellID]];
        [pCell km_bindData:self.viewModel.queueDetail];
        @weakify(self)
        [[pCell.seeSubject takeUntil:pCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self pushSeePackageVC];
        }];
        cell                            = pCell;
    }else if (style == CellStyleWaitInfo){
        //等待信息
        KMQueueWaitInfoCell *waitCell   = [self.tableView dequeueReusableCellWithIdentifier:[KMQueueWaitInfoCell cellID]];
        [waitCell km_bindData:self.viewModel.queueDetail];
        cell                            = waitCell;
    }else if (style == CellStyleQueueInfo){
        //排队信息
//        KMQueueItem *item               = [self.viewModel.queueDetail.QueueDetailed objectAtIndex:indexPath.row];
        KMQueueDataModel *item = self.viewModel.queueArr[indexPath.row];
        KMGroupQueueDataCell *queueCell = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupQueueDataCell cellID]];
        [queueCell km_bindData:item];
        cell                            = queueCell;
        [cell.contentView setBackgroundColor:indexPath.row % 2 == 0 ? [UIColor whiteColor] : kFontColorLightGray];
        if (indexPath.row == 0) {
            queueCell.windowLbl.text = item.windowName.length > 0?item.windowName:@"办理中";
            queueCell.windowLbl.textColor = kMainThemeColor;
        }
    }
    
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];
    return cell;
}

#pragma mark - Lazy
-(KMGroupQueueInfoVM *)viewModel{
    if (!_viewModel) {
        _viewModel                     = [[KMGroupQueueInfoVM alloc]init];
        _viewModel.groupID             = self.groupID;
        _viewModel.queueID             = self.queueID;
    }
    return _viewModel;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                     = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - self.exitBtn.height - AdaptedHeight(30 * 2)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor     = [UIColor clearColor];
        _tableView.delegate            = self;
        _tableView.dataSource          = self;
        _tableView.tableFooterView     = [UIView new];
        _tableView.sectionFooterHeight = AdaptedHeight(20);
        _tableView.layoutMargins       = UIEdgeInsetsZero;
        _tableView.estimatedRowHeight  = 100;
        
        [_tableView registerClass:[KMGroupQueueInfoCell class] forCellReuseIdentifier:[KMGroupQueueInfoCell cellID]];
        [_tableView registerClass:[KMQueuePackageCell class] forCellReuseIdentifier:[KMQueuePackageCell cellID]];
        [_tableView registerClass:[KMQueueWaitInfoCell class] forCellReuseIdentifier:[KMQueueWaitInfoCell cellID]];
        [_tableView registerClass:[KMGroupQueueDataCell class] forCellReuseIdentifier:[KMGroupQueueDataCell cellID]];
    }
    return _tableView;
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitBtn setTitle:@"退出排号" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exitBtn setFrame:CGRectMake(AdaptedWidth(55), KScreenHeight - AdaptedHeight(84 + 30), KScreenWidth - AdaptedWidth(55 + 55), AdaptedHeight(84))];
        [_exitBtn setBackgroundImage:[[[UIImage imageWithColor:kMainThemeColor] imageByResizeToSize:_exitBtn.size] imageByRoundCornerRadius:_exitBtn.height/2.0] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(exitQueue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

@end
