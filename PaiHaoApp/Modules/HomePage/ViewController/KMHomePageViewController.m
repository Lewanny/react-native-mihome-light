//
//  KMHomePageViewController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHomePageViewController.h"
#import "KMHomePageUIService.h"
#import "KMHomePageViewModel.h"

#import "WZLBadgeImport.h"


#import "KMCategoryGroupController.h"       //行业类型
#import "KMRegisterController.h"            //注册
#import "KMGroupQueueInfoVC.h"              //我的排号详情

#import "KMGroupSearchVC.h"                 //搜索
#import "KMQRScanVC.h"                      //扫描二维码
#import "KMGroupQueueDetail.h"              //号群详情

#import "KMMyMessageVC.h"                   //我的消息

#import "KMCitySelectTool.h"                //城市选择工具


@interface KMHomePageViewController ()

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) UIButton * searchBtn;

@property (nonatomic, strong) UIButton * messageBtn;

@property (nonatomic, strong) KMHomePageUIService * service;

@property (nonatomic, strong) KMHomePageViewModel * viewModel;

@end

@implementation KMHomePageViewController
#pragma mark - Lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.service resetHeader];
    [self km_refreshData];
    [self refreshNavCity];
    [self setupNavAlphaWithOfferY:self.collectionView.contentOffset.y];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self setupNavAlphaWithOfferY:self.collectionView.contentOffset.y];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self setupNavAlphaWithOfferY:self.collectionView.contentOffset.y];
//    });
}

#pragma mark - Private Method
-(void)setupNavRightButton{

    _messageBtn                                 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_messageBtn setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
    [_messageBtn setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateHighlighted];
    _messageBtn.frame                                     = CGRectMake(0, 0, 30, 44);
    _messageBtn.badgeBgColor = kAppRedColor;
    _messageBtn.badgeTextColor = [UIColor whiteColor];
    _messageBtn.badgeFont = kFont22;
    _messageBtn.badgeCenterOffset = CGPointMake(-5, 10);
    [_messageBtn setBadgeMaximumBadgeNumber:99];
    [_messageBtn clearBadge];
    [_messageBtn addTarget:self action:@selector(pushMyMessageVC) forControlEvents:UIControlEventTouchUpInside];

    UIButton *scanBtn                                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateNormal];
    [scanBtn setImage:[UIImage imageNamed:@"saoyisao"] forState:UIControlStateHighlighted];
    scanBtn.frame                                        = CGRectMake(0, 0, 30, 44);
    @weakify(self)
    [[scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushQRScanVC];
    }];


    UIBarButtonItem *item1                               = [[UIBarButtonItem alloc]initWithCustomView:_messageBtn];
    UIBarButtonItem *item2                               = [[UIBarButtonItem alloc]initWithCustomView:scanBtn];

    //调整按钮位置
    UIBarButtonItem* spaceItem                           = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width                                      = -5;
    self.navigationItem.rightBarButtonItems              = @[spaceItem, item1, item2];
}
-(void)setupNavLeftButton{

    //调整按钮位置
    UIBarButtonItem* spaceItem                           = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width                                      = -10;

    UIButton *locationBtn                                = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setImage:[UIImage imageNamed:@"xiajta"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"xiajta"] forState:UIControlStateHighlighted];
    [locationBtn setTitle:@"正在定位" forState:UIControlStateNormal];
    [locationBtn setTitle:@"正在定位" forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(citySelect) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.frame                                    = CGRectMake(0, 0, 80, 44);
    locationBtn.titleLabel.font                          = kFont28;
    locationBtn.titleLabel.lineBreakMode                 = NSLineBreakByTruncatingTail;
    [locationBtn setAdjustsImageWhenHighlighted:NO];
    [locationBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    if (SystemVersion >= 11.0){
        [locationBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    [locationBtn jk_setImagePosition:LXMImagePositionRight spacing:10];
    UIBarButtonItem *item                                = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];
    self.navigationItem.leftBarButtonItems               = @[spaceItem, item];
}

-(void)setupNavTitleView{
    //白色背景
    UIView *background                                   = [UIView new];
    background.frame                                     = CGRectMake(0, 0, KScreenWidth, AdaptedHeight(56));
    background.backgroundColor                           = [UIColor whiteColor];

    UIImage *souImage                                    = [UIImage imageNamed:@"sousuo"];
    NSString *souString                                  = @"关键字、号群名称/ID";

    UIButton *btn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置按钮图片
    [btn setImage:souImage
         forState:UIControlStateNormal];
    [btn setImage:souImage
         forState:UIControlStateHighlighted];
    //设置按钮标题
    [btn setTitle:souString
         forState:UIControlStateNormal];
    [btn setTitle:souString
         forState:UIControlStateHighlighted];
    //设置按钮文字颜色
    [btn setTitleColor:kFontColorGray
              forState:UIControlStateNormal];
    [btn setTitleColor:kFontColorGray
              forState:UIControlStateHighlighted];
    //按钮文字字体
    btn.titleLabel.font                                  = kFont24;;

    btn.frame                                            = background.bounds;

    [btn jk_setImagePosition:LXMImagePositionLeft spacing:10];
    
    [background addSubview:btn];
    _searchBtn = btn;
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushGroupSearch];
    }];

    self.navigationItem.titleView                        = background;
}

