//
//  KMMyMessageVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMyMessageVC.h"
#import "KMSegmentView.h"
#import "KMMyMessageVM.h"
#import "KMPlatformMsgCell.h"
#import "KMRecoveryMsgCell.h"

#import "KMRemindMsgCell.h"

#import "KMMessageDetailVC.h"//消息详情
#import "KMReplyDetailVC.h"//回复详情

#import "WZLBadgeImport.h"

@interface KMMyMessageVC ()<KMSegmentViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMSegmentView * segment;

@property (nonatomic, strong) KMMyMessageVM * viewModel;

@property (nonatomic, strong) UIScrollView * content;

@property (nonatomic, strong) UITableView * remindTableView;

@property (nonatomic, strong) UITableView * dtTabelView;

//@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMMyMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.segment setSelectedIndex:0];
}

#pragma mark - Private Method -

//消息提醒有分页刷新
-(void)remindTableViewAddRefresh{
    @weakify(self)
    self.remindTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.viewModel.currentPage = 1;
        [self.viewModel.remindInfoCommand execute:nil];
    }];
    self.remindTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.viewModel.currentPage ++;
        [self.viewModel.remindInfoCommand execute:nil];
    }];
}

-(void)remindTableViewEndRefresh {
    if ([self.remindTableView.mj_header isRefreshing]) {
        [self.remindTableView.mj_header endRefreshing];
    }
    if ([self.remindTableView.mj_footer isRefreshing]) {
        [self.remindTableView.mj_footer endRefreshing];
    }
}

//跳转到回复详情
-(void)pushReplyDetailVCWithMessageID:(NSString *)messageID{
    if (messageID.length == 0) {
        //没有messageID
        [SVProgressHUD showErrorWithStatus:@"缺少MessageID" Duration:1];
        return;
    }
    //添加浏览记录
//    RACTuple * t                  = RACTuplePack(messageID, @(2));
//    [_viewModel.addBrowsingHistoryCommand execute:t];
    
    //跳转回复详情
    KMReplyDetailVC *vc           = [[KMReplyDetailVC alloc] init];
    vc.messageID                  = messageID;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

//跳转到消息详情
-(void)pushMessageDetailVCWithMessageID:(NSString *)messageID{
    if (messageID.length == 0) {
        //没有messageID
        [SVProgressHUD showErrorWithStatus:@"缺少MessageID" Duration:1];
        return;
    }
    
    //添加浏览记录
//    RACTuple * t                  = RACTuplePack(messageID, @(0));
//    [_viewModel.addBrowsingHistoryCommand execute:t];

    //跳转消息详情H5
    NSString *userID              = KMUserDefault.userID;
    //http://www.paihao123.com/mobliarticle.html?messageId=11&userId = sdsds
    KMMessageDetailVC *vc         = [[KMMessageDetailVC alloc] init];
    vc.messageUrl                 = NSStringFormat(@"http://www.paihao123.com/mobliarticle.html?messageId=%@&userId=%@",messageID,userID);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshUnreadCount{
    @weakify(self)
    //排号提醒
    [[_viewModel.remindNumberCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIButton *remindBtn = [self.segment.btns firstObject];
        UILabel *remindLbl = remindBtn.titleLabel;
        [remindLbl showBadgeWithStyle:WBadgeStyleNumber value:self.viewModel.remindNumber animationType:WBadgeAnimTypeNone];
    }];
    
    //动态消息
    [[_viewModel.dtNumberCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIButton *dtBtn = [self.segment.btns objectAtIndex:1];
        UILabel *dtLbl = dtBtn.titleLabel;
        [dtLbl showBadgeWithStyle:WBadgeStyleNumber value:self.viewModel.dtNumber animationType:WBadgeAnimTypeNone];
    }];
}

-(UITableViewCell *)configRemindTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //隐藏分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    KMRemindMsgCell *rCell = [tableView dequeueReusableCellWithIdentifier:[KMRemindMsgCell cellID]];
    KMRemindMsgModel *rModel = [self.viewModel.queueRemindArr objectAtIndex:indexPath.section];
    [rCell km_bindData:rModel];
    
    //cell的事件
    //删除
    @weakify(self, rModel)
    [[rCell.closeSubject takeUntil:rCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self, rModel)
        NSString *ID = NSStringFormat(@"%ld",rModel.ID);
        [[self.viewModel.deleteRemindCommand execute:ID] subscribeNext:^(id  _Nullable x) {
            [self.viewModel deleRemindMessage:rModel.ID];
            [self.remindTableView reloadData];
        }];
    }];
    
    return rCell;
}

