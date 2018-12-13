//
//  KMGroupDetailController.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupDetailController.h"

#import "KMGroupDetailViewModel.h"

#import "KMGroupInfoCell.h"
#import "KMGroupWaitInfoCell.h"
#import "KMGroupAddressCell.h"
#import "KMGroupSynopsisCell.h"

#import "KMNewGroupController.h"
#import "KMGroupCallController.h"
#import "KMSettingWindowController.h"
#import "KMGroupContinueController.h"
@interface KMGroupDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMGroupDetailViewModel * viewModel;

@property (nonatomic, strong) UITableView * tableView;
/** 续建按钮 */
@property (nonatomic, strong) UIButton * continueBtn;
/** 窗口设置 */
@property (nonatomic, strong) UIButton * settingBtn;
/** 呼叫 */
@property (nonatomic, strong) UIButton * callBtn;
@end

@implementation KMGroupDetailController
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
-(void)pushGroupCallVC{
    if (self.viewModel.detailInfo) {
    KMGroupCallController * vc            = [[KMGroupCallController alloc]init];
    vc.groupID                            = self.viewModel.groupID;
    vc.detailInfo                         = self.viewModel.detailInfo;
    vc.singleNumber = self.singlenumber;
    [self.navigationController cyl_pushViewController:vc animated:YES];
    }
}
-(void)pushSettingWindowVC{
    KMSettingWindowController * window      = [[KMSettingWindowController alloc]init];
    window.groupID                          = self.groupID;
    [self.navigationController cyl_pushViewController:window animated:YES];
}

-(void)pushContinueVC{
    KMGroupContinueController *vc           = [[KMGroupContinueController alloc]init];
    vc.groupID                              = self.groupID;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pushEditVC{
    KMNewGroupController *vc                = [[KMNewGroupController alloc]init];
    vc.groupID                              = self.groupID;
    vc.titleStr                             = @"编辑队列";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Method
-(void)setupNavRightButton{

    UIButton *editBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateHighlighted];
    editBtn.frame                           = CGRectMake(0, 0, 30, 44);
    [editBtn addTarget:self action:@selector(editGroup) forControlEvents:UIControlEventTouchUpInside];

    UIButton *deleBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleBtn setImage:[UIImage imageNamed:@"sanchue"] forState:UIControlStateNormal];
    [deleBtn setImage:[UIImage imageNamed:@"sanchue"] forState:UIControlStateHighlighted];
    deleBtn.frame                           = CGRectMake(0, 0, 30, 44);
    [deleBtn addTarget:self action:@selector(deleGroup) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item1                  = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    UIBarButtonItem *item2                  = [[UIBarButtonItem alloc]initWithCustomView:deleBtn];

    //调整按钮位置
    UIBarButtonItem* spaceItem              = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width                         = -5;

    self.navigationItem.rightBarButtonItems = @[spaceItem, item1, item2];
}
/** 删除队列 */
-(void)deleGroup{
    @weakify(self)
    [LBXAlertAction showAlertWithTitle:@"提示" msg:@"确认删除此队列？" buttonsStatement:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx == 1) {
            @strongify(self)
            [[self.viewModel.deleGroupCommand execute:self.groupID] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
}
/** 编辑队列 */
-(void)editGroup{
    [self pushEditVC];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.viewModel.detailInfo) {
        return 0;
    }
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count                         = 0;
    switch (section) {
        case 0:
    count                                   = 1;
            break;
        case 1:
    count                                   = 1;
            break;
        case 2:
    count                                   = 2;
            break;
        case 3:
    count                                   = 1;
        default:
            break;
    }
    return count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height                          = 0;
    switch (indexPath.section) {
        case 0:
    height                                  = [KMGroupInfoCell cellHeight];
            break;
        case 1:
    height                                  = [KMGroupWaitInfoCell cellHeight];
            break;
        case 2:
    height                                  = [KMGroupAddressCell cellHeight];
            break;
        case 3:
    height                                  = UITableViewAutomaticDimension;
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

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"队列详情");
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self setupNavRightButton];
    [self.view addSubview:self.tableView];

    _continueBtn                            = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
    _callBtn                                = [UIButton buttonWithType:UIButtonTypeCustom];

    NSArray * buttons                       = @[_continueBtn, _settingBtn, _callBtn];
    NSArray * titles                        = @[@"续建", @"窗口设置", @"呼叫"];
    NSArray * colors                        = @[@"ffbe12", @"7687ef", @"34b87f"];

    for (int i                              = 0; i < buttons.count; i ++) {
    UIButton *btn                           = buttons[i];
    NSString *title                         = titles[i];
    UIColor *color                          = HEXCOLOR(colors[i]);

        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font                     = kFont32;
        [btn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
}
-(void)km_refreshData{
    [self.viewModel.detailCommand execute:nil];
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

-(void)km_bindEvent{
    @weakify(self)
    [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushGroupCallVC];
    }];
    [[_settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushSettingWindowVC];
    }];
    [[_continueBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushContinueVC];
    }];
}

