//
//  KMUserFeedbackController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserFeedbackController.h"
#import "KMUserFeedbackViewModel.h"

@interface KMUserFeedbackController ()

@property (nonatomic, strong) KMUserFeedbackViewModel * viewModel;
/** 反馈容器 */
@property (nonatomic, strong) UIView * feedbackContainer;

@property (nonatomic, strong) UIPlaceHolderTextView * textView;

@property (nonatomic, strong) UILabel * countLabel;
/** 提交按钮 */
@property (nonatomic, strong) UIButton * commitBtn;

@end

@implementation KMUserFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"用户反馈");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.feedbackContainer];
    [self.feedbackContainer addSubview:self.textView];
    [self.feedbackContainer addSubview:self.countLabel];

    [self.view addSubview:self.commitBtn];
}
-(void)km_layoutSubviews{
    [self.feedbackContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavHeight + AdaptedHeight(20));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptedHeight(500));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.feedbackContainer).offset(AdaptedWidth(24));
        make.right.mas_equalTo(self.feedbackContainer).offset(AdaptedWidth(-24));
        make.top.mas_equalTo(self.feedbackContainer);
        make.height.mas_equalTo(AdaptedHeight(450));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.feedbackContainer);
        make.right.mas_equalTo(self.feedbackContainer).offset(AdaptedWidth(-24));
        make.height.mas_equalTo(AdaptedHeight(50));
    }];

    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.feedbackContainer.mas_bottom).offset(AdaptedHeight(80));
        make.left.mas_equalTo(self.feedbackContainer).offset(AdaptedWidth(55));
        make.right.mas_equalTo(self.feedbackContainer).offset(AdaptedWidth(-55));
        make.height.mas_equalTo(AdaptedHeight(84));
    }];

    _commitBtn.layer.cornerRadius      = _commitBtn.height / 2.0;
    _commitBtn.layer.masksToBounds     = YES;
}
-(void)km_bindEvent{

    RAC(self.viewModel, feedBackText)  = self.textView.rac_textSignal;
    RAC(self.commitBtn, enabled)       = self.viewModel.commitEnableSig;

    @weakify(self)
    [self.textView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
    NSInteger count                    = self.viewModel.maxTextCount - x.length;
        [self.countLabel setText:NSStringFormat(@"%ld",count)];
        if (count >= 0) {
            [self.countLabel setTextColor:kFontColorDark];
        }else{
            [self.countLabel setTextColor:kAppRedColor];
        }
    }];
    [[_commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[self.viewModel.feedbackCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}
#pragma mark - Lazy
-(UIView *)feedbackContainer{
    if (!_feedbackContainer) {
    _feedbackContainer                 = [UIView new];
    _feedbackContainer.backgroundColor = [UIColor whiteColor];

    UIView *topLine                    = [UIView new];
    topLine.backgroundColor            = kFontColorLightGray;
        [_feedbackContainer addSubview:topLine];

    UIView *bottomLine                 = [UIView new];
    bottomLine.backgroundColor         = kFontColorLightGray;
        [_feedbackContainer addSubview:bottomLine];

        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(_feedbackContainer);
            make.height.mas_equalTo(0.5);
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(_feedbackContainer);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _feedbackContainer;
}

-(UIPlaceHolderTextView *)textView{
    if (!_textView) {
    _textView                          = [[UIPlaceHolderTextView alloc]init];
    _textView.font                     = kFont30;
    _textView.placeholder              = [self.viewModel textViwePlaceholder];
    _textView.textColor                = kFontColorDarkGray;
    _textView.placeholderColor         = kFontColorGray;
    _textView.backgroundColor          = [UIColor clearColor];
    }
    return _textView;
}
-(UILabel *)countLabel{
    if (!_countLabel) {
    _countLabel                        = [[UILabel alloc]init];
    _countLabel.font                   = kFont32;
    _countLabel.textColor              = kFontColorDark;
    _countLabel.textAlignment          = NSTextAlignmentRight;
    _countLabel.text                   = NSStringFormat(@"%ld",self.viewModel.maxTextCount);
    }
    return _countLabel;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitBtn.titleLabel.font         = kFont30;
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
    }
    return _commitBtn;
}
-(KMUserFeedbackViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                         = [KMUserFeedbackViewModel new];
    }
    return _viewModel;
}
@end
