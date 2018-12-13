//
//  KMGroupCallController.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupCallController.h"
#import "KMGroupCallViewModel.h"

#import "KMGroupInfoCell.h"//号群信息
#import "KMGroupWaitInfoCell.h"//单人等待信息
#import "KMGroupQueueDataCell.h"//排队信息
#import "KMBatchWaitInfoCell.h"//批量等待信息


#import "FTPopOverMenu.h" //右上角菜单

#import "KMBluetoothManager.h"//蓝牙管理
#import "KMBluetoothPrinter.h"//蓝牙打印

#import "KMFindPrinterVC.h"//查找打印机

#import <ActionSheetPicker_3_0/ActionSheetStringPicker.h>




@interface KMGroupCallController ()<UITableViewDelegate, UITableViewDataSource>

/** 过号 按钮 */
@property (nonatomic, strong) UIButton * missBtn;
/** 呼叫当前 按钮 */
@property (nonatomic, strong) UIButton * callCurrentBtn;
/** 下一位 按钮 */
@property (nonatomic, strong) UIButton * nextBtn;
/** 暂存按钮 */
@property (nonatomic, copy) NSArray * btns;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMGroupCallViewModel * viewModel;

@end

@implementation KMGroupCallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.viewModel.selectWindowID == nil) {
        //没选择窗口
        [self.viewModel.bindedWinCommand execute:self.groupID];
    }else {
        //已经有绑定的窗口
        [self refreshQueueData];
    }
}


