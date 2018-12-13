//
//  KMLoggerFormatter.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMLoggerFormatter.h"

@implementation KMLoggerFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *logLevel = nil;
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel = @"[ERROR]❤️ ";
            break;
        case DDLogFlagWarning:
            logLevel = @"[WARN]💛 ";
            break;
        case DDLogFlagInfo:
            logLevel = @"[INFO]💙 ";
            break;
        case DDLogFlagDebug:
            logLevel = @"[DEBUG]💚 ";
            break;
        default:
            logLevel = @"[VBOSE]💜 ";
            break;
    }
    
    NSString *formatStr
    = [NSString stringWithFormat:@"%@ %@ [%@][line %ld] %@ %@", logLevel, [logMessage.timestamp stringWithFormat:@"yyyy-MM-dd HH:mm:ss.S"], logMessage.fileName, logMessage.line, logMessage.function, logMessage.message];
    return formatStr;
}

@end
