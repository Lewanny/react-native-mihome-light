//
//  KMInputInfoController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMInputInfoController.h"
@interface KMInputInfoController ()
/** TextView 高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
/** 上间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewTop;
/** 按钮上间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commitBtnTop;
/** 按钮左间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commitBtnLeft;
/** 按钮右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commitBtnRight;
/** 按钮高度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commitBtnHeight;

/** 输入 */
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
/** 提交按钮 */
@property (strong, nonatomic) IBOutlet UIButton *commitBtn;


@end

@implementation KMInputInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        [_textView becomeFirstResponder];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        [_textView resignFirstResponder];
    }];
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(_titleStr);
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    //设置占位文字
    _textView.placeholder        = _placeholder;
    _textView.placeholderColor   = kFontColorLightGray;
    //设置TextView
    _textView.textColor          = kFontColorGray;
    _textView.font               = kFont32;
    _textView.keyboardType       = _keyboardType ? _keyboardType : UIKeyboardTypeDefault;

    //设置提交按钮
    [_commitBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitBtn.titleLabel.font   = kFont32;


    if (_needChangeText.length) {
    _textView.text               = _needChangeText;
    }

    switch (_type) {
        case InputInfoTypeCompele:{
            [_commitBtn setTitle:@"保  存" forState:UIControlStateNormal];
        }
            break;
        case InputInfoTypeChange:{
            [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        }
            break;

        default:
            break;
    }
}
-(void)km_layoutSubviews{
    _textViewHeight.constant     = AdaptedHeight(278);
    _textViewTop.constant        = AdaptedHeight(22);
    _commitBtnTop.constant       = AdaptedHeight(80);
    _commitBtnLeft.constant      = AdaptedWidth(55);
    _commitBtnRight.constant     = AdaptedWidth(55);
    _commitBtnHeight.constant    = AdaptedHeight(84);
    [_commitBtn setRoundedCorners:UIRectCornerAllCorners radius:_commitBtn.height / 2.0];
}

-(void)km_bindEvent{
    @weakify(self)
    [[_commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.type == InputInfoTypeCompele) {
            self.compele ? self.compele(self.textView.text) : nil;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.compele ? self.compele(self.textView.text) : nil;
        }
    }];
    //长度为0时不能提交
    RAC(self.commitBtn, enabled) = [RACSignal combineLatest:@[_textView.rac_textSignal] reduce:^id (NSString * text){
        return @(text.length != 0);
    }];
}

@end