#pragma mark - Push -
-(void)pushPrinterFindVC{
    KMFindPrinterVC *vc = [[KMFindPrinterVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - Private Method -


#pragma mark Action
//处理窗口
-(void)handleWindow{
//    if (_viewModel.selectWindowID) {
//        //已经有绑定的窗口
//        [self refreshQueueData];
//        return;
//    }
    if (_viewModel.bindedWinArr.count == 0) {
       //该号群没有可以绑定的窗口
        [self refreshQueueData];
    }else {
        //选择窗口
        [self showWindowPicker];
    }
}
//选择窗口
-(void)showWindowPicker{
    NSArray * winNameArr = [[_viewModel.bindedWinArr.rac_sequence map:^id _Nullable(KMWindowInfo * value) {
        return value.windowName ? value.windowName : @"";
    }] array];
    @weakify(self)
    [ActionSheetStringPicker showPickerWithTitle:@"选择窗口" rows:winNameArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        if (selectedValue) {
            //选择了才刷新
            KMWindowInfo *info = [self.viewModel.bindedWinArr objectAtIndex:selectedIndex];
            [[self.viewModel.bindCallWindow execute:info.ID] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                //绑定窗口成功
                self.viewModel.selectWindowID = info.ID;
                self.viewModel.selectWindowName = info.windowName;
                //有了窗口之后 刷新排队信息
                [self refreshQueueData];
            }];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        @strongify(self)
        //点击“呼叫“按钮的时候，在弹出的选择窗口中如果没选窗口时，点”取消“就直接返回号群详情页，这个能不能也帮忙改一下？
        [self.navigationController popViewControllerAnimated:YES];
    } origin:self.view];
}
//刷新排队信息
-(void)refreshQueueData{

    _singleNumber == 0 ? [_viewModel.requestQueueData execute:@(QueueReloadStatusNoCall)] : [_viewModel.batchQueueDataCommand execute:@(NO)];
}

//是否该选择窗口
-(BOOL)checkWindowSelect{
    //号群有绑定的窗口 且 没选中窗口时
    if (_viewModel.bindedWinArr.count != 0 && _viewModel.selectWindowID == nil) {
        [self handleWindow];
        return NO;
    }
    //当前没有人排队
    if (![_viewModel checkQueueExist]) {
        return NO;
    }
    return YES;
}

//暂停当前排号
-(void)suspendQueue{
    //要先选择窗口
    if ([self checkWindowSelect]) {
        if (_singleNumber == 0) {
            KMQueueDataModel *model = [self.viewModel.queueArr firstObject];
            [self.viewModel.pauseCommand execute:model.Id];
        }else{
            NSArray *ids = [[self.viewModel.queueArr.rac_sequence map:^id _Nullable(KMQueueDataModel * q) {
                return q.Id;
            }] array];
            NSString *idsString = [ids componentsJoinedByString:@"###"];
            [self.viewModel.batchSuspendCommand execute:idsString];
        }
    }
}
//现场排号
-(void)sceneQueue{
    //可以打印
    if ([KMBluetoothManager canPrint]) {
        [SVProgressHUD showWithStatus:@"正在获取排队信息..."];
        [self.viewModel.sceneQueueCommand execute:nil];
    }else{
        //不能打印
        [self pushPrinterFindVC];
    }
}

//解散号群
-(void)dissolveGroup{
    @weakify(self)
    [LBXAlertAction showAlertWithTitle:@"提示" msg:@"解散和未办完退出，直接影响用户体验，会影响你的信用值，信用值过低，可能会被暂时封号，请谨慎操作，建议你叫完号，排小二代表用户谢谢你了！" buttonsStatement:@[@"确认解散", @"返回"] chooseBlock:^(NSInteger buttonIdx) {
        @strongify(self)
        if (buttonIdx == 0) {
            [self.viewModel.dissolveCommand execute:self.groupID];
        }
    }];
}

//打印
-(void)printWithInfo:(KMTicketInfo *)info{
    //可以打印
    if ([KMBluetoothManager canPrint]) {
        KMBluetoothManager *manager               = [KMBluetoothManager sharedInstance];
        
        KMBluetoothPrinter *printer               = [[KMBluetoothPrinter alloc]init];
        [printer appendSeperatorLine];
        [printer appendText:info.groupname alignment:KM_TextAlignmentCenter fontSize:KM_FontSizeTitleMiddle];
        [printer appendText:@"竭诚为您服务" alignment:KM_TextAlignmentCenter];
        [printer appendNewLine];
        [printer appendText:NSStringFormat(@"您的业务是：%@",info.groupname) alignment:KM_TextAlignmentLeft];
        [printer appendText:NSStringFormat(@"您的票号是：%@",info.shanxi) alignment:KM_TextAlignmentLeft];
        [printer appendText:NSStringFormat(@"您的前面有：%@人",info.waitcount) alignment:KM_TextAlignmentLeft];
        [printer appendText:NSStringFormat(@"预计时间有：%@分钟",info.waittime) alignment:KM_TextAlignmentLeft];
        [printer appendText:NSStringFormat(@"排队的窗口：%@",info.windows) alignment:KM_TextAlignmentLeft];
        NSString *dateStr                         = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        [printer appendText:dateStr alignment:KM_TextAlignmentLeft];
        
        [printer appendNewLine];
        [printer appendText:@"当日有效，呼叫3次未到请重新排队" alignment:KM_TextAlignmentCenter fontSize:KM_FontSizeTitleSmalle];
        
        NSString *tips                            = @"排号网提醒您：您可关注排号网公众号或下载APP，搜索号群或ID，就可以用手机代您排队了，并有实时提醒，排队再也不用现场苦等了。";
        
        [printer appendText:tips alignment:KM_TextAlignmentLeft fontSize:KM_FontSizeTitleSmalle];
        [printer appendNewLine];
        [printer appendNewLine];
        [printer appendSeperatorLine];
        [printer appendNewLine];
        NSData *mainData                          = [printer finalPrinterData];
        
        for (int i                                = 0; i < [KMBluetoothManager printCount]; i ++) {
            [manager sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
                if (completion) {
                    [SVProgressHUD showSuccessWithStatus:@"打印成功" Duration:1];
                    KMLog(@"打印成功");
                }else{
                    [SVProgressHUD showErrorWithStatus:@"打印失败" Duration:1];
                    KMLog(@"写入错误---:%@",error);
                }
            }];
        }
    }else{
        //不能打印
        [self pushPrinterFindVC];
    }
}


#pragma mark - Layout

//设置导航栏右侧按钮
-(void)setNavRightButton{
    UIButton *btn                             = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:IMAGE_NAMED(@"caidan") forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [btn addTarget:self action:@selector(menuBarButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item                     = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:item];
}
//设置单人呼叫按钮
-(void)setupSingleButtons{
    _missBtn                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    _callCurrentBtn                           = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btns                         = @[_missBtn, _callCurrentBtn, _nextBtn];
    NSArray * titles                          = @[@"过号", @"呼叫当前", @"下一位"];
    NSArray * colors                          = @[@"ffbe12", @"7687ef", @"34b87f"];
    
    for (int i                                = 0; i < _btns.count; i ++) {
        UIButton *btn                             = _btns[i];
        NSString *title                           = titles[i];
        UIColor *color                            = HEXCOLOR(colors[i]);
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font                       = kFont32;
        [btn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }

    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:AdaptedWidth(30) leadSpacing:AdaptedWidth(30) tailSpacing:AdaptedWidth(30)];
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.bottom).offset(AdaptedHeight(-28));
        make.height.mas_equalTo(AdaptedHeight(84));
    }];
}
//设置批量呼叫按钮
-(void)setupBatchButtons{
//    _missBtn                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    _callCurrentBtn                           = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btns                         = @[_callCurrentBtn, _nextBtn];
    NSArray * titles                          = @[@"呼叫当前", @"下一批"];
    NSArray * colors                          = @[@"7687ef", @"34b87f"];
    
    for (int i                                = 0; i < _btns.count; i ++) {
        UIButton *btn                             = _btns[i];
        NSString *title                           = titles[i];
        UIColor *color                            = HEXCOLOR(colors[i]);
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font                       = kFont32;
        [btn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:AdaptedWidth(116) leadSpacing:AdaptedWidth(98) tailSpacing:AdaptedWidth(116)];
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.bottom).offset(AdaptedHeight(-28));
        make.height.mas_equalTo(AdaptedHeight(84));
    }];
}

