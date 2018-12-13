//
//  KMTabBarController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMTabBarController.h"

@interface KMTabBarController ()<UITabBarControllerDelegate>

@end

@implementation KMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 设置TabBar属性数组
    self.tabBarItemsAttributes =[self tabBarItemsAttributesForController];

    /// 设置控制器数组
    self.viewControllers                               = [self getChildControllers];

    NSMutableDictionary *normalAttrs                   = [NSMutableDictionary dictionary];

    normalAttrs[NSForegroundColorAttributeName]        = kFontColorDarkGray;
    normalAttrs[NSFontAttributeName]                   = kFont22;
    NSMutableDictionary *selectedAttrs                 = [NSMutableDictionary dictionary];

    selectedAttrs[NSForegroundColorAttributeName]      = kMainThemeColor;
    selectedAttrs[NSFontAttributeName]                 = normalAttrs[NSFontAttributeName];
    UITabBarItem *appearance                           = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    self.delegate                                      = self;
}

//控制器设置
- (NSArray *)getChildControllers {
    KMHomePageViewController *firstViewController      = [[KMHomePageViewController alloc] init];
    UINavigationController *firstNavigationController  = [[KMBaseNavigationController alloc]
                                                         initWithRootViewController:firstViewController];

    KMGroupViewController *secondViewController        = [[KMGroupViewController alloc] init];
    UINavigationController *secondNavigationController = [[KMBaseNavigationController alloc]
                                                          initWithRootViewController:secondViewController];

    KMQueuingViewController *thirdViewController       = [[KMQueuingViewController alloc] init];
    UINavigationController *thirdNavigationController  = [[KMBaseNavigationController alloc]
                                                         initWithRootViewController:thirdViewController];

    KMMineViewController *fourthViewController         = [[KMMineViewController alloc] init];
    UINavigationController *fourthNavigationController = [[KMBaseNavigationController alloc]
                                                          initWithRootViewController:fourthViewController];

    NSArray *viewControllers                           = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourthNavigationController
                                 ];
    return viewControllers;
}

//TabBar文字跟图标设置
- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes           = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"Bottom-Icona1",
                                                 CYLTabBarItemSelectedImage : @"Bottom-Icona",
                                                 };
    NSDictionary *secondTabBarItemsAttributes          = @{
                                                  CYLTabBarItemTitle : @"号群",
                                                  CYLTabBarItemImage : @"Bottom-Iconb1",
                                                  CYLTabBarItemSelectedImage : @"Bottom-Iconb",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes           = @{
                                                 CYLTabBarItemTitle : @"排号",
                                                 CYLTabBarItemImage : @"Bottom-Iconc1",
                                                 CYLTabBarItemSelectedImage : @"Bottom-Iconc",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes          = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"Bottom-Icond",
                                                  CYLTabBarItemSelectedImage : @"Bottom-Icond1"
                                                  };
    NSArray *tabBarItemsAttributes                     = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;  
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    BOOL ret                                           = YES;
    if (([viewController isEqual:[self.viewControllers objectAtIndex:1]] || [viewController isEqual:self.viewControllers.lastObject]) && !KMUserDefault.isLogin) {
    ret                                                = [KMUserManager checkLoginWithPresent:YES];
    }

    return ret;
}
@end