-(UITableViewCell *)configDtTMsgTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //显示分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSInteger index = indexPath.section - _viewModel.recoveryMsgArr.count;
    if (index < 0) {
        //回复的消息
        
        KMRecoveryMsgCell *rCell      = [tableView dequeueReusableCellWithIdentifier:[KMRecoveryMsgCell cellID]];
        KMRecoveryMsgModel *rModel    = [_viewModel.recoveryMsgArr objectAtIndex:indexPath.section];
        [rCell km_bindData:rModel];
        
        //cell的事件
        @weakify(self, rModel)
        [[rCell.moreSubject takeUntil:rCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self, rModel)
            //查看回复详情
            [self pushReplyDetailVCWithMessageID:rModel.messageId];
        }];
        [[rCell.closeSuject takeUntil:rCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self, rModel)
//            [[self.viewModel.deleteRemindCommand execute:rModel.messageId] subscribeNext:^(id  _Nullable x) {
//                @strongify(self)
//                [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationBottom];
//            }];
            //添加浏览记录
            //    RACTuple * t                  = RACTuplePack(rModel.messageId, @(2));
            //                    [self.viewModel.addBrowsingHistoryCommand execute:t];
        }];
        return rCell;
    }else{
        //系统的消息
        KMPlatformMsgCell *pCell      = [tableView dequeueReusableCellWithIdentifier:[KMPlatformMsgCell cellID]];
        KMPlatformMsgModel *pModel    = [_viewModel.platformMsgArr objectAtIndex:index];
        [pCell km_bindData:pModel];
        
        //cell的事件
        @weakify(self, pModel)
        [[pCell.closeSuject takeUntil:pCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self, pModel)

        }];
        return pCell;
    }
}




#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count               = 0;
    count = [tableView isEqual:self.remindTableView] ? _viewModel.queueRemindArr.count : _viewModel.platformMsgArr.count + _viewModel.recoveryMsgArr.count;
//    switch (self.viewModel.msgType) {
//        case KMMyMsgTypeQueue:
//    count                         = _viewModel.queueRemindArr.count;
//            break;
//        case KMMyMsgTypeDynamic:
//    count                         = _viewModel.platformMsgArr.count + _viewModel.recoveryMsgArr.count;
//            break;
//        default:
//            break;
//    }
    return count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.remindTableView]) {
        return [self configRemindTabelView:tableView indexPath:indexPath];
    }
    return [self configDtTMsgTabelView:tableView indexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (self.viewModel.msgType) {
        case KMMyMsgTypeQueue:{//提醒消息

        }
            break;
        case KMMyMsgTypeDynamic:{//动态消息
    NSInteger index               = indexPath.section - _viewModel.recoveryMsgArr.count;
            if (index < 0) {
                //回复的消息
    KMRecoveryMsgModel *rModel    = [_viewModel.recoveryMsgArr objectAtIndex:indexPath.section];
                //查看回复详情
                [self pushReplyDetailVCWithMessageID:rModel.messageId];
            }else{
                //系统的消息
    KMPlatformMsgModel *pModel    = [_viewModel.platformMsgArr objectAtIndex:index];
                //查看消息详情
                [self pushMessageDetailVCWithMessageID:pModel.ID];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - KMSegmentViewDelegate -
-(void)segmentViewDidClick:(NSInteger)index{
    self.viewModel.msgType        = index;
    [self.content setContentOffset:CGPointMake(index * self.content.width, 0) animated:YES];
    [self km_refreshData];
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"我的消息");
}
#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.content];
    [self.content addSubview:self.remindTableView];
    [self.content addSubview:self.dtTabelView];
    [self.view addSubview:self.segment];
    
    [self remindTableViewAddRefresh];
}

-(void)km_refreshData{
    switch (self.viewModel.msgType) {
        case KMMyMsgTypeQueue:{
            [self.viewModel.remindInfoCommand execute:nil];
        }
            break;
        case KMMyMsgTypeDynamic:{
            [self.viewModel.dtMsgCommand execute:nil];
        }
            break;
        default:
            break;
    }
}

-(void)km_requestData{
    [self refreshUnreadCount];
}

-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            [self remindTableViewEndRefresh];
            [self.remindTableView reloadData];
            [self.dtTabelView reloadData];
        });
    }];
    
    [_viewModel.deleteRemindCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self refreshUnreadCount];
    }];
    
    [self.viewModel.remindInfoCommand.errors subscribeNext:^(NSError * _Nullable x) {
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            [self remindTableViewEndRefresh];
            [self.remindTableView reloadData];
            [self.dtTabelView reloadData];
        });
    }];
    