-(void)menuBarButtonTap:(UIButton *)btn{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight               = AdaptedHeight(83);
    configuration.menuWidth                   = AdaptedWidth(174);
    configuration.textColor                   = [UIColor whiteColor];
    configuration.textFont                    = kFont30;
    configuration.tintColor                   = kMainThemeColor;
    configuration.borderColor                 = [UIColor clearColor];
    configuration.borderWidth                 = 0.5;
    configuration.menuIconMargin              = AdaptedWidth(24);

    @weakify(self)
    [FTPopOverMenu showForSender:btn withMenuArray:@[@"暂停", @"排号", @"解散"] imageArray:@[IMAGE_NAMED(@"zanting"), IMAGE_NAMED(@"paihaowang"), IMAGE_NAMED(@"jiesan")] doneBlock:^(NSInteger selectedIndex) {
        @strongify(self)
        if (selectedIndex == 0) {
            //暂停当前排号
            [self suspendQueue];
        }else if (selectedIndex == 1){
            //现场排号
            [self sceneQueue];
        }else if (selectedIndex == 2){
            //解散号群
            [self dissolveGroup];
        }
    } dismissBlock:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return  [_viewModel.queueArr count];
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height                            = 0;
    switch (indexPath.section) {
        case 0:
    height                                    = [KMGroupInfoCell cellHeight];
            break;
        case 1:
            height                                    = _viewModel.singleNumber == 0 ? [KMGroupWaitInfoCell cellHeight] : [KMBatchWaitInfoCell cellHeight];
            break;
        case 2:
    height                                    = [KMGroupQueueDataCell cellHeight];
            break;
        default:
            break;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self km_configTableCellWithIndexPath:indexPath];
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self setNavRightButton];
    
    //设置按钮
    _singleNumber == 0 ? [self setupSingleButtons] : [self setupBatchButtons];

    [self.view addSubview:self.tableView];
}

