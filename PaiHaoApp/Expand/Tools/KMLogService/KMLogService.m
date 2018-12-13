//
//  KMLogService.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMLogService.h"

@implementation KMLogService
+ (void)start {
    [self sharedInstance];
}

+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
//        [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
        //设置输出的LOG样式
        KMLoggerFormatter* formatter = [[KMLoggerFormatter alloc] init];
        [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    }
    return self;
}



@end
