//
//  KMTool.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMTool.h"
#import "KMMerchantTypeModel.h"
#import <UserNotifications/UserNotifications.h>
@implementation KMTool

/** 拨打电话 */
+(void)callWithTel:(NSString *)tel{
    if (tel.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"电话号码为空" Duration:1];
        return;
    }

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView * callWebview                    = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].view addSubview:callWebview];

}

/** 把奇怪的字典格式数组 转成正常的字典数组 */
+(NSArray *)normalDictArrWithWeirdDictArr:(NSArray *)weirdDictArr{
    if (weirdDictArr  == nil || weirdDictArr.count == 0) {
        return nil;
    }
    NSMutableArray *arrM                       = [NSMutableArray array];
    for (NSDictionary *dict in weirdDictArr) {
        [arrM addObject:[KMTool normalDictWithWeirdDict:dict]];
    }
    return arrM;
}

/** 把奇怪的字典格式数组 转成正常的字典 */
+(NSDictionary *)normalDictWithWeirdDictArr:(NSArray *)weirdDictArr{
    if (weirdDictArr  == nil || weirdDictArr.count == 0) {
        return nil;
    }
    NSMutableDictionary *dictM                 = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in weirdDictArr) {
        [dictM addEntriesFromDictionary:[KMTool normalDictWithWeirdDict:dict]];
    }
    return dictM;
}

/** 把奇怪的字典格式 转成正常的字典 */
+(NSDictionary *)normalDictWithWeirdDict:(NSDictionary *)weirdDict{
    NSMutableDictionary *normalDict            = [NSMutableDictionary dictionary];
    NSString *key                              = [weirdDict objectForKey:@"name"];
    NSString *value                            = [weirdDict objectForKey:@"value"];
    [normalDict setObject:value forKey:key];
    return normalDict;
}

/** 把正常的字典格式 转成奇怪的字典数组 keyOrder key的次序 */
+(NSArray *)weirdDictWithNormalDict:(NSDictionary *)normalDict
                       WithKeyOrder:(NSArray *)keyOrder{

    NSMutableArray *arrM                       = [NSMutableArray array];

    for (NSString *keyStr in keyOrder) {
        NSAssert([normalDict.allKeys containsObject:keyStr], @"normalDict 里未包含此key值");
    NSMutableDictionary *weirdDict             = [NSMutableDictionary dictionary];
        [weirdDict setObject:keyStr forKey:kName];
        [weirdDict setObject:[normalDict objectForKey:keyStr] forKey:kValue];
        [arrM addObject:weirdDict];
    }

    return arrM;
}

/** 把正常的字典格式 转成奇怪的字典数组 keyOrder key的次序 */
+(NSArray *)weirdDictWithKeys:(NSArray<NSString *> *)keys
                      Objects:(NSArray<NSString *> *)objects{
    NSMutableArray *arrM                       = [NSMutableArray array];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
    NSMutableDictionary *weirdDict             = [NSMutableDictionary dictionary];
        [weirdDict setObject:key forKey:kName];
        [weirdDict setObject:[objects objectAtIndex:idx] forKey:kValue];
        [arrM addObject:weirdDict];
    }];
    return arrM;
}
/** 把正常的字典格式 转成奇怪的字典数组 */

+(NSArray *)weirdDictWithDictionarys:(NSDictionary *)dictionarys,...NS_REQUIRES_NIL_TERMINATION{
    NSMutableArray *arrM                       = [NSMutableArray array];
    NSDictionary *dict                         = nil;
    va_list args;
    if (dictionarys) {//第一个参数不在list里面
        [arrM addObject:[KMTool weirdDictWithNormalDict:dictionarys]];
        va_start(args, dictionarys);
    while ((dict                               = va_arg(args, NSDictionary*))) {
            [arrM addObject:[KMTool weirdDictWithNormalDict:dict]];
        }
        va_end(args);
    }
    return arrM;
}

+(NSDictionary *)weirdDictWithNormalDict:(NSDictionary *)normalDict{
    NSAssert(normalDict.allKeys.count == 1, @"字典里只能包含一对键值对");
    NSMutableDictionary *weirdDict             = [NSMutableDictionary dictionary];
    [weirdDict setObject:normalDict.allKeys.firstObject forKey:kName];
    [weirdDict setObject:normalDict.allValues.firstObject forKey:kValue];
    return weirdDict;
}