-(void)km_layoutSubviews{
    for (UIButton *btn in _btns) {
        [btn layoutIfNeeded];
        [btn setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
    }
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}


-(void)km_refreshData{
    _singleNumber == 0 ? [_viewModel.detailCommand execute:nil] : [_viewModel.batchQueueDataCommand execute:@(NO)];
}

-(void)km_bindViewModel{
    @weakify(self)
    
    [self.viewModel.bindedWinCommand.executionSignals.flatten subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //处理窗口
        [self handleWindow];
    }];
    
    [self.viewModel.nextCommand.executionSignals.flatten subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self refreshQueueData];
    }];
    
    [self.viewModel.expireCommand.executionSignals.flatten subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self refreshQueueData];
    }];
    
    [self.viewModel.dissolveCommand.executionSignals.flatten subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.viewModel.sceneQueueCommand.executionSignals.flatten subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self refreshQueueData];
    }];
    
    [self.viewModel.requestQueueData.executionSignals.flatten subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];

    //更新号群详情
//    [self.viewModel.detailCommand.executionSignals.flatten subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//       // [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
//    }];

    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            [self.tableView reloadData];
        });
    }];

//    [self.viewModel.refreshSubject subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [self km_refreshData];
//    }];

    [self.viewModel.printSubject subscribeNext:^(id  _Nullable x) {
        KMLog(@"票据信息 =====  %@",x);
        @strongify(self)
        [self printWithInfo:x];
    }];
}
-(void)km_bindEvent{
    @weakify(self)
    if (_singleNumber == 0) {
        //单人
        [[_missBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if ([self checkWindowSelect]) {
                KMQueueDataModel *model                   = self.viewModel.queueArr.firstObject;
                NSString *curQueueID                      = model.Id;
                NSString *groupID                         = self.groupID;
                RACTuple *tuple                           = RACTuplePack(curQueueID, groupID);
                [[self.viewModel.expireCommand execute:tuple] subscribeNext:^(id  _Nullable x) {
                    @strongify(self)
                    if (![model.packageId isEqualToString:@"0"]) {
                        [self.viewModel.packageQueueCommand execute:model];
                    }
                }];
            }
        }];
        [[_callCurrentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if ([self checkWindowSelect]) {
                KMQueueDataModel *model                   = self.viewModel.queueArr.firstObject;
                NSString *curQueueID                      = model.Id;
                [self.viewModel.callCommand execute:curQueueID];
            }
        }];
        [[_nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if ([self checkWindowSelect]) {
                KMQueueDataModel *model                   = self.viewModel.queueArr.firstObject;
                NSString *curQueueID                      = model.Id;
                NSString *groupID                         = self.groupID;
                RACTuple *tuple                           = RACTuplePack(curQueueID, groupID);
                [[self.viewModel.nextCommand execute:tuple] subscribeNext:^(id  _Nullable x) {
                    @strongify(self)
                    if (![model.packageId isEqualToString:@"0"]) {
                        [self.viewModel.packageQueueCommand execute:model];
                    }
                }];
            }
        }];
    }else{
        //批量
        [[_callCurrentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if ([self checkWindowSelect]) {
                //批量呼叫
                NSArray *ids = [[self.viewModel.queueArr.rac_sequence map:^id _Nullable(KMQueueDataModel * q) {
                    return NSStringFormat(@"'%@'",q.Id);
                }] array];
                NSString *idsString = [ids componentsJoinedByString:@","];
                [self.viewModel.callCommand execute:idsString];
            }
        }];
        [[_nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if ([self checkWindowSelect]) {
                //下一批
                NSArray *ids = [[self.viewModel.queueArr.rac_sequence map:^id _Nullable(KMQueueDataModel * q) {
                    return q.Id;
                }] array];
                NSString *idsString = [ids componentsJoinedByString:@"###"];
                //结束上一批
                [self.viewModel.batchEndLastCommand execute:idsString];
            }
        }];
    }
}

