//
//  AppDelegate+KM_AppService.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "AppDelegate+KM_AppService.h"
#import "KMTabBarController.h"
#import "KMIntroductoryPagesHelper.h"
#import <iflyMSC/iflyMSC.h>

@implementation AppDelegate (KM_AppService)

//适配iOS 11
-(void)adaptedIOS11{
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }                  
}

-(void)initService{
    //统一设置TextFeild 光标颜色
    [[UITextField appearance] setTintColor:kMainThemeColor];
    //统一设置TextView 光标颜色
    [[UITextView appearance] setTintColor:kMainThemeColor];

    [[YYTextView appearance] setTintColor:kMainThemeColor];

    //统一设置 防止同时点击按钮
    [[UIButton appearance] setExclusiveTouch:YES];
}

-(void)initWindow{
    self.window                    = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    KMTabBarController *tabBarCtr  = [[KMTabBarController alloc]init];
    self.window.rootViewController = tabBarCtr;
    self.window.backgroundColor    = kBackgroundColor;
    [self.window makeKeyAndVisible];
}
-(void)initSVProgressHUD{
    //默认风格
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMaximumDismissTimeInterval:7];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
}
//设置键盘管理
-(void)setupKeyboardManager{
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}
//设置log
-(void)setupLog{
    [KMLogService start];
}
//开始定位
-(void)startLocating{
//    @weakify(self)
    /** 开启定位 */
    [[KMLocationManager shareInstance] startSystemLocationWithRes:^(CLLocation *loction, NSError *error) {
        if (!error) {
            // 获取当前所在的城市名
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            //根据经纬度反向地理编译出地址信息
            [geocoder reverseGeocodeLocation:loction completionHandler:^(NSArray *array, NSError *error){
                if (array.count > 0){
                    CLPlacemark *placemark = [array objectAtIndex:0];
                    NSString *city = placemark.locality;
                    if (!city) {
                        //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                        city = placemark.administrativeArea;
                    }
                    [NSUserDefaults setObject:city forKey:kLocationCity];
                    KPostNotification(kPositioningSuccess, nil);
                }else if (error == nil && [array count] == 0){
                    KMLog(@"No results were returned.");
                }else if (error != nil){
                    KMLog(@"An error occurred = %@", error);
                }
            }];
            KMLog(@"%@",loction);
        }else{
            KMLog(@"%@",error);
        }
    }];
}

//设置引导页
-(void)setupIntroductoryPage{

    // 1、不是第一次打开APP 2、并且版本号相同 说明不是新版本
    if (KMUserDefault.isNoFirstLaunch && [self.km_version isEqualToString:KMUserDefault.appVersion]) {
        return;
    }

    KMUserDefault.isNoFirstLaunch  = YES;
    KMUserDefault.appVersion       = self.km_version;
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *images                = @[@"引导页1", @"引导页2", @"引导页3", @"引导页4"];
    [KMIntroductoryPagesHelper showIntroductoryPageView:images];

}
//设置UUID
-(void)setupUUID{
    [KMTool UUID];
}

//初始化讯飞SDK
-(void)setupIflySDK{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",iflyAppid];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(UIViewController *)getCurrentVC{

    UIViewController *result       = nil;

    UIWindow * window              = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
    NSArray *windows               = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
    window                         = tmpWin;
                break;
            }
        }
    }

    UIView *frontView              = [[window subviews] objectAtIndex:0];
    id nextResponder               = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
    result                         = nextResponder;
    else
    result                         = window.rootViewController;

    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC     = [self getCurrentVC];

    if ([superVC isKindOfClass:[UITabBarController class]]) {

    UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;

        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {

            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {

            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

-(void)setBadge:(NSInteger)badge{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
}

@end
