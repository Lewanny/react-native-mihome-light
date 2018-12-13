//
//  KMLoginViewController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/20.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMLoginViewController.h"
#import "KMLoginViewCtrModel.h"
#import "KMRegProtocolVC.h"//用户注册协议
@interface KMLoginViewController ()
/** 手机号/账号 */
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
/** 密码 */
@property (strong, nonatomic) IBOutlet UILabel *passWordLabel;
/** 输入用户名 */
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
/** 输入密码 */
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
/** 忘记密码 */
@property (strong, nonatomic) IBOutlet UIButton *forgetPwdBtn;
/** 登录按钮 */
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
/** 去注册 */
@property (strong, nonatomic) IBOutlet UIButton *goRegisterBtn;
/** 协议 */
@property (strong, nonatomic) YYLabel *protocolLabel;
/** 高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inputViewheightConstraint;
/** 左间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
/** 右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
/** label宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userNameLblWidthConstraint;
/** 登录按钮高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginBtnHeightConstraint;
/** 忘记密码 按钮宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forgetPwdBtnWidthConstraint;
/** 注册按钮顶部间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *registerTopConstraint;

@property (strong, nonatomic) KMLoginViewCtrModel *viewModel;

@end

@implementation KMLoginViewController
#pragma mark - Lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Push
//跳转注册
-(void)pushToRegVC{
    UIViewController *reg                 = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMRegisterControllerIdentifier);
    [self.navigationController cyl_pushViewController:reg animated:YES];
}
//跳转忘记密码
-(void)pushForgetPwdVC{
    UIViewController *forgetPwdVC         = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMForgetPwdControllerIdentifier);
    [self.navigationController cyl_pushViewController:forgetPwdVC animated:YES];
}
//Dismiss
-(void)dismissToOriginalVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//跳转用户注册协议
-(void)pushRegProtocolVC{
    KMRegProtocolVC *vc                   = [[KMRegProtocolVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"账号密码登录");
}

-(void)right_button_event:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIButton *)set_rightButton{
    UIButton *rightBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"chaa"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"chaa"] forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];

    return rightBtn;
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    //设置字体
    _userNameLabel.font                   = kFont36;
    _passWordLabel.font                   = kFont36;
    //设置文字颜色
    _userNameLabel.textColor              = kFontColorDarkGray;
    _passWordLabel.textColor              = kFontColorDarkGray;

    //登录按钮
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = kFont32;

    //忘记密码
    [_forgetPwdBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_forgetPwdBtn.titleLabel setFont:kFont28];

    //注册
    [_goRegisterBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_goRegisterBtn.titleLabel setFont:kFont28];

    //注册协议
    [_protocolLabel setFont:kFont24];
    [_protocolLabel setTextColor:kFontColorGray];

    //TextField
    [_userNameTF setFont:kFont36];
    [_userNameTF setPlaceholder:@"请输入手机号/账号"];
    [_passWordTF setFont:kFont36];
    [_passWordTF setPlaceholder:@"请输入密码"];

    //用户注册协议
    _protocolLabel                        = [YYLabel new];
    [_protocolLabel setFrame:CGRectMake(0, KScreenHeight - AdaptedHeight(55) - 25, KScreenWidth, 25)];
    NSString *pString                     = @"点击登录代表同意《用户注册协议》";
    NSMutableAttributedString *aString    = [[NSMutableAttributedString alloc]initWithString:pString];
    [aString setFont:kFont24];
    [aString setColor:kFontColorGray];
    [aString setColor:HEXCOLOR(@"1E90FF") range:[pString rangeOfString:@"《用户注册协议》" options:NSBackwardsSearch]];
    [_protocolLabel setAttributedText:aString];
    [_protocolLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_protocolLabel];
}
-(void)km_layoutSubviews{

    _inputViewheightConstraint.constant   = AdaptedHeight(120);
    _leftConstraint.constant              = AdaptedWidth(55);
    _rightConstraint.constant             = AdaptedWidth(55);
    _registerTopConstraint.constant       = AdaptedHeight(67);

    CGFloat labelW                        = [_userNameLabel.text widthForFont:_userNameLabel.font];
    _userNameLblWidthConstraint.constant  = labelW + 5;

    CGFloat forgetW                       = [_forgetPwdBtn.currentTitle widthForFont:_forgetPwdBtn.titleLabel.font];
    _forgetPwdBtnWidthConstraint.constant = forgetW + 5;

    _loginBtnHeightConstraint.constant    = AdaptedHeight(84);

    [_loginBtn setRoundedCorners:UIRectCornerAllCorners radius:_loginBtn.height / 2.0];
}

-(void)km_bindEvent{
    @weakify(self)
    //点击注册按钮
    [[_goRegisterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushToRegVC];
    }];
    //点击忘记密码
    [[_forgetPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushForgetPwdVC];
    }];

    //点击登录按钮
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        //发出执行指令
        [self.viewModel.loginCommand execute:nil];
    }];

    //textFiled文字
    RAC(self.viewModel, userName)         = _userNameTF.rac_textSignal;
    RAC(self.viewModel, password)         = _passWordTF.rac_textSignal;
    //登录什么时候可以点击
    RAC(self.loginBtn, enabled)           = self.viewModel.loginBtnEnableSig;

    //点击用户注册协议
    _protocolLabel.textTapAction          = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self)
    NSInteger location                    = [text.string rangeOfString:@"《用户注册协议》" options:NSBackwardsSearch].location;
        if (location != NSNotFound) {
            if (range.location >= location) {
                [self pushRegProtocolVC];
            }
        }
    };
}

-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.loginSuccessSubject subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self dismissToOriginalVC];
    }];
}

#pragma mark - Lazy
-(KMLoginViewCtrModel *)viewModel{
    if (!_viewModel) {
    _viewModel                            = [[KMLoginViewCtrModel alloc]init];
    }
    return _viewModel;
}
@end
