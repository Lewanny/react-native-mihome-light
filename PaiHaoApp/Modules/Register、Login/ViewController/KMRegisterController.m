//
//  KMRegisterController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMRegisterController.h"
#import "KMRegisterCtrModel.h"
#import "KMCompleteUserInfoController.h"//完善用户注册信息
#import "KMCompleteBusinessInfoController.h"//完善商户注册信息

#import "KMRegProtocolVC.h"//用户注册协议

@interface KMRegisterController ()
/** 手机号码 */
@property (strong, nonatomic) IBOutlet UILabel *teleTitleLabel;
/** 验证码 */
@property (strong, nonatomic) IBOutlet UILabel *codeTitleLabel;
/** 输入密码 */
@property (strong, nonatomic) IBOutlet UILabel *pwdLabel1;
/** 确认密码 */
@property (strong, nonatomic) IBOutlet UILabel *pwdLabel2;
/** 选择注册类型 */
@property (strong, nonatomic) IBOutlet UISegmentedControl *userTypeSegment;
/** 提交按钮 */
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
/** 使用账号密码登录 */
@property (strong, nonatomic) IBOutlet UIButton *goLoginButton;
/** 输入电话号码 */
@property (strong, nonatomic) IBOutlet UITextField *teleTF;
/** 输入验证码 */
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
/** 输入密码 */
@property (strong, nonatomic) IBOutlet UITextField *pwdTF1;
/** 确认密码 */
@property (strong, nonatomic) IBOutlet UITextField *pwdTF2;
/** 获取验证码 */
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;

/** 协议 */
@property (strong, nonatomic) YYLabel *protocolLabel;

/** 左间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
/** 右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
/** 上面 View高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightConstraint;
/** 提交按钮高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commitBtnHeightConstraint;
/** 协议按钮底部间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *protocolBottomConstraint;
/** 获取验证码按钮宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *codeBtnWidthConstraint;
/** 手机号 宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teleLabelWidthConstraint;

/** 输入密码 是否显示 */
@property (nonatomic, strong) UIButton * pwdRightBtn1;
/** 确认密码 是否显示 */
@property (nonatomic, strong) UIButton * pwdRightBtn2;

@property (nonatomic, strong) KMRegisterCtrModel * viewModel;

@end

@implementation KMRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

#pragma mark - Private Method

-(void)clickPwdRightBtn:(UIButton *)sender{
    sender.selected                                = !sender.selected;
    if ([sender isEqual:self.pwdRightBtn1]) {
    _pwdTF1.secureTextEntry                        = !sender.selected;
    }else if ([sender isEqual:self.pwdRightBtn2]){
    _pwdTF2.secureTextEntry                        = !sender.selected;
    }
}

