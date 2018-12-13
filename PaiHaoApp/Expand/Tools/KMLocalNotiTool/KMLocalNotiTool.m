//
//  KMLocalNotiTool.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMLocalNotiTool.h"
#import <UserNotifications/UserNotifications.h>

#define kIdentifier @"identifier"

@implementation KMLocalNotiTool
/** 单例 */
static KMLocalNotiTool *tool;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    tool                                       = [[KMLocalNotiTool alloc] init];
    });
    return tool;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    tool                                       = [super allocWithZone:zone];
    });
    return tool;
}

/**
 创建一个本地通知

 @param title       标题
 @param content     内容
 @param info        附带信息
 @param identifier  标识
 @param delay       延迟多少秒
 */
//-(void)createNotificationWithTitle:(NSString *)title
//                           content:(NSString *)content
//                              info:(NSDictionary *)info
//                        identifier:(NSString *)identifier
//                             delay:(NSInteger)delay{
//
//    //如果有同样标识的 先取消
//    [self cancelLocalNotificationWithIdentifier:identifier];
//    //把标识添加进去
//    NSMutableDictionary *infoM                 = info.mutableCopy;
//    [infoM setObject:identifier forKey:kIdentifier];
//    info                                       = info.copy;
//
//    if (SystemVersion >= 10.0) {
//        [self km_createNotificationWithTitle:title
//                                     content:content
//                                        info:info
//                                  identifier:identifier
//                                       delay:delay];
//    }else{
//
//    }
//}

//iOS 10 以后 使用 UNNotification 本地通知
//-(void)km_createNotificationWithTitle:(NSString *)title
//                              content:(NSString *)content
//                                 info:(NSDictionary *)info
//                           identifier:(NSString *)identifier
//                                delay:(NSInteger)delay{
//    // 使用 UNUserNotificationCenter 来管理通知
//    UNUserNotificationCenter* center           = [UNUserNotificationCenter currentNotificationCenter];
//    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
//    UNMutableNotificationContent* nContent     = [[UNMutableNotificationContent alloc] init];
//    nContent.title                             = title;
//    nContent.body                              = content;
//    nContent.sound                             = [UNNotificationSound defaultSound];
//
//    // 在 alertTime 后推送本地推送
//    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
//                                                  triggerWithTimeInterval:delay repeats:NO];
//
//    UNNotificationRequest* request             = [UNNotificationRequest requestWithIdentifier:identifier
//                                                                          content:nContent trigger:trigger];
//    //添加推送成功后的处理！
//    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//        //提示
//    UIAlertController *alert                   = [UIAlertController alertControllerWithTitle:@"提示" message:error == nil ? @"添加提醒成功" : @"添加提醒失败" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction                = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancelAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//    }];
//}

//iOS 8 以后  本地通知
//-(void)km_oldWayCreateNotificationWithTitle:(NSString *)title
//                                    content:(NSString *)content
//                                       info:(NSDictionary *)info
//                                 identifier:(NSString *)identifier
//                                      delay:(NSInteger)delay{
//    // ios8后，需要添加这个注册，才能得到授权
//    // if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//    // UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//    // UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
//    // categories:nil];
//    // [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    // // 通知重复提示的单位，可以是天、周、月
//    // }
//
//
//
//    UILocalNotification *notification          = [[UILocalNotification alloc] init];
//    // 设置触发通知的时间
//    NSDate *fireDate                           = [NSDate dateWithTimeIntervalSinceNow:delay];
//
//    notification.fireDate                      = fireDate;
//    // 时区
//    notification.timeZone                      = [NSTimeZone defaultTimeZone];
//    // 设置重复的间隔
////    notification.repeatInterval = kCFCalendarUnitSecond;
//
//    // 通知内容
//    notification.alertBody                     = content;
//    notification.applicationIconBadgeNumber    = 1;
//    // 通知被触发时播放的声音
//    notification.soundName                     = UILocalNotificationDefaultSoundName;
//    // 通知参数
//    notification.userInfo                      = info;
//
//    // ios8后，需要添加这个注册，才能得到授权
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//    UIUserNotificationType type                = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//    UIUserNotificationSettings *settings       = [UIUserNotificationSettings settingsForTypes:type
//                                                                                 categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//
//    } else {
//
//    }
//    // 执行通知注册
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//}


/**
 根据标识取消本地通知

 @param identifier 标识
 */
//-(void)cancelLocalNotificationWithIdentifier:(NSString *)identifier{
//    if (SystemVersion >= 10) {
//        // 使用 UNUserNotificationCenter 来管理通知
//    UNUserNotificationCenter* center           = [UNUserNotificationCenter currentNotificationCenter];
//        //先移除之前相同标识的本地通知
//        [center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
//    }else{
//        // 获取所有本地通知数组
//    NSArray *localNotifications                = [UIApplication sharedApplication].scheduledLocalNotifications;
//        for (UILocalNotification *notification in localNotifications) {
//    NSDictionary *userInfo                     = notification.userInfo;
//            if (userInfo) {
//                // 根据设置通知参数时指定的key来获取通知参数
//    NSString *idString                         = userInfo[kIdentifier];
//                // 如果找到需要取消的通知，则取消
//                if (idString != nil && [idString isEqualToString:identifier]) {
//                    [[UIApplication sharedApplication] cancelLocalNotification:notification];
//                    break;
//                }
//            }
//        }
//    }
//}
+(void)showLocalNoti:(NSDictionary *)userInfo{
    
}
@end