-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell                    = nil;
    switch (indexPath.section) {
        case 0:{
            KMGroupInfoCell *infoCell = [_tableView dequeueReusableCellWithIdentifier:[KMGroupInfoCell cellID]];
            [infoCell km_bindData:_viewModel.detailInfo];
            @weakify(self)
            [[infoCell.QRSubject takeUntil:infoCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [KMUserManager pushQRCodeVCWithData:self.viewModel.detailInfo];
            }];
            cell = infoCell;
        }
            break;
        case 1:{
            if (_viewModel.singleNumber == 0) {
                //单人
                KMGroupWaitInfoCell *waitCell = [_tableView dequeueReusableCellWithIdentifier:[KMGroupWaitInfoCell cellID]];
                [waitCell km_bindData:_viewModel.detailInfo];
                cell = waitCell;
            }else{
                //批量
                KMBatchWaitInfoCell *bCell = [_tableView dequeueReusableCellWithIdentifier:[KMBatchWaitInfoCell cellID]];
                RACTuple *t = RACTuplePack(_viewModel.currentHandle ? _viewModel.currentHandle : @"", _viewModel.waitingCount ? _viewModel.waitingCount : @"", _viewModel.waitingTime ? _viewModel.waitingTime : @"");
                [bCell km_bindData:t];
                cell = bCell;
            }
        }
            break;
        case 2:{
            KMGroupQueueDataCell *queueCell = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupQueueDataCell cellID]];
            queueCell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : [UIColor clearColor];
            if (self.viewModel.queueArr.count > 0) {
                KMQueueDataModel *model = [self.viewModel.queueArr objectAtIndex:indexPath.row > self.viewModel.queueArr.count - 1 ? self.viewModel.queueArr.count - 1 : indexPath.row];

                (self.viewModel.selectWindowName && indexPath.row == 0)?model.windowName = self.viewModel.selectWindowName :nil;

                [queueCell km_bindData:model];
            }

            
//            if ((_viewModel.singleNumber == 0 && indexPath.row == 0 && [queueCell.windowLbl.text isEqualToString:@"等待中"]) || _viewModel.singleNumber != 0) {
//                queueCell.windowLbl.text = self.viewModel.selectWindowName ? self.viewModel.selectWindowName : @"办理中";
//                queueCell.windowLbl.textColor = kMainThemeColor;
//            }

            if (_viewModel.singleNumber > 0) {
                queueCell.windowLbl.text = self.viewModel.selectWindowName ? self.viewModel.selectWindowName : @"办理中";
                queueCell.windowLbl.textColor = kMainThemeColor;
            }else{
                queueCell.windowLbl.text = @"等待中";
                queueCell.windowLbl.textColor = kFontColorBlack;
            }
            if (indexPath.row == 0) {
                queueCell.windowLbl.text = self.viewModel.selectWindowName ? self.viewModel.selectWindowName : @"办理中";
                queueCell.windowLbl.textColor = kMainThemeColor;
            }

            [queueCell km_setSeparatorLineInset:UIEdgeInsetsZero];
            cell = queueCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                                = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - AdaptedHeight(84 + 28 + 28)) style:UITableViewStyleGrouped];
    _tableView.delegate                       = self;
    _tableView.dataSource                     = self;
    _tableView.backgroundColor                = [UIColor clearColor];
        [_tableView registerClass:[KMGroupInfoCell class] forCellReuseIdentifier:[KMGroupInfoCell cellID]];
        
        [_tableView registerClass:[KMGroupWaitInfoCell class] forCellReuseIdentifier:[KMGroupWaitInfoCell cellID]];
        
        [_tableView registerClass:[KMGroupQueueDataCell class] forCellReuseIdentifier:[KMGroupQueueDataCell cellID]];
        
        [_tableView registerClass:[KMBatchWaitInfoCell class] forCellReuseIdentifier:[KMBatchWaitInfoCell cellID]];
    }
    return _tableView;
}
-(KMGroupCallViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel = [[KMGroupCallViewModel alloc]init];
    _viewModel.groupID = self.groupID;
    _viewModel.detailInfo = self.detailInfo;
    _viewModel.singleNumber = self.singleNumber;
    }
    return _viewModel;
}
@end
