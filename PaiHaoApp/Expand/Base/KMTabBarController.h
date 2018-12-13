//
//  KMTabBarController.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <CYLTabBarController/CYLTabBarController.h>

#import "KMBaseNavigationController.h"

//4个控制器
#import "KMHomePageViewController.h"//首页
#import "KMGroupViewController.h"   //队列
#import "KMQueuingViewController.h" //排号
#import "KMMineViewController.h"    //我的 

@interface KMTabBarController : CYLTabBarController

@end
