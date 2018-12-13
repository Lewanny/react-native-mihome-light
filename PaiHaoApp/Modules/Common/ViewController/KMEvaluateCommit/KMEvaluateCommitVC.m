//
//  KMEvaluateCommitVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMEvaluateCommitVC.h"
#import "HCSStarRatingView.h"

#import "KMEvaluateCommitVM.h"
@interface KMEvaluateCommitVC ()

@property (nonatomic, strong) KMEvaluateCommitVM * viewModel;

/** 评论星星 */
@property (nonatomic, strong) HCSStarRatingView * starView;
/** 输入评论 */
@property (nonatomic, strong) UIPlaceHolderTextView * textView;

/** 提交按钮 */
@property (nonatomic, strong) UIButton * commitBtn;

@property (nonatomic, strong) UIView * starBG;
@property (nonatomic, strong) UIView * textBG;

@end

@implementation KMEvaluateCommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"评价");
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.starBG];
    [self.starBG addSubview:self.starView];

    [self.view addSubview:self.textBG];
    [self.textBG addSubview:self.textView];

    [self.view addSubview:self.commitBtn];
}


-(void)km_bindViewModel{
    RAC(self.commitBtn, enabled)   = self.viewModel.commitEnableSig;
    RAC(self.viewModel, starNum)   = RACObserve(self.starView, value);
    RAC(self.viewModel, comment)   = self.textView.rac_textSignal;
}

#pragma mark - Lazy

-(UIView *)starBG{
    if (!_starBG) {
    _starBG                        = [UIView new];
    _starBG.backgroundColor        = [UIColor whiteColor];
    _starBG.frame                  = CGRectMake(0, kNavHeight, kScreenWidth, AdaptedHeight(222));

    UIView *line                   = [UIView new];
    line.backgroundColor           = [UIColor lightGrayColor];
    line.frame                     = CGRectMake(0, _starBG.height - 0.5, kScreenWidth, 0.5);

        [_starBG addSubview:line];
    }
    return _starBG;
}

-(UIView *)textBG{
    if (!_textBG) {
    _textBG                        = [UIView new];
    _textBG.backgroundColor        = [UIColor whiteColor];
    _textBG.frame                  = CGRectMake(0, self.starBG.bottom, kScreenWidth, AdaptedHeight(278));

    UIView *line                   = [UIView new];
    line.backgroundColor           = [UIColor lightGrayColor];
    line.frame                     = CGRectMake(0, _textBG.height - 0.5, kScreenWidth, 0.5);
        [_textBG addSubview:line];
    }
    return _textBG;
}


-(HCSStarRatingView *)starView{
    if (!_starView) {
    CGFloat height                 = AdaptedHeight(60);
    CGFloat leftMargin             = AdaptedWidth(170);
    CGFloat topMargin              = (AdaptedHeight(222) - height) /2.0;
    CGFloat width                  = kScreenWidth - 2*leftMargin;
    _starView                      = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    _starView.maximumValue         = 5;
    _starView.minimumValue         = 0;
    _starView.allowsHalfStars      = NO;
    _starView.filledStarImage      = IMAGE_NAMED(@"xingb1");
    _starView.emptyStarImage       = IMAGE_NAMED(@"xingb2");

        @weakify(self)
        [[_starView rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
                HCSStarRatingView * star       = x;
                self.viewModel.starNum         = star.value;
        }];
    }
    return _starView;
}

//-(YYTextView *)textView{
//    if (!_textView) {
//    _textView                      = [[YYTextView alloc]initWithFrame:CGRectMake(AdaptedWidth(24), 0, kScreenWidth - AdaptedWidth(24 + 24), self.textBG.height)];
//    _textView.placeholderText      = @"说说商户的亮点和不足吧 (写够15字，才是好同志)";
//    _textView.placeholderFont      = kFont26;
//    _textView.placeholderTextColor = kFontColorGray;
//    _textView.font                 = kFont26;
//    _textView.textColor            = kFontColorDark;
//    }
//    return _textView;
//}

-(UIPlaceHolderTextView *)textView{
    if (!_textView) {
        _textView                          = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(AdaptedWidth(24), 0, kScreenWidth - AdaptedWidth(24 + 24), self.textBG.height)];
        _textView.font                     = kFont26;
        _textView.placeholder              = @"说说商户的亮点和不足吧 (写够15字，才是好同志)";
        _textView.textColor                = kFontColorDark;
        _textView.placeholderColor         = kFontColorGray;
        _textView.backgroundColor          = [UIColor clearColor];
    }
    return _textView;
}

-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setFrame:CGRectMake(AdaptedWidth(55), self.textBG.bottom + AdaptedHeight(80), kScreenWidth - AdaptedWidth(55 + 55), AdaptedHeight(84))];
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitBtn.titleLabel.font     = kFont32;
        [_commitBtn setRoundedCorners:UIRectCornerAllCorners radius:_commitBtn.height / 2.0];
        @weakify(self)
        [[_commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.queueID.length) {
                [[self.viewModel.commitCommand execute:self.queueID] subscribeNext:^(id  _Nullable x) {
                    @strongify(self)
                    [self.refreshSubject sendNext:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }
    return _commitBtn;
}

-(KMEvaluateCommitVM *)viewModel{
    if (!_viewModel) {
    _viewModel                     = [[KMEvaluateCommitVM alloc]init];
    }
    return _viewModel;
}
-(RACSubject *)refreshSubject{
    if (!_refreshSubject) {
    _refreshSubject                = [RACSubject subject];
    }
    return _refreshSubject;
}
@end
