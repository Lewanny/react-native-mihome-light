//
//  AppDelegate.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
//极光推送
static NSString *appKey = @"f97b4a00b1863cbdda5f4703";
static NSString *channel = @"Publish channel";
static BOOL isProduction = TRUE;//FALSE;

//讯飞科大语音
static NSString *iflyAppid = @"59e1675b";


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

