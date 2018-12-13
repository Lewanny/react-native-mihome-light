//
//  KMBaseViewController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"

@interface KMBaseViewController ()
{
    CGFloat navigationY;
    CGFloat navBarY;
}
@end

@implementation KMBaseViewController

#pragma mark - Lift Cycle
-(id)init
{
    if (self                                                           = [super init]) {
        [self.navigationController.navigationBar setTranslucent:NO];
//        [self.navigationController setNavigationBarHidden:YES];
    navBarY                                                            = 0;
    navigationY                                                        = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars                              = YES;
    [self.navigationController.navigationBar setTranslucent:NO];

    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
    self.edgesForExtendedLayout                                        = UIRectEdgeAll;
    }
    self.automaticallyAdjustsScrollViewInsets                          = NO;

    self.view.backgroundColor                                          = kBackgroundColor;


    if ([self respondsToSelector:@selector(setTitle)]) {
    NSMutableAttributedString *titleAttri                              = [self setTitle];
        [self set_Title:titleAttri];
    }
    if (![self leftButton]) {
        [self configLeftBaritemWithImage];
    }
    if (![self rightButton]) {
        [self configRightBaritemWithImage];
    }
    
//    UITapGestureRecognizer *endTextEditTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTextEdit:)];
//    [self.view addGestureRecognizer:endTextEditTap];

    [self km_addSubviews];
    [self km_settingNavigation];
    [self km_setupSubviewsLayout];
    [self km_bindViewModel];
    [self km_bindEvent];
    [self km_requestData];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (self.navigationController.viewControllers.count > 1) {
    self.navigationController.fd_interactivePopDisabled                = NO;
    }else{
    self.navigationController.fd_interactivePopDisabled                = YES;;
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self km_layoutSubviews];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    [self km_didDisappearCancelRequest];
}

-(void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - StatusBarStyle
// 返回状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
// 控制状态栏的现实与隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark - Nav
-(void)setNavigationBack:(UIImage*)image {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
-(void)changeNavigationBarHeight:(CGFloat)offset {
    [UIView animateWithDuration:0.3f animations:^{
    self.navigationController.navigationBar.frame                      = CGRectMake(
                                                                    self.navigationController.navigationBar.frame.origin.x,
                                                                    navigationY,
                                                                    self.navigationController.navigationBar.frame.size.width,
                                                                    offset
                                                                    );
    }];
}

-(void)changeNavigationBarTranslationY:(CGFloat)translationY {
    self.navigationController.navigationBar.transform                  = CGAffineTransformMakeTranslation(0, translationY);
}
/** 默认导航栏 */
-(UIImage *)navBackgroundImage {
    return [UIImage imageWithColor:kMainThemeColor];
}

#pragma mark --- Title

-(void)set_Title:(NSMutableAttributedString *)title {
    UILabel *navTitleLabel                                             = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 44)];
    navTitleLabel.numberOfLines                                        = 0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment                                        = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor                                      = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled                               = YES;

    UITapGestureRecognizer *tap                                        = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView                                      = navTitleLabel;
    [self.navigationItem.titleView sizeToFit];
    [self.navigationItem.titleView layoutIfNeeded];
}


-(void)titleClick:(UIGestureRecognizer*)Tap {
    UIView *view                                                       = Tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}

#pragma mark -- Nav_Left_Item
-(void)configLeftBaritemWithImage {
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)]) {
    UIImage *image                                                     = [self set_leftBarButtonItemWithImage];
    UIBarButtonItem *item                                              = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(left_click:)];
    self.navigationItem.backBarButtonItem                              = item;
    }
}

-(void)configRightBaritemWithImage {
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
    UIImage *image                                                     = [self set_rightBarButtonItemWithImage];
    UIBarButtonItem *item                                              = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(right_click:)];
    self.navigationItem.rightBarButtonItem                             = item;
    }
}


#pragma mark -- Nav_Left_Button
-(BOOL)leftButton {
    BOOL isleft                                                        = [self respondsToSelector:@selector(set_leftButton)];
    if (isleft) {
    UIButton *leftbutton                                               = [self set_leftButton];
        [leftbutton addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item                                              = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
        //调整按钮位置
    UIBarButtonItem* spaceItem                                         = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //将宽度设为负值
    spaceItem.width                                                    = -10;
    self.navigationItem.leftBarButtonItems                             = @[spaceItem, item];
    }
    return isleft;
}

#pragma mark -- Nav_Right_Button
-(BOOL)rightButton {
    BOOL isright                                                       = [self respondsToSelector:@selector(set_rightButton)];
    if (isright) {
    UIButton *right_button                                             = [self set_rightButton];
        [right_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item                                              = [[UIBarButtonItem alloc] initWithCustomView:right_button];
    self.navigationItem.rightBarButtonItem                             = item;
    }
    return isright;
}


-(void)left_click:(id)sender {
    if ([self respondsToSelector:@selector(left_button_event:)]) {
        [self left_button_event:sender];
    }
}

-(void)right_click:(id)sender {
    if ([self respondsToSelector:@selector(right_button_event:)]) {
        [self right_button_event:sender];
    }
}


#pragma mark - 收起键盘
//-(void)endTextEdit:(UITapGestureRecognizer *)tap{
//    [self.view endEditing:YES];
//}

#pragma mark - BaseViewControllerInterface
/** 添加子视图 */
-(void)km_addSubviews{}
/** 设置约束 */
-(void)km_setupSubviewsLayout{}
/** 在系统 layoutSubviews 时会调用 */
-(void)km_layoutSubviews{}
/** 绑定ViewModel */
-(void)km_bindViewModel{}
/** 绑定一些事件 */
-(void)km_bindEvent{}
/** 发起数据请求 */
-(void)km_requestData{}
/** 发起刷新请求  自行调用 */
-(void)km_refreshData{}
/** 取消网络请求 */
-(void)km_didDisappearCancelRequest{}
/** 设置导航栏 */
-(void)km_settingNavigation{
    //设置导航栏背景色
    self.navigationController.navigationBar.barTintColor = kMainThemeColor;
}
/** 配置TableViewCell 自行调用 */
-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - Lazy
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
