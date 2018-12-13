//
//  KMCompleteBusinessInfoController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCompleteBusinessInfoController.h"
#import "KMCompleteBusinessInfoViewModel.h"
#import "KMUserInfoHeadCell.h"
#import "KMUserInfoCell.h"
#import "KMInputInfoController.h"

#import "KMUploadImageTool.h"
@interface KMCompleteBusinessInfoController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) KMCompleteBusinessInfoViewModel * viewModel;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * tableFootView;

@property (nonatomic, strong) UIButton * saveBtn;

@end

@implementation KMCompleteBusinessInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method
/** 获取定位 */
-(void)getLocation{
    @weakify(self)
    /** 开启定位 */
    [[KMLocationManager shareInstance] startSystemLocationWithRes:^(CLLocation *loction, NSError *error) {
        @strongify(self)
        if (!error) {
            // 获取当前所在的城市名
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            //根据经纬度反向地理编译出地址信息
            [geocoder reverseGeocodeLocation:loction completionHandler:^(NSArray *array, NSError *error){
                if (array.count > 0){
                    CLPlacemark *placemark = [array objectAtIndex:0];
                    [self.viewModel updateLocationWithCLPlacemark:placemark];
                    [self.tableView reloadData];
                }else if (error == nil && [array count] == 0){
                    KMLog(@"No results were returned.");
                }else if (error != nil){
                    KMLog(@"An error occurred                 = %@", error);
                }
            }];
            KMLog(@"%@",loction);
        }else{
            KMLog(@"%@",error);
        }
    }];
}

-(UITableViewCell *)configCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell                     = nil;
    UITableView *tableView                    = self.tableView;
    if (indexPath.section == 0 && indexPath.row == 1) {
    KMUserInfoHeadCell *headCell              = [tableView dequeueReusableCellWithIdentifier:[KMUserInfoHeadCell cellID]];
    headCell.leftTextLbl.text                 = self.viewModel.leftText[indexPath.section][indexPath.row];
    headCell.hideArrow                        = YES;
        [headCell km_bindData:self.viewModel.info.headportrait];
    cell                                      = headCell;
    }else{
    KMUserInfoCell *infoCell                  = [tableView dequeueReusableCellWithIdentifier:[KMUserInfoCell cellID]];
    infoCell.leftTextLbl.text                 = self.viewModel.leftText[indexPath.section][indexPath.row];
    infoCell.hideArrow                        = YES;
    cell                                      = infoCell;

    KMMerchantInfoModel * info                = self.viewModel.info;
    NSString *placeholder                     = [[self.viewModel.placeholders objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];


        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
    infoCell.subTextLbl.text                  = info.userName.length ? info.userName : placeholder;
                }
                    break;
                case 2:{
    infoCell.subTextLbl.text                  = info.phone.length ? info.phone : placeholder;
                }
                    break;
                default:
                    break;
            }
        }else if (indexPath.section == 1){
            switch (indexPath.row) {
                case 0:{
    infoCell.subTextLbl.text                  = info.businessName.length ? info.businessName : placeholder;
                }
                    break;
                case 1:{
                    //区域定位地址
    infoCell.subTextLbl.text                  = info.grouparea.length ? info.grouparea : placeholder;
                }
                    break;
                case 2:{
                    //详细地址使用定位地址
    infoCell.subTextLbl.text                  = info.UserAddress.length ? info.UserAddress : placeholder;
                }
                    break;
                case 3:{
    infoCell.subTextLbl.text                  = info.telephone.length ? info.telephone : placeholder;
                }
                    break;
                case 4:{
    infoCell.subTextLbl.text                  = info.mail.length ? info.mail : placeholder;
                }
                    break;
                case 5:{
    infoCell.subTextLbl.text                  = info.synopsis.length ? info.synopsis : placeholder;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return cell;
}
/** 点击头像 */
-(void)clickHead{
    @weakify(self)
    [KMUploadImageTool uploadWithSuccess:^(UIImage *uploadImage, NSString *imageUrl) {
       @strongify(self)
    self.viewModel.info.headportrait          = imageUrl;
       [SVProgressHUD showSuccessWithStatus:@"上传成功" Duration:1];
    } Failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败" Duration:1];
    }];
}

#pragma mark - Push && Pop
-(void)popToLogin{
    __block KMLoginViewController *login      = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[KMLoginViewController class]]) {
    login                                     = obj;
    *stop                                     = YES;
        }
    }];

    if (!login) {
    login                                     = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMLoginViewControllerIdentifier);
    NSMutableArray *arrM                      = [self.navigationController.viewControllers mutableCopy];
        [arrM insertObject:login atIndex:0];
    self.navigationController.viewControllers = [arrM copy];
    }
    [self.navigationController popToViewController:login animated:YES];
}