/** 从奇怪的字典数组里取值 */
+(NSString *)valueForName:(NSString *)name InArr:(NSArray *)arr{
    NSString *value                            = @"";
    for (NSDictionary *weirdDict in arr) {
        if ([[weirdDict objectForKey:kName] isEqualToString:name]) {
    value                                      = [weirdDict objectForKey:kValue];
            break;
        }
    }
    return value;
}


/** 保存行业分类信息 */
+(void)saveCategoryType:(NSArray *)categoryType{
    [NSUserDefaults setArcObject:categoryType forKey:kCategoryType];
}
/** 返回行业分类信息 */
+(NSArray *)getCategoryType{
    return [NSUserDefaults arcObjectForKey:kCategoryType];
}
/** 根据ID返回对应名称 */
+(NSString *)categoryNameWithID:(NSString *)categoryID{
    NSString *name                             = @"";
    NSArray * arr                              = [KMTool getCategoryType];
    for (KMMerchantTypeModel * model in arr) {
        if ([model.ID isEqualToString:categoryID]) {
    name                                       = model.typeName;
            break;
        }
    }
    return name;
}
/** 根据name返回对应ID */
+(NSString *)categoryIDWithName:(NSString *)categoryName{
    NSString *ID                               = @"";
    NSArray * arr                              = [KMTool getCategoryType];
    for (KMMerchantTypeModel * model in arr) {
        if ([model.typeName isEqualToString:categoryName]) {
    ID                                         = model.ID;
            break;
        }
    }
    return ID;
}


/** 设置AttributedString */
+(NSMutableAttributedString *)attributedFullStr:(NSString *)fullStr
                              FullStrAttributes:(NSDictionary *)fullStrAttributes
                                       RangeStr:(NSString *)rangeStr
                             RangeStrAttributes:(NSDictionary *)rangeStrAttributes
                                        Options:(NSStringCompareOptions)options{

    NSMutableAttributedString *attr            = [[NSMutableAttributedString alloc]initWithString:fullStr];
    [attr addAttributes:fullStrAttributes range:[fullStr rangeOfString:fullStr]];
    [attr addAttributes:rangeStrAttributes range:[fullStr rangeOfString:rangeStr]];
    return attr;
}

//使用 UNNotification 本地通知
+(void)registerNotification:(NSInteger )alerTime{

    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center           = [UNUserNotificationCenter currentNotificationCenter];

    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content      = [[UNMutableNotificationContent alloc] init];
    content.title                              = [NSString localizedUserNotificationStringForKey:@"Hello!" arguments:nil];
    content.body                               = [NSString localizedUserNotificationStringForKey:@"Hello_message_body"
                                                         arguments:nil];
    content.sound                              = [UNNotificationSound defaultSound];

    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:alerTime repeats:NO];

    UNNotificationRequest* request             = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];

    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    UIAlertController *alert                   = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction                = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}

+ (void)registerLocalNotificationInOldWay:(NSInteger)alertTime {
    // ios8后，需要添加这个注册，才能得到授权
    // if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    // UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    // UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
    // categories:nil];
    // [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // // 通知重复提示的单位，可以是天、周、月
    // }

    UILocalNotification *notification          = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate                           = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);

    notification.fireDate                      = fireDate;
    // 时区
    notification.timeZone                      = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval                = kCFCalendarUnitSecond;

    // 通知内容
    notification.alertBody                     = @"该起床了...";
    notification.applicationIconBadgeNumber    = 1;
    // 通知被触发时播放的声音
    notification.soundName                     = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict                     = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    notification.userInfo                      = userDict;

    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    UIUserNotificationType type                = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings       = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
//        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
//        notification.repeatInterval = NSDayCalendarUnit;
    }

    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

/** 获取UUID */
+(NSString *)UUID{
    //1 获取之前保存的UUID
    NSString *UUID = [YYKeychain getPasswordForService:@"com.km.PaiHaoApp" account:@"km"];
    
    //2 没获取到
    if (UUID == nil || UUID.length == 0) {
        
        // 3 重新生成
        UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        //4 保存
        BOOL ret = [YYKeychain setPassword:UUID forService:@"com.km.PaiHaoApp" account:@"km"];
        KMLog(@"保存%@",ret ? @"成功" : @"失败");
    }
    KMLog(@"UUID = %@",UUID);
    return UUID;
}

@end