-(void)km_layoutSubviews{

    NSArray *buttons                        = @[_continueBtn, _settingBtn, _callBtn];

    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:AdaptedWidth(30) leadSpacing:AdaptedWidth(30) tailSpacing:AdaptedWidth(30)];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(self.view.bottom).offset(AdaptedHeight(-28));
       make.height.mas_equalTo(AdaptedHeight(84));
    }];

    for (UIButton *btn in buttons) {
        [btn setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
    }
}

-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell                  = nil;
    switch (indexPath.section) {
        case 0:{
    KMGroupInfoCell *infoCell               = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupInfoCell cellID]];
            [infoCell km_bindData:self.viewModel.detailInfo];
            @weakify(self)
            [[infoCell.QRSubject takeUntil:infoCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [KMUserManager pushQRCodeVCWithData:self.viewModel.detailInfo];
            }];
    cell                                    = infoCell;
        }
            break;
        case 1:{
    KMGroupWaitInfoCell *waitCell           = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupWaitInfoCell cellID]];
            [waitCell km_bindData:self.viewModel.detailInfo];
    cell                                    = waitCell;
        }
            break;
        case 2:{
    KMGroupAddressCell *addressCell         = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupAddressCell cellID]];
            if (indexPath.row == 0) {
    addressCell.iconImg.image               = IMAGE_NAMED(@"dingwei1");
    addressCell.textLbl.text                = self.viewModel.detailInfo.groupaddress;
            }else if (indexPath.row == 1){
    addressCell.iconImg.image               = IMAGE_NAMED(@"dianhub");
    addressCell.textLbl.text                = [@"咨询电话: " stringByAppendingString:self.viewModel.detailInfo.phone];
            }
    cell                                    = addressCell;
        }
            break;
        case 3:{
    KMGroupSynopsisCell *synopsisCell       = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupSynopsisCell cellID]];
            [synopsisCell km_bindData:self.viewModel.detailInfo];
    cell                                    = synopsisCell;
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
    _tableView                              = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - AdaptedHeight(84 + 28 + 28)) style:UITableViewStyleGrouped];
    _tableView.delegate                     = self;
    _tableView.dataSource                   = self;
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.estimatedRowHeight           = 60.0;
        [_tableView registerClass:[KMGroupInfoCell class] forCellReuseIdentifier:[KMGroupInfoCell cellID]];
        [_tableView registerClass:[KMGroupWaitInfoCell class] forCellReuseIdentifier:[KMGroupWaitInfoCell cellID]];
        [_tableView registerClass:[KMGroupAddressCell class] forCellReuseIdentifier:[KMGroupAddressCell cellID]];
        [_tableView registerClass:[KMGroupSynopsisCell class] forCellReuseIdentifier:[KMGroupSynopsisCell cellID]];
    }
    return _tableView;
}
-(KMGroupDetailViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                              = [[KMGroupDetailViewModel alloc]init];
    _viewModel.groupID                      = self.groupID;
    }
    return _viewModel;
}


@end
