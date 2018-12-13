//
//  AppDelegate+KM_AppService.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate.h"
#import "KMLogService.h"

@interface AppDelegate (KM_AppService)

//初始化服务
-(void)initService;

//初始化 window
-(void)initWindow;

//设置SVProgressHUD
-(void)initSVProgressHUD;

//开始定位
-(void)startLocating;

//设置引导页
-(void)setupIntroductoryPage;

//设置键盘管理
-(void)setupKeyboardManager;
//设置log
-(void)setupLog;

//设置UUID
-(void)setupUUID;

//适配iOS 11
-(void)adaptedIOS11;

//初始化讯飞SDK
-(void)setupIflySDK;

//单例
+ (AppDelegate *)shareAppDelegate;
/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;

-(void)setBadge:(NSInteger)badge;

@end