//    [_viewModel.addBrowsingHistoryCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [self refreshUnreadCount];
//    }];
}

#pragma mark - Lazy -
-(KMSegmentView *)segment{
    if (!_segment) {
    _segment                      = [[KMSegmentView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, 50)
                                                Titles:@[@"排号提醒", @"动态消息"]
                                      VerticalLineShow:YES];
    _segment.delegate             = self;
        
        UIButton *remindBtn = _segment.btns.firstObject;
        UILabel *remindLbl = remindBtn.titleLabel;
        remindLbl.badgeBgColor = kAppRedColor;
        remindLbl.badgeTextColor = [UIColor whiteColor];
        remindLbl.badgeFont = kFont22;
        remindLbl.badgeCenterOffset = CGPointMake(4, 0);
        [remindLbl setBadgeMaximumBadgeNumber:99];
        [remindLbl clearBadge];
        
        UIButton *dtBtn = [_segment.btns objectAtIndex:1];
        UILabel *dtLbl = dtBtn.titleLabel;
        dtLbl.badgeBgColor = kAppRedColor;
        dtLbl.badgeTextColor = [UIColor whiteColor];
        dtLbl.badgeFont = kFont22;
        dtLbl.badgeCenterOffset = CGPointMake(4, 0);
        [dtLbl setBadgeMaximumBadgeNumber:99];
        [dtLbl clearBadge];
        
    }
    return _segment;
}
-(KMMyMessageVM *)viewModel{
    if (!_viewModel) {
    _viewModel                    = [[KMMyMessageVM alloc]init];
    }
    return _viewModel;
}

-(UIScrollView *)content{
    if (!_content) {
        _content = [[UIScrollView alloc]initWithFrame:CGRectMake(
                                                                 0,
                                                                 self.segment.bottom,
                                                                 KScreenWidth,
                                                                 KScreenHeight - self.segment.bottom
                                                                 )];
        _content.contentSize = CGSizeMake(2*_content.width, _content.height);
        _content.scrollEnabled = NO;
    }
    return _content;
}

-(UITableView *)remindTableView {
    if (!_remindTableView) {
        UITableView *tb = [[UITableView alloc]initWithFrame:self.content.bounds style:UITableViewStyleGrouped];
        tb.backgroundColor = self.view.backgroundColor;
        tb.delegate = self;
        tb.dataSource = self;
        tb.estimatedRowHeight = 200;
        [tb registerClass:[KMRemindMsgCell class] forCellReuseIdentifier:[KMRemindMsgCell cellID]];
        _remindTableView = tb;
    }
    return _remindTableView;
}

-(UITableView *)dtTabelView {
    if (!_dtTabelView) {
        UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(self.content.width, 0, self.content.width, self.content.height) style:UITableViewStyleGrouped];
        tb.backgroundColor = self.view.backgroundColor;
        tb.delegate = self;
        tb.dataSource = self;
        tb.estimatedRowHeight = 200;
        [tb registerClass:[KMPlatformMsgCell class] forCellReuseIdentifier:[KMPlatformMsgCell cellID]];
        [tb registerClass:[KMRecoveryMsgCell class] forCellReuseIdentifier:[KMRecoveryMsgCell cellID]];
        _dtTabelView = tb;
    }
    return _dtTabelView;
}

//-(UITableView *)tableView{
//    if (!_tableView) {
//    _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, self.segment.bottom, KScreenWidth, KScreenHeight - self.segment.bottom) style:UITableViewStyleGrouped];
//    _tableView.backgroundColor    = self.view.backgroundColor;
//    _tableView.delegate           = self;
//    _tableView.dataSource         = self;
//        [_tableView registerClass:[KMPlatformMsgCell class] forCellReuseIdentifier:[KMPlatformMsgCell cellID]];
//        [_tableView registerClass:[KMRecoveryMsgCell class] forCellReuseIdentifier:[KMRecoveryMsgCell cellID]];
//        [_tableView registerClass:[KMRemindMsgCell class] forCellReuseIdentifier:[KMRemindMsgCell cellID]];
//    _tableView.estimatedRowHeight = 200;
//    }
//    return _tableView;
//}
@end