#pragma mark - Push
/** 完善资料 */
-(void)pushToCompleteInfo{
    UIViewController *vc                           = nil;
    if (self.viewModel.userType == KM_UserTypeNormal) {
        /** 普通用户 */
        
    KMCompleteUserInfoController *userInfo         = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMCompleteUserInfoIdentifier);
    userInfo.accountId                             = self.viewModel.accountId;
    vc                                             = userInfo;
    }else if (self.viewModel.userType == KM_UserTypeBusiness){
        /** 商户 */
    KMCompleteBusinessInfoController *businessInfo = [[KMCompleteBusinessInfoController alloc]init];
    businessInfo.accountId                         = self.viewModel.accountId;
    vc                                             = businessInfo;
    }
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
//回退到登录界面
-(void)popToLogin{
    __block KMLoginViewController *login           = nil;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[KMLoginViewController class]]) {
    login = obj;
    *stop = YES;
        }
    }];

    if (!login) {
    login = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMLoginViewControllerIdentifier);
    NSMutableArray *arrM = [self.navigationController.viewControllers mutableCopy];
        [arrM insertObject:login atIndex:0];
    self.navigationController.viewControllers = [arrM copy];
    }
    [self.navigationController popToViewController:login animated:YES];
}
//跳转用户注册协议
-(void)pushRegProtocolVC{
    KMRegProtocolVC *vc                            = [[KMRegProtocolVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"手机快捷注册");
}

-(void)right_button_event:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIButton *)set_rightButton{
    UIButton *rightBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"chaa"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"chaa"] forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];

    return rightBtn;
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    //设置字体
    _teleTitleLabel.font                           = kFont36;
    _codeTitleLabel.font                           = kFont36;
    _pwdLabel1.font                                = kFont36;
    _pwdLabel2.font                                = kFont36;
    //设置文字颜色
    _teleTitleLabel.textColor                      = kFontColorDarkGray;
    _codeTitleLabel.textColor                      = kFontColorDarkGray;
    _pwdLabel1.textColor                           = kFontColorDarkGray;
    _pwdLabel2.textColor                           = kFontColorDarkGray;

    //选择用户类型 Segment
    NSDictionary *normalAttributes                 = @{NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kMainThemeColor};
    NSDictionary *selectedAttributes               = @{NSFontAttributeName : kFont36, NSForegroundColorAttributeName : [UIColor whiteColor]};

    _userTypeSegment.tintColor                     = kMainThemeColor;
    [_userTypeSegment setTitleTextAttributes:normalAttributes
                                    forState:UIControlStateNormal];
    [_userTypeSegment setTitleTextAttributes:selectedAttributes
                                    forState:UIControlStateSelected];

    //提交按钮
    [_commitButton setBackgroundImage:[UIImage imageWithColor:kMainThemeColor]
                             forState:UIControlStateNormal];

    _commitButton.titleLabel.font                  = kFont32;

    //账号密码登录按钮
    [_goLoginButton setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_goLoginButton setTitleColor:kMainThemeColor forState:UIControlStateSelected];
    _goLoginButton.titleLabel.font                 = kFont28;

    //注册协议Label
    [_protocolLabel setFont:kFont24];
    [_protocolLabel setTextColor:kFontColorGray];

    //TextField
    [_teleTF setFont:kFont36];
    [_teleTF setPlaceholder:@"请输入手机号"];
    [_codeTF setFont:kFont36];
    [_codeTF setPlaceholder:@"请输入验证码"];
    [_pwdTF1 setFont:kFont36];
    [_pwdTF1 setPlaceholder:@"请输入密码"];
    [_pwdTF2 setFont:kFont36];
    [_pwdTF2 setPlaceholder:@"请确认密码"];

    [_pwdTF1 setRightView:self.pwdRightBtn1];
    [_pwdTF2 setRightView:self.pwdRightBtn2];
    [_pwdTF1 setRightViewMode:UITextFieldViewModeAlways];
    [_pwdTF2 setRightViewMode:UITextFieldViewModeAlways];

    //获取验证码
    [_getCodeBtn.titleLabel setFont:kFont28];
    [_getCodeBtn setTitleColor:kFontColorGray
                      forState:UIControlStateNormal];

    //隐藏左按钮
    self.navigationItem.leftBarButtonItems         = @[[[UIBarButtonItem alloc]initWithCustomView:[UIView new]]];
    [self.navigationItem setHidesBackButton:YES];
    //关闭滑动返回
    self.fd_interactivePopDisabled                 = YES;

    //用户注册协议
    _protocolLabel                                 = [YYLabel new];
    [_protocolLabel setFrame:CGRectMake(0, KScreenHeight - AdaptedHeight(55) - 25, KScreenWidth, 25)];
    NSString *pString                              = @"点击登录代表同意《用户注册协议》";
    NSMutableAttributedString *aString             = [[NSMutableAttributedString alloc]initWithString:pString];
    [aString setFont:kFont24];
    [aString setColor:kFontColorGray];
    [aString setColor:HEXCOLOR(@"1E90FF") range:[pString rangeOfString:@"《用户注册协议》" options:NSBackwardsSearch]];
    [_protocolLabel setAttributedText:aString];
    [_protocolLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_protocolLabel];
}

