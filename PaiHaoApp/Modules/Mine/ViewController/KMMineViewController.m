//
//  KMMineViewController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMineViewController.h"
#import "KMMemberCenterViewModel.h"
#import "KMMemberInfoCell.h"
#import "KMMemberCenterCell.h"


#import "KMUserDetailController.h"      //普通用户详情
#import "KMMerchantDetailController.h"  //商户详情
#import "KMHistoryQueue.h"              //历史排队
#import "KMMyCollection.h"              //我的收藏
#import "KMMerchantServices.h"          //商户服务
#import "KMSettingController.h"         //设置
#import "KMUserFeedbackController.h"    //反馈
#import "KMApplyMerchantVC.h"           //申请成为商户
#import "KMBusinessUpgradeVC.h"         //商户升级
#import "KMMyMessageVC.h"               //我的消息
@interface KMMineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KMMemberCenterViewModel * viewModel;

@end

@implementation KMMineViewController
#pragma mark - Lift Cycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUserInfo];
}
#pragma mark - Privat Method -
-(UITableViewCell *)configCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell                             = nil;
    switch (indexPath.section) {
        case 0:{
            KMMemberInfoCell *infoCell                = [self.tableView dequeueReusableCellWithIdentifier:[KMMemberInfoCell cellID]];
            [infoCell km_bindData:self.viewModel.member];
            @weakify(self)
            [[infoCell.updateSubject takeUntil:infoCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                if ([self.viewModel checkCanUpdate]) {
                    if ([self.viewModel customerType] == KM_CustomerTypePersonal) {
                        //普通用户升级商户
                        [self pushApplyMerchantVC];
                    }else if ([self.viewModel customerType] == KM_CustomerTypeOrdinary){
                        //普通商户升级认证商户
                        [self pushBusinessUpgradeVC];
                    }
                }
            }];
            cell                                      = infoCell;
        }
            break;
        case 1:
        case 2:{
            KMMemberCenterCell *memberCell            = [self.tableView dequeueReusableCellWithIdentifier:[KMMemberCenterCell cellID]];
            [memberCell bindDataWithImgName:self.viewModel.imgNameArr[indexPath.section][indexPath.row]
                                       Text:self.viewModel.titleArr[indexPath.section][indexPath.row]];
            cell                                      = memberCell;
        }
            break;
        default:
            break;
    }
    return cell;
}
/** 刷新用户数据 */
-(void)refreshUserInfo{
    @weakify(self)
    [[self.viewModel.userInfoCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - Push -
#pragma mark 普通用户升级商户
-(void)pushApplyMerchantVC{
    KMApplyMerchantVC *vc                             = [[KMApplyMerchantVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
#pragma mark 普通商户升级认证商户
-(void)pushBusinessUpgradeVC{
    KMBusinessUpgradeVC *vc                           = [[KMBusinessUpgradeVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"会员中心");
}

#pragma mark - TableView Delegate && DataSource - 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.titleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr                                      = [self.viewModel.titleArr objectAtIndex:section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height                                    = 0;
    switch (indexPath.section) {
        case 0:
            height                                    = [KMMemberInfoCell cellHeight];
            break;
        case 1:
        case 2:
            height                                    = [KMMemberCenterCell cellHeight];
            break;
        default:
            break;
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height                                    = 0;
    switch (section) {
        case 0:
            height                                    = AdaptedHeight(70);
            break;
        case 1:
            height                                    = AdaptedHeight(35);
            break;
        case 2:
            height                                    = AdaptedHeight(20);
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell                             = [self configCellWithIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //数据还没请求下来
    if (self.viewModel.member == nil) {
        return;
    }
    UIViewController *vc                              = nil;
    if (indexPath.section == 0) {
        //根据不同的用户类型  进入不同的界面
        if (self.viewModel.customerType == KM_CustomerTypePersonal) {
            //普通用户详情
            KMUserDetailController *userDetail        = [[KMUserDetailController alloc]init];
            vc                                        = userDetail;
        }else{
            //商户详情
            KMMerchantDetailController *merchanDetail = [[KMMerchantDetailController alloc]init];
            vc                                        = merchanDetail;
        }
    }
    
    NSString *leftText                                = [[self.viewModel.titleArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([leftText isEqualToString:@"我的消息"]) {
        //我的消息
        KMMyMessageVC *message                        = [[KMMyMessageVC alloc]init];
        vc                                            = message;
    }else if ([leftText isEqualToString:@"历史排队"]) {
        //历史排队
        KMHistoryQueue *history                       = [[KMHistoryQueue alloc]init];
        vc                                            = history;
    }else if ([leftText isEqualToString:@"我的收藏"]){
        //我的收藏
        KMMyCollection *collection                    = [[KMMyCollection alloc]init];
        vc                                            = collection;
    }else if ([leftText isEqualToString:@"商户服务"]){
        //普通用户不能使用商户服务
        if ([self.viewModel customerType]            != KM_CustomerTypePersonal) {
        //商户服务
            KMMerchantServices *services              = [[KMMerchantServices alloc]init];
            services.customerType                     = [self.viewModel customerType];
            vc                                        = services;
        }else{
            [SVProgressHUD showInfoWithStatus:@"普通用户不能使用商户服务" Duration:1];
        }
    }else if ([leftText isEqualToString:@"设置"]){
        //设置
        KMSettingController *setting                  = [[KMSettingController alloc]init];
        vc                                            = setting;
    }else if ([leftText isEqualToString:@"用户反馈"]){
        //反馈
        KMUserFeedbackController *feedBack            = [[KMUserFeedbackController alloc]init];
        vc                                            = feedBack;
    }if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - kTabBarHeight) style:UITableViewStyleGrouped];
        
        [_tableView registerNib:[KMMemberInfoCell loadNib] forCellReuseIdentifier:[KMMemberInfoCell cellID]];
        [_tableView registerNib:[KMMemberCenterCell loadNib] forCellReuseIdentifier:[KMMemberCenterCell cellID]];
        
        _tableView.dataSource                         = self;
        _tableView.delegate                           = self;
    }
    return _tableView;
}

-(KMMemberCenterViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                                    = [[KMMemberCenterViewModel alloc]init];
    }
    return _viewModel;
}

@end
