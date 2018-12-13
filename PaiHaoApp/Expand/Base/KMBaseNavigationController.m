//
//  KMBaseNavigationController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseNavigationController.h"

@interface KMBaseNavigationController ()

@end

@implementation KMBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed                            = YES;
    }

    if (self.childViewControllers.count > 0) { // 非根控制器
        // 非根控制器才需要设置返回按钮
        // 设置返回按钮
        UIButton *backButton                                               = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"youjiant"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"youjiant"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        if (SystemVersion >= 11.0){
           [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }
        [backButton setFrame:CGRectMake(0, 0, 44, 44)];

        UIBarButtonItem * spaceItem                                        = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //将宽度设为负值
        spaceItem.width                                                    = -20;

        //将两个BarButtonItem都返回给NavigationItem
        viewController.navigationItem.leftBarButtonItems                   = @[spaceItem,[[UIBarButtonItem alloc] initWithCustomView:backButton]];
        //系统的返回按钮隐藏掉
        viewController.navigationController.navigationItem.hidesBackButton = YES;
    }
    // 这个方法才是真正执行跳转
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
-(CGFloat)navHeight{
    UIView *view = [[self.navigationBar subviews] firstObject];
    return view.height;
}
@end