-(void)setupNavAlphaWithOfferY:(CGFloat)offerY{
    CGFloat alpha                                        = offerY * 1.0 / kNavHeight;
    if (alpha < 0) {
    alpha                                                = 0;
    }
    if (alpha > 1) {
    alpha                                                = 1;
    }
    UIView *view = [[self.navigationController.navigationBar subviews] objectAtIndex:0];
    view.alpha != alpha ? [view setAlpha:alpha] : nil;
}

-(void)refreshNavCity{
    UIButton *btn                                        = [self.navigationItem.leftBarButtonItems[1] customView];
    if (btn) {
    NSString *locationCity                               = [NSUserDefaults stringForKey:kLocationCity];
    NSString *currentCity                                = [NSUserDefaults stringForKey:kCurrentCity];
    NSString *city                                       = currentCity ? currentCity : locationCity;
        if (city.length > 4) {
            city                                                 = [city substringToIndex:3];
            city                                                 = [city stringByAppendingString:@"..."];
            
        }
        [btn setTitle:city ? city : @"定位中" forState:UIControlStateNormal];
        [btn setTitle:city ? city : @"定位中" forState:UIControlStateHighlighted];
        [btn jk_setImagePosition:LXMImagePositionRight spacing:10];
        [btn layoutIfNeeded];
    }
}

-(void)citySelect{
    [KMCitySelectTool presentCitySelectVC];
}