#pragma mark - TabelView Delegate && DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.leftText.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr                              = [self.viewModel.leftText objectAtIndex:section];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return AdaptedHeight(144);
    }
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section != 1) {
        return 0.01;
    }
    return AdaptedHeight(96 + 84 + 96);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section != 1) {
        return [UIView new];
    }
    return self.tableFootView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self configCellWithIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        //选择头像
        [self clickHead];
    }else if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2)){

    }else{
    NSString *placeholder                     = [[self.viewModel.placeholders objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *titleStr                        = [[self.viewModel.titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    KMInputInfoController *input              = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMInputUserInfoIdentifier);
    input.type                                = InputInfoTypeCompele;
    input.placeholder                         = placeholder;
    input.titleStr                            = titleStr;
    input.needChangeText                      = [self.viewModel needCompeleTextWithIndexPath:indexPath];
        @weakify(self, indexPath)
    input.compele                             = ^(NSString *text) {
            @strongify(self, indexPath)
            [self.viewModel compeleText:text IndexPath:indexPath];
            [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
        };
        [self.navigationController pushViewController:input animated:YES];
    }
}


#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"完善商户资料");
}
-(void)right_button_event:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIButton *)set_rightButton{
    UIButton *rightBtn                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"chaa"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"chaa"] forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];

    return rightBtn;
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{

    [self.view addSubview:self.tableView];
    //隐藏左按钮
    self.navigationItem.leftBarButtonItems    = @[];
    self.navigationItem.hidesBackButton       = YES;
    //关闭滑动返回
    self.fd_interactivePopDisabled            = YES;
}

-(void)km_bindEvent{
    /** 开启定位 */
    [self getLocation];
    self.viewModel.accountId                  = self.accountId;
    @weakify(self)
    [[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        KMLog(@"%@", [self.viewModel.info modelDescription]);
        //验证数据是否输入
        if ([self.viewModel verifyInfoData]) {
            //提交网络
            [self.viewModel.saveCommand execute:nil];
        }
    }];
}
-(void)km_bindViewModel{
    self.viewModel.accountId                  = _accountId;
    @weakify(self)
    [self.viewModel.successSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self popToLogin];
    }];
}
-(void)km_layoutSubviews{
    self.saveBtn.centerX                      = self.tableFootView.centerX;
    [self.saveBtn setRoundedCorners:UIRectCornerAllCorners radius:_saveBtn.height / 2.0];
}

#pragma mark - Lazy
-(KMCompleteBusinessInfoViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                                = [[KMCompleteBusinessInfoViewModel alloc]init];
    }
    return _viewModel;
}
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                                = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource                     = self;
    _tableView.delegate                       = self;
        [_tableView registerNib:[KMUserInfoHeadCell loadNib] forCellReuseIdentifier:[KMUserInfoHeadCell cellID]];
        [_tableView registerNib:[KMUserInfoCell loadNib] forCellReuseIdentifier:[KMUserInfoCell cellID]];
    _tableView.estimatedRowHeight             = AdaptedHeight(92);
    }
    return _tableView;
}
-(UIView *)tableFootView{
    if (!_tableFootView) {
    _tableFootView                            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, AdaptedHeight(96 + 84))];
        [_tableFootView addSubview:self.saveBtn];
    }
    return _tableFootView;
}
-(UIButton *)saveBtn{
    if (!_saveBtn) {
    _saveBtn                                  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保  存" forState:UIControlStateNormal];
        [_saveBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn setFrame:CGRectMake(0, AdaptedHeight(96), AdaptedWidth(640), AdaptedHeight(84))];
    }
    return _saveBtn;
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
    _imagePickerVc                            = [[UIImagePickerController alloc] init];
    _imagePickerVc.allowsEditing              = YES;
    _imagePickerVc.delegate                   = self;
        // set appearance / 改变相册选择页的导航栏外观
    _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    _imagePickerVc.navigationBar.tintColor    = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
    tzBarItem                                 = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
    BarItem                                   = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
    tzBarItem                                 = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
    BarItem                                   = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
    NSDictionary *titleTextAttributes         = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
@end
