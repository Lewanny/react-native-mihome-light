//
//  KM_UtilsMacors.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#ifndef KM_UtilsMacors_h
#define KM_UtilsMacors_h

//-------------------打印日志-------------------------

#if PRODUCT  //产品环境

//输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)
#define KMLog(...) DDLogVerbose(__VA_ARGS__)

#else   //其它环境

//输出转换成DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__)
#define KMLog(...) DDLogVerbose(__VA_ARGS__)

#endif

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif



//#ifdef DEBUG
//#define KMLog(format, ...) \
//    do { \
//        NSLog(@"<%@ : %d : %s>-: %@", \
//        [[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
//        __LINE__, \
//        __FUNCTION__, \
//        [NSString stringWithFormat:format, ##__VA_ARGS__]); \
//    } while(0)
//#else
//#define KMLog(format, ...) do{ } while(0)
//#endif


//App版本号
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 当前版本
#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kScreen_Bounds ([UIScreen mainScreen].bounds)

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,eky) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//获取图片
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

//在Main线程上运行
#define DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

// 是否大于等于IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
// 是否大于等于IOS8
#define isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
// 是否大于IOS9
#define isIOS9                  ([[[UIDevice currentDevice]systemVersion]floatValue] >=9.0)
// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//是否iPhone X
#define isiPhoneX               (MAX(KScreenWidth, KScreenHeight) == 812.0)

//导航栏默认标题属性
#define kNavTitleAttributes @{NSFontAttributeName : kNavFont, NSForegroundColorAttributeName : kNavFontColor}

//从Storyboard 获取控制器
#define ViewControllFromStoryboard(StoryboardName, Identifier) [[UIStoryboard storyboardWithName:StoryboardName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:Identifier]
//获取一个根导航栏控制器
#define BaseNavigationWithRootVC(VC) [[KMBaseNavigationController alloc]initWithRootViewController:VC]
//获取完整图片地址
#define ImageFullUrlWithUrl(url) [KM_NetworkApi.imagePrefixUrl stringByAppendingString:url]

//获取普通占位图
#define GetNormalPlaceholderImage [UIImage imageNamed:@"tupp"]
//获取头像占位图
#define GetHeaderPlaceholderImage [UIImage imageNamed:@"touxa"]
//默认没有数据提示图
#define DefluatEmptyImage [UIImage imageNamed:@"zhuantai"]

//获取Error Msg
#define GetErrorMsg(error) [error.userInfo objectForKey:kErrmsg]

//Nav 标题
#define KMBaseNavTitle(title) [[NSMutableAttributedString alloc]initWithString:title?title:@"" attributes:kNavTitleAttributes]


//#define KM_TupleUnpack RACTupleUnpack(NSString * actionName, NSNumber * status, NSNumber * timeStamp, NSString * token, NSArray  * paramsSet, NSArray  * entrySet)

#endif /* KM_UtilsMacors_h */
