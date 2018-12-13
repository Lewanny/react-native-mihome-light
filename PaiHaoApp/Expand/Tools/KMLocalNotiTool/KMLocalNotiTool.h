//
//  KMLocalNotiTool.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 本地推送工具 */
@interface KMLocalNotiTool : NSObject

/** 单例 */
+ (instancetype)shareInstance;

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
//                             delay:(NSInteger)delay;
/**
 根据标识取消本地通知
 
 @param identifier 标识
 */
//-(void)cancelLocalNotificationWithIdentifier:(NSString *)identifier;

+(void)showLocalNoti:(NSDictionary *)userInfo;

@end