#pragma mark - Push
//行业类型
-(void)pushCategoryListWithID:(NSString *)categoryID{
    KMCategoryGroupController *vc                  = [[KMCategoryGroupController alloc]init];
    vc.categoryID                                  = categoryID;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
//我的排号
-(void)pushMineQueueInfoWithGroupID:(NSString *)groupID QueueID:(NSString *)queueID{
    KMGroupQueueInfoVC *vc                               = [[KMGroupQueueInfoVC alloc]init];
    vc.groupID                                           = groupID;
    vc.queueID                                           = queueID;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
//号群搜索
-(void)pushGroupSearch{
    KMGroupSearchVC *vc                                  = [[KMGroupSearchVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
//二维码扫描
-(void)pushQRScanVC{
    KMQRScanVC *vc                                       = [[KMQRScanVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
//我的消息
-(void)pushMyMessageVC{
    if ([KMUserManager checkLoginWithPresent:YES]) {
    KMMyMessageVC *vc                                    = [[KMMyMessageVC alloc]init];
        [self.navigationController cyl_pushViewController:vc animated:YES];
    }
}


#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.collectionView];
    [self setupNavRightButton];
    [self setupNavLeftButton];
    [self setupNavTitleView];
    
}
-(void)km_layoutSubviews{
    UIView *titleView = self.navigationItem.titleView;
    if (titleView) {
        [titleView sizeToFit];
        [titleView layoutIfNeeded];
        [titleView setRoundedCorners:UIRectCornerAllCorners
                                                  radius:titleView.height / 2.0];
        [_searchBtn setFrame:titleView.bounds];
    }
}
-(void)km_refreshData{
    [self.viewModel.requestCategory execute:nil];
    //登录判断
    if (KMUserDefault.isLogin) {
        @weakify(self)
        [[self.viewModel.messagesNumberCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.messageBtn showBadgeWithStyle:WBadgeStyleNumber value:self.viewModel.messageCount animationType:WBadgeAnimTypeNone];
        }];
    }
}


-(void)km_bindViewModel{
    @weakify(self);
    //适配iOS 11 适配iPhone X 系统在跳转之前和pop回来之后会自动修改NavBar的透明度为1
    UIView *view = [[self.navigationController.navigationBar subviews] objectAtIndex:0];
    RACSignal *navSig = RACObserve(view, alpha);
    [navSig subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        CGFloat offsetY = self.collectionView.contentOffset.y;
        if ([x floatValue] == 1 && offsetY < kNavHeight) {
//            KMLog(@"x = %@",x);
            [self setupNavAlphaWithOfferY:offsetY];
        }
    }];
    //监听滑动
    [self.service.didScrollSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self setupNavAlphaWithOfferY:[x floatValue]];
    }];

    [self.service.pushCategoryList subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushCategoryListWithID:x];
    }];

    [self.service.pushMineQueueVC subscribeNext:^(RACTuple * x) {
        @strongify(self)
    RACTupleUnpack(NSString *groupID, NSString *queueID) = x;
        [self pushMineQueueInfoWithGroupID:groupID QueueID:queueID];
    }];

    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            [self.collectionView reloadData];
        });
    }];
}

-(void)km_bindEvent{
    @weakify(self)
    [[kNotificationCenter rac_addObserverForName:kPositioningSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
    NSString *locationCity                               = [NSUserDefaults stringForKey:kLocationCity];
    NSString *currentCity                                = [NSUserDefaults stringForKey:kCurrentCity];
        if (locationCity && currentCity && ![locationCity isEqualToString:currentCity]) {
            [KMCitySelectTool loadAreaData:currentCity CallBack:^(NSArray *areaArr) {
    __block BOOL ret                                     = NO;
                [areaArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isEqualToString:currentCity] || [obj containsString:currentCity] || [currentCity containsString:obj]) {
    ret                                                  = YES;
    *stop                                                = YES;
                    }
                }];
                //市 和 区县 都不对应
                if (!ret) {
                    [LBXAlertAction showAlertWithTitle:@"提示" msg:NSStringFormat(@"当前定位城市: %@ , 是否切换城市?",locationCity) buttonsStatement:@[@"取消", @"切换"] chooseBlock:^(NSInteger buttonIdx) {
                        if (buttonIdx == 1) {
                            @strongify(self)
                            [KMCitySelectTool didSelectCity:locationCity];
                            [self refreshNavCity];
                        }
                    }];
                }
            }];
        }else{
           [self refreshNavCity];
        }
    }];
}

//-(void)km_settingNavigation{
//    [super km_settingNavigation];
//    [self setupNavAlphaWithOfferY:self.collectionView.contentOffset.y];
//}
#pragma mark - Lazy

-(UICollectionView *)collectionView{
    if (!_collectionView) {

    UICollectionViewFlowLayout *layout                   = [[UICollectionViewFlowLayout alloc]init];

    _collectionView                                      = [[UICollectionView alloc]initWithFrame:CGRectMake(
                                                                           0,
                                                                           0,
                                                                           KScreenWidth,
                                                                            KScreenHeight - kTabBarHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor                      = kBackgroundColor;
    _collectionView.alwaysBounceVertical                 = YES;
        //如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
#ifdef __IPHONE_11_0
        if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
#endif
    }
    return _collectionView;
}

-(KMHomePageUIService *)service{
    if (!_service) {
    _service                                             = [[KMHomePageUIService alloc] initWithCollectionView:self.collectionView];
    _service.viewModel                                   = self.viewModel;
    }
    return _service;
}
-(KMHomePageViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                                           = [KMHomePageViewModel new];
    }
    return _viewModel;
}
@end
