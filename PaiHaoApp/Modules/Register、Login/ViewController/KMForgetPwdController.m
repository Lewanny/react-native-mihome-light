//
//  KMForgetPwdController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/20.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMForgetPwdController.h"
#import "KMForgetPwdViewModel.h"
@interface KMForgetPwdController ()
/** 手机号Label */
@property (strong, nonatomic) IBOutlet UILabel *teleLabel;
/** 验证码Label */
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
/** 输入新密码 */
@property (strong, nonatomic) IBOutlet UILabel *pwdLabel1;
/** 确认新密码 */
@property (strong, nonatomic) IBOutlet UILabel *pwdLabel2;
/** 保存按钮 */
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
/** 输入手机号 */
@property (strong, nonatomic) IBOutlet UITextField *teleTF;
/** 输入验证码 */
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
/** 输入新密码 */
@property (strong, nonatomic) IBOutlet UITextField *pwdTF1;
/** 确认新密码 */
@property (strong, nonatomic) IBOutlet UITextField *pwdTF2;
/** 获取验证码 */
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;


/** 高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightConstraint;
/** 左间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
/** 右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
/** 获取验证码宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *codeBtnWidthConstraint;
/** 保存按钮高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *saveBtnHeightConstraint;
/** 保存按钮顶部间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *saveBtnTopConstraint;
/** 确认新密码 宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pwdLabelWidthConstraint;


/** 输入新密码 是否显示 */
@property (nonatomic, strong) UIButton * pwdRightBtn1;
/** 确认新密码 是否显示 */
@property (nonatomic, strong) UIButton * pwdRightBtn2;

@property (nonatomic, strong) KMForgetPwdViewModel * viewModel;

@end

@implementation KMForgetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method

-(void)clickPwdRightBtn:(UIButton *)sender{
    sender.selected                     = !sender.selected;
    if ([sender isEqual:self.pwdRightBtn1]) {
    _pwdTF1.secureTextEntry             = !sender.selected;
    }else if ([sender isEqual:self.pwdRightBtn2]){
    _pwdTF2.secureTextEntry             = !sender.selected;
    }
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"找回密码");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    //设置字体
    _teleLabel.font                     = kFont36;
    _codeLabel.font                     = kFont36;
    _pwdLabel1.font                     = kFont36;
    _pwdLabel2.font                     = kFont36;
    //设置文字颜色
    _teleLabel.textColor                = kFontColorDarkGray;
    _codeLabel.textColor                = kFontColorDarkGray;
    _pwdLabel1.textColor                = kFontColorDarkGray;
    _pwdLabel2.textColor                = kFontColorDarkGray;

    //保存按钮
    [_saveBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];

    _saveBtn.titleLabel.font            = kFont32;


    //TextField
    [_teleTF setFont:kFont36];
    [_teleTF setPlaceholder:@"请输入手机号"];
    [_codeTF setFont:kFont36];
    [_codeTF setPlaceholder:@"请输入验证码"];
    [_pwdTF1 setFont:kFont36];
    [_pwdTF1 setPlaceholder:@"请输入新密码"];
    [_pwdTF2 setFont:kFont36];
    [_pwdTF2 setPlaceholder:@"请确认新密码"];

    [_pwdTF1 setRightView:self.pwdRightBtn1];
    [_pwdTF2 setRightView:self.pwdRightBtn2];
    [_pwdTF1 setRightViewMode:UITextFieldViewModeAlways];
    [_pwdTF2 setRightViewMode:UITextFieldViewModeAlways];

    //获取验证码
    [_getCodeBtn.titleLabel setFont:kFont28];
    [_getCodeBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
}
-(void)km_layoutSubviews{
    _leftConstraint.constant            = AdaptedWidth(55);
    _rightConstraint.constant           = AdaptedWidth(55);

    _inputViewHeightConstraint.constant = AdaptedHeight(120);
    _saveBtnHeightConstraint.constant   = AdaptedHeight(84);

    CGFloat labelWidth                  = [_pwdLabel2.text widthForFont:_pwdLabel2.font];
    _pwdLabelWidthConstraint.constant   = labelWidth + 5;

    CGFloat getCodeBtnWidth             = [_getCodeBtn.currentTitle widthForFont:_getCodeBtn.titleLabel.font];
    _codeBtnWidthConstraint.constant    = getCodeBtnWidth + 10;

    [_saveBtn setRoundedCorners:UIRectCornerAllCorners radius:_saveBtn.height / 2.0];
}
-(void)km_bindEvent{
    @weakify(self)
    /** 获取验证码 */
    [[_getCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.requestCode execute:nil];
    }];
    /** 保存新密码 */
    [[_saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[self.viewModel.saveCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];


    /** 映射到ViewModel的对应属性 */
    RAC(self.viewModel, tele)           = _teleTF.rac_textSignal;
    RAC(self.viewModel, code)           = _codeTF.rac_textSignal;
    RAC(self.viewModel, password1)      = _pwdTF1.rac_textSignal;
    RAC(self.viewModel, password2)      = _pwdTF2.rac_textSignal;
    /** 什么时候提交按钮可点击 */
    RAC(self.saveBtn, enabled)          = self.viewModel.btnEnableSig;
}-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.countDownSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
    NSInteger count                     = [x integerValue];
    self.getCodeBtn.enabled             = count == 0;
        if (count) {
            [self.getCodeBtn setTitle:NSStringFormat(@"%ld",count) forState:UIControlStateNormal];
        }else{
            [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    }];
}
#pragma mark - Lazy
-(UIButton *)pwdRightBtn1{
    if (!_pwdRightBtn1) {
    _pwdRightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pwdRightBtn1 setImage:[UIImage imageNamed:@"kaiga"] forState:UIControlStateNormal];
        [_pwdRightBtn1 setImage:[UIImage imageNamed:@"kaigb"] forState:UIControlStateSelected];
        [_pwdRightBtn1 addTarget:self action:@selector(clickPwdRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_pwdRightBtn1 setFrame:CGRectMake(0, 0, 44, 44)];
    }
    return _pwdRightBtn1;
}
-(UIButton *)pwdRightBtn2{
    if (!_pwdRightBtn2) {
    _pwdRightBtn2                       = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pwdRightBtn2 setImage:[UIImage imageNamed:@"kaiga"] forState:UIControlStateNormal];
        [_pwdRightBtn2 setImage:[UIImage imageNamed:@"kaigb"] forState:UIControlStateSelected];
        [_pwdRightBtn2 addTarget:self action:@selector(clickPwdRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_pwdRightBtn2 setFrame:CGRectMake(0, 0, 44, 44)];
    }
    return _pwdRightBtn2;
}
-(KMForgetPwdViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                          = [[KMForgetPwdViewModel alloc]init];
    }
    return _viewModel;
}
@end
