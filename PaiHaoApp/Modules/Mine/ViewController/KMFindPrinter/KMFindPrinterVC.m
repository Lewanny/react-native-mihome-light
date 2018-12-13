//
//  KMFindPrinterVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMFindPrinterVC.h"
#import "KMFindPrinterTopCell.h"
#import "KMBluetoothManager.h"
#import "KMPrinterSettingVC.h"
@interface KMFindPrinterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * deviceArr; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArr;  //信号强度 可选择性使用
@end

@implementation KMFindPrinterVC

#pragma mark - Lift Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - 蓝牙 -
/** 初始化蓝牙 */
-(void)initBluetoothManager{
    KMBluetoothManager *manager       = [KMBluetoothManager sharedInstance];

    @weakify(self)
    [manager beginScanPerpheralSuccess:^(NSArray<CBPeripheral *> *peripherals, NSArray<NSNumber *> *rssis) {
        @strongify(self)
    self.deviceArr = [NSMutableArray arrayWithArray:peripherals];
    self.rssisArr = [NSMutableArray arrayWithArray:rssis];
        [self.tableView reloadData];
    } failure:^(CBManagerState status) {
        [SVProgressHUD showErrorWithStatus:[KMBluetoothManager bluetoothErrorInfo:status] Duration:2];
    }];
    manager.disconnectPeripheralBlock = ^(CBPeripheral *perpheral, NSError *error) {
        @strongify(self)
        [self.tableView reloadData];
        [SVProgressHUD showInfoWithStatus:@"设备已经断开连接" Duration:2];
    };
    [manager autoConnectLastPeripheralCompletion:^(CBPeripheral *peripheral, NSError *error) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}
/** 重新搜索 */
-(void)researchBluetooth{
    KMBluetoothManager *manager       = [KMBluetoothManager sharedInstance];
    if (manager.connectedPerpheral) {
        [manager cancelPeripheralConnection:manager.connectedPerpheral];
    }
    [self initBluetoothManager];
}


#pragma mark - Private Method -

-(UITableViewCell *)topCell{
    KMFindPrinterTopCell *cell        = [self.tableView dequeueReusableCellWithIdentifier:[KMFindPrinterTopCell cellID]];
    KMBluetoothManager *manager       = [KMBluetoothManager sharedInstance];
    NSString *status                  = manager.centralManager.isScanning ? @"正在搜索" : @"搜索完毕";
    NSString *tips                    = manager.centralManager.isScanning ? @"点击可停止搜索" : @"点击可重新搜索";
    RACTuple *t                       = RACTuplePack(status, tips);
    [cell km_bindData:t];
    return cell;
}

-(UITableViewCell *)deviceCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell             = [self.tableView dequeueReusableCellWithIdentifier:[UITableViewCell cellID]];

    //设置文字属性
    {
        [cell.textLabel setFont:kFont32];
    }

    CBPeripheral *peripheral          = [self.deviceArr objectAtIndex:indexPath.row];
    cell.textLabel.text               = [NSString stringWithFormat:@"%@",peripheral.name];

    if (peripheral.state == CBPeripheralStateConnected) {
    cell.accessoryType                = UITableViewCellAccessoryCheckmark;
    } else {
    cell.accessoryType                = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.deviceArr.count;
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
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    return 50.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell             = nil;
    if (indexPath.section == 0) {
    cell                              = [self topCell];
    }else{
    cell                              = [self deviceCellWithIndexPath:indexPath];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
    KMBluetoothManager *manager       = [KMBluetoothManager sharedInstance];
        manager.centralManager.isScanning ? [manager stopScanPeripheral] : [self researchBluetooth];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else if (indexPath.section == 1) {
    CBPeripheral *peripheral          = [self.deviceArr objectAtIndex:indexPath.row];
    KMPrinterSettingVC *vc            = [[KMPrinterSettingVC alloc]init];
    vc.perpheral                      = peripheral;
        [self.navigationController cyl_pushViewController:vc animated:YES];
    }
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"查找蓝牙打印机");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
-(void)km_bindEvent{
    [self initBluetoothManager];
}

#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                        = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor        = self.view.backgroundColor;
    _tableView.delegate               = self;
    _tableView.dataSource             = self;
    _tableView.estimatedRowHeight     = 100.0;
        [_tableView registerClass:[KMFindPrinterTopCell class] forCellReuseIdentifier:[KMFindPrinterTopCell cellID]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell cellID]];
    }
    return _tableView;
}
-(NSMutableArray *)deviceArr{
    if (!_deviceArr) {
    _deviceArr                        = [NSMutableArray array];
    }
    return _deviceArr;
}
-(NSMutableArray *)rssisArr{
    if (!_rssisArr) {
    _rssisArr                         = [NSMutableArray array];
    }
    return _rssisArr;
}
@end
