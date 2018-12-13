//
//  KMCompleteUserInfoController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCompleteUserInfoController.h"
#import "KMCompleteUserInfoViewModel.h"
@interface KMCompleteUserInfoController ()
/** 用户名 */
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
/** 用户名输入 */
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
/** 邮箱 */
@property (strong, nonatomic) IBOutlet UILabel *mailLbl;
/** 邮箱输入 */
@property (strong, nonatomic) IBOutlet UITextField *mailTF;
/** 地址 */
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;
/** 定位地址 */
@property (strong, nonatomic) IBOutlet UIButton *locationBtn;
/** 保存按钮 */
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;


/** 高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;
/** 左间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
/** 右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
/** 宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
/** 保存 按钮 高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *saveBtnHeight;
/** 保存 按钮 上间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *saveBtnTopMargin;


@property (nonatomic, strong) KMCompleteUserInfoViewModel * viewModel;

@end

@implementation KMCompleteUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
#pragma mark - Private Method
/** 获取定位 */
-(void)getLocation{
    @weakify(self)
    /** 开启定位 */
    [[KMLocationManager shareInstance] startSystemLocationWithRes:^(CLLocation *loction, NSError *error) {
        @strongify(self)
        if (!error) {
            // 获取当前所在的城市名
    CLGeocoder *geocoder                      = [[CLGeocoder alloc] init];
            //根据经纬度反向地理编译出地址信息
            [geocoder reverseGeocodeLocation:loction completionHandler:^(NSArray *array, NSError *error){
                if (array.count > 0){
    CLPlacemark *placemark                    = [array objectAtIndex:0];
                    //获取城市
    NSString *city                            = placemark.locality;
                    if (!city) {
                        //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
    city                                      = placemark.administrativeArea;
                    }
                    //获取区
    NSString *subLocality                     = placemark.subLocality;
                    //获取街道
    NSString *name                            = placemark.name;
    NSString *locationStr                     = NSStringFormat(@"%@%@%@",city,subLocality,name);
                    KMLog(@"当前位置 ===  %@",locationStr);//具体位置
    self.viewModel.location                   = locationStr;
                    [self.locationBtn setTitle:locationStr forState:UIControlStateNormal];
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

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"完善用户资料");
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

    _userNameLbl.font                         = kFont36;
    _mailLbl.font                             = kFont36;
    _locationLbl.font                         = kFont36;

    _userNameLbl.textColor                    = kFontColorDarkGray;
    _mailLbl.textColor                        = kFontColorDarkGray;
    _locationLbl.textColor                    = kFontColorDarkGray;

    _userNameTF.font                          = kFont36;
    _mailTF.font                              = kFont36;
    _locationBtn.titleLabel.font              = kFont36;

    [_locationBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];

    _saveBtn.titleLabel.font                  = kFont32;

    [_saveBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor]
                            forState:UIControlStateNormal];

    //隐藏左按钮
    self.navigationItem.leftBarButtonItems    = @[];
    self.navigationItem.hidesBackButton       = YES;
    //关闭滑动返回
    self.fd_interactivePopDisabled            = YES;
}

-(void)km_layoutSubviews{
    _inputViewHeight.constant                 = AdaptedHeight(120);
    _leftMargin.constant                      = AdaptedWidth(55);
    _rightMargin.constant                     = AdaptedWidth(55);
    _saveBtnHeight.constant                   = AdaptedHeight(84);

    CGFloat userNameLblW                      = [_userNameLbl.text widthForFont:_userNameLbl.font];
    _labelWidth.constant                      = userNameLblW + 5;

    _saveBtnTopMargin.constant                = AdaptedHeight(258);

    [_saveBtn setRoundedCorners:UIRectCornerAllCorners
                         radius:_saveBtn.height / 2.0];
}
-(void)km_bindEvent{

    /** 开启定位 */
    [self getLocation];
    self.viewModel.accountId                  = self.accountId;
    RAC(self.viewModel, userName)             = _userNameTF.rac_textSignal;
    RAC(self.viewModel, mail)                 = _mailTF.rac_textSignal;
    RAC(self.saveBtn, enabled)                = self.viewModel.saveBtnEnableSig;

    @weakify(self)
    [[_saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.saveCommand execute:nil];
    }];
}
-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.successSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self popToLogin];
    }];
}
#pragma mark - Lazy
-(KMCompleteUserInfoViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                                = [[KMCompleteUserInfoViewModel alloc]init];
    }
    return _viewModel;
}

@end
