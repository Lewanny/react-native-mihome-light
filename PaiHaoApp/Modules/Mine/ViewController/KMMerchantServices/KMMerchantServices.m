//
//  KMMerchantServices.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMerchantServices.h"
#import "KMUserInfoCell.h"

#import "KMWindowServiceVC.h"   //服务窗口
#import "KMCallOfficerVC.h"     //添加呼叫员
#import "KMPackageManageVC.h"   //套餐管理
#import "KMPackageSettingVC.h"  //套餐设置
#import "KMBusinessUpgradeVC.h" //商户升级
@interface KMMerchantServices ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMMerchantServices

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Private Method
-(UITableViewCell *)configCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell                = nil;
    UITableView *tableView               = self.tableView;
    NSString *leftText                   = self.leftTextArr[indexPath.row];
    
    KMUserInfoCell *infoCell             = [tableView dequeueReusableCellWithIdentifier:[KMUserInfoCell cellID]];
    infoCell.leftTextLbl.text            = leftText;
    infoCell.hideArrow                   = NO;
    [infoCell.subTextLbl setText:@""];
    [infoCell.subTextLbl setHidden:YES];
    cell                                 = infoCell;

    return cell;
}

#pragma mark - TableView Delegate && DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTextArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20);
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMUserInfoCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self configCellWithIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc                 = nil;
    switch (indexPath.row) {
        case 0://服务窗口
            vc                           = [[KMWindowServiceVC alloc]init];
            break;
        case 1://添加呼叫员
            vc                           = [[KMCallOfficerVC alloc]init];
            break;
        case 2:{//套餐设置
            KMPackageSettingVC *sVC      = [[KMPackageSettingVC alloc]init];
            sVC.style                    = PackageSettingStyleNew;
            sVC.viewModel                = [KMPackageVM new];
            vc                           = sVC;
        }
            break;
        case 3://套餐管理
            vc                           = [[KMPackageManageVC alloc]init];
            break;
        case 4:{//商户升级
            if (_customerType == KM_CustomerTypeCertification) {
                [SVProgressHUD showInfoWithStatus:@"您已成为高级商户" Duration:1];
                return;
            }
            if (_customerType == KM_CustomerTypeGold) {
                [SVProgressHUD showInfoWithStatus:@"您已成为白金商户" Duration:1];
                return;
            }
            if (_customerType == KM_CustomerTypeOrdinary){
                //普通商户升级认证商户
                KMBusinessUpgradeVC *bVC = [[KMBusinessUpgradeVC alloc]init];
                vc                       = bVC;
            }
        }
            break;
        default:
            break;
    }
    if (vc) {
        [self.navigationController cyl_pushViewController:vc animated:YES];
    }
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"商户服务");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                       = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate              = self;
        _tableView.dataSource            = self;
        [_tableView registerNib:[KMUserInfoCell loadNib] forCellReuseIdentifier:[KMUserInfoCell cellID]];
    }
    return _tableView;
}
-(NSArray *)leftTextArr{
    return @[@"设置窗口", @"添加呼叫员", @"套餐设置", @"套餐管理", @"商户升级"];//@[@"设置窗口", @"添加呼叫员", @"套餐设置", @"套餐管理", @"组合管理", @"商户升级"];
}
@end
