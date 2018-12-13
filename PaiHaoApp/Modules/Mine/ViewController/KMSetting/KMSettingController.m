//
//  KMSettingController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSettingController.h"
#import "KMSettingCell.h"

#import "KMSettingViewModel.h"

#import "KMTabBarController.h"

#import "KMFindPrinterVC.h"//查找蓝牙打印机

@interface KMSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KMSettingViewModel * viewModel;

@end

@implementation KMSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewModel cacheSizeString];
}

#pragma mark - Private Method
-(UITableViewCell *)configCellWithIndexPath:(NSIndexPath *)indexPath{
    KMSettingCell *cell           = [self.tableView dequeueReusableCellWithIdentifier:[KMSettingCell cellID]];
    NSString *titleText           = [[self.viewModel.titleArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.leftLabel setText:titleText];

    if ([titleText isEqualToString:@"语音提醒设置"]) {
    cell.rightMode                = RightModeSwitch;
        cell.rightSwitch.on = [KMUserDefault.isVoice isEqualToString:@"1"];
    }else if ([titleText isEqualToString:@"清除缓存"]){
    cell.rightMode                = RightModeLabel;
        [cell.rightLabel setText:[self.viewModel cacheSizeString]];
    }else if ([titleText isEqualToString:@"版本号"]){
    cell.rightMode                = RightModeLabel;
        [cell.rightLabel setText:NSStringFormat(@"当前版本v%@",[AppDelegate shareAppDelegate].km_version]);
    }else if ([titleText isEqualToString:@"打印机"]){
    cell.rightMode                = RightModeNone;
    }else if ([titleText isEqualToString:@"退出登录"]){
        cell.rightMode                = RightModeFull;
        [cell.fullLabel setText:titleText];
    }

    @weakify(self)
    [[[cell.rightSwitch rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        UISwitch *s = (UISwitch *)x;
        [self.viewModel.editReminderCommand execute:@(s.on)];
    }];

    return cell;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.viewModel.titleArr objectAtIndex:section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptedHeight(104);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == ([tableView numberOfSections] - 1)) {
        return AdaptedHeight(60);
    }
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
    return [self configCellWithIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *titleText           = [[self.viewModel.titleArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([titleText isEqualToString:@"退出登录"]) {
        [LBXAlertAction showAlertWithTitle:@"提示" msg:@"确认退出登录?" buttonsStatement:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
            if (buttonIdx == 1) {
                [KMUserManager logout];
    KMTabBarController *tabBarCtr = [[KMTabBarController alloc]init];
                [[AppDelegate shareAppDelegate].window setRootViewController:tabBarCtr];
            }
        }];
    }else if ([titleText isEqualToString:@"清除缓存"]){
        [self.viewModel cleanCache:^{
            [SVProgressHUD showSuccessWithStatus:@"清除缓存成功" Duration:1];
        }];
    }else if ([titleText isEqualToString:@"打印机"]){
        if (TARGET_IPHONE_SIMULATOR) {
            [SVProgressHUD showErrorWithStatus:@"模拟器没有蓝牙" Duration:1];
            return;
        }
    KMFindPrinterVC *vc           = [[KMFindPrinterVC alloc]init];
        [self.navigationController cyl_pushViewController:vc animated:YES];
    }
}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"设置");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if (x) {
            BOOL ret = [(NSNumber *)x boolValue];
            KMUserDefault.isVoice = ret ? @"1" : @"0";
        }
        
        [self.tableView reloadData];
    }];
}
#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate           = self;
    _tableView.dataSource         = self;
        [_tableView registerClass:[KMSettingCell class] forCellReuseIdentifier:[KMSettingCell cellID]];
    }
    return _tableView;
}
-(KMSettingViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                    = [[KMSettingViewModel alloc]init];
    }
    return _viewModel;
}
@end