-(void)km_bindEvent{
    @weakify(self)
    //跳转登录
    [[_goLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self popToLogin];
    }];
    //获取验证码
    [[_getCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.requestCode execute:nil];
    }];

    //提交注册
    [[_commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
//        [self pushToCompleteInfo];
        [[self.viewModel.regCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self pushToCompleteInfo];
        }];
    }];

    //映射到ViewModel的对应属性
    RAC(self.viewModel, tele)                      = _teleTF.rac_textSignal;
    RAC(self.viewModel, code)                      = _codeTF.rac_textSignal;
    RAC(self.viewModel, password1)                 = _pwdTF1.rac_textSignal;
    RAC(self.viewModel, password2)                 = _pwdTF2.rac_textSignal;
    RAC(self.viewModel, userType)                  = RACObserve(_userTypeSegment, selectedSegmentIndex);
    //什么时候提交按钮可点击
    RAC(self.commitButton, enabled)                = self.viewModel.regBtnEnableSig;

    //点击用户注册协议
    _protocolLabel.textTapAction                   = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self)
    NSInteger location                             = [text.string rangeOfString:@"《用户注册协议》" options:NSBackwardsSearch].location;
        if (location != NSNotFound) {
            if (range.location >= location) {
                [self pushRegProtocolVC];
            }
        }
    };
}
-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.countDownSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
    NSInteger count = [x integerValue];
    self.getCodeBtn.enabled = count == 0;
        if (count) { 
            [self.getCodeBtn setTitle:NSStringFormat(@"%ld",count) forState:UIControlStateNormal];
        }else{
            [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    }];
}

-(void)km_layoutSubviews{
    _leftConstraint.constant                       = AdaptedWidth(55);
    _rightConstraint.constant                      = AdaptedWidth(55);
    _inputViewHeightConstraint.constant            = AdaptedHeight(120);
    _commitBtnHeightConstraint.constant            = AdaptedHeight(84);
    _protocolBottomConstraint.constant             = AdaptedHeight(55);

    CGFloat teleLabelWidth                         = [_pwdLabel2.text widthForFont:_pwdLabel2.font];
    _teleLabelWidthConstraint.constant             = teleLabelWidth + 5;

    CGFloat getCodeBtnWidth                        = [_getCodeBtn.currentTitle widthForFont:_getCodeBtn.titleLabel.font];
    _codeBtnWidthConstraint.constant               = getCodeBtnWidth + 10;

    [_commitButton setRoundedCorners:UIRectCornerAllCorners radius:_commitButton.height / 2.0];
    [_userTypeSegment cornerRadius:5 strokeSize:1 color:kMainThemeColor];
    _userTypeSegment.layer.masksToBounds           = YES;
}

#pragma mark - Lazy
-(UIButton *)pwdRightBtn1{
    if (!_pwdRightBtn1) {
    _pwdRightBtn1  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pwdRightBtn1 setImage:[UIImage imageNamed:@"kaiga"] forState:UIControlStateNormal];
        [_pwdRightBtn1 setImage:[UIImage imageNamed:@"kaigb"] forState:UIControlStateSelected];
        [_pwdRightBtn1 addTarget:self action:@selector(clickPwdRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_pwdRightBtn1 setFrame:CGRectMake(0, 0, 44, 44)];
    }
    return _pwdRightBtn1;
}
-(UIButton *)pwdRightBtn2{
    if (!_pwdRightBtn2) {
    _pwdRightBtn2                                  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pwdRightBtn2 setImage:[UIImage imageNamed:@"kaiga"] forState:UIControlStateNormal];
        [_pwdRightBtn2 setImage:[UIImage imageNamed:@"kaigb"] forState:UIControlStateSelected];
        [_pwdRightBtn2 addTarget:self action:@selector(clickPwdRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_pwdRightBtn2 setFrame:CGRectMake(0, 0, 44, 44)];
    }
    return _pwdRightBtn2;
}
-(KMRegisterCtrModel *)viewModel{
    if (!_viewModel) {
    _viewModel                                     = [[KMRegisterCtrModel alloc]init];
    }
    return _viewModel;
}
@end
