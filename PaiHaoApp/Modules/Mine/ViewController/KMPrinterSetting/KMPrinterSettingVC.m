//
//  KMPrinterSettingVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPrinterSettingVC.h"
#import "KMPrinterSettingTopCell.h"
#import <ActionSheetPicker_3_0/ActionSheetPicker.h>
@interface KMPrinterSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMPrinterSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 蓝牙 -
-(void)connectBluetooth{
    if (!_perpheral) {
        return;
    }
    @weakify(self)
    KMBluetoothManager *manager       = [KMBluetoothManager sharedInstance];
    [manager connectPeripheral:_perpheral completion:^(CBPeripheral *perpheral, NSError *error) {
        @strongify(self)
        [self.tableView reloadData];
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"连接成功！" Duration:2];
        }else{
            [SVProgressHUD showErrorWithStatus:error.domain Duration:2];
        }
    }];

    manager.disconnectPeripheralBlock = ^(CBPeripheral *perpheral, NSError *error) {
        @strongify(self)
        [self.tableView reloadData];
        [SVProgressHUD showInfoWithStatus:@"设备已经断开连接" Duration:2];
    };
}

#pragma mark - Private Method -

-(UITableViewCell *)topCell{
    KMPrinterSettingTopCell *cell     = [self.tableView dequeueReusableCellWithIdentifier:[KMPrinterSettingTopCell cellID]];
    NSString *status                  = [KMBluetoothManager peripheralStateStringWith:_perpheral.state];
    RACTuple *t                       = RACTuplePack(self.perpheral.name, status);
    [cell km_bindData:t];
    @weakify(self)
    [[cell.disConnectSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
    KMBluetoothManager *manager       = [KMBluetoothManager sharedInstance];
        if (self.perpheral.state == CBPeripheralStateConnected && [manager.connectedPerpheral isEqual:self.perpheral]) {
            [manager cancelPeripheralConnection:self.perpheral];
        }
    }];
    return cell;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return AdaptedHeight(20);
    }
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return AdaptedHeight(104);
    }
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell             = nil;
    if (indexPath.section == 0) {
    cell                              = [self topCell];
    }else{
    cell                              = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell cellID]];
        if (!cell) {
    cell                              = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[UITableViewCell cellID]];
        }
        [cell.textLabel setFont:kFont32];
        [cell.textLabel setTextColor:kFontColorDark];
        [cell.detailTextLabel setFont:kFont24];
        [cell.detailTextLabel setTextColor:kFontColorGray];
        [cell.textLabel setText:@"打印份数"];
        [cell.detailTextLabel setText:NSStringFormat(@"%ld份",[KMBluetoothManager printCount])];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *rangeArr                 = @[@"1", @"2", @"5", @"10"];
    __block NSInteger index           = 0;
    [rangeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFormat(@"%ld",[KMBluetoothManager printCount]) isEqualToString:obj]) {
    index                             = idx;
    *stop                             = YES;
        }
    }];
    @weakify(self)
    [ActionSheetStringPicker showPickerWithTitle:@"选择打印份数" rows:rangeArr initialSelection:index doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        @strongify(self)
        [KMBluetoothManager setPrintCount:[selectedValue integerValue]];
        [self.tableView reloadData];
    } cancelBlock:nil origin:self.view];

}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"打印机设置");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}

-(void)km_bindEvent{
    [self connectBluetooth];
}

#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                        = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor        = self.view.backgroundColor;
    _tableView.delegate               = self;
    _tableView.dataSource             = self;
    _tableView.estimatedRowHeight     = 100.0;
        [_tableView registerClass:[KMPrinterSettingTopCell class] forCellReuseIdentifier:[KMPrinterSettingTopCell cellID]];
    }
    return _tableView;
}
@end
