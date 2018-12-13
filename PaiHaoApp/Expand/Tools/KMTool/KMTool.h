//
//  KMTool.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMTool : NSObject

/** 拨打电话 */
+(void)callWithTel:(NSString *)tel;


/** 把奇怪的字典格式数组 转成正常的字典数组 */
+(NSArray *)normalDictArrWithWeirdDictArr:(NSArray *)weirdDictArr;
/** 把奇怪的字典格式数组 转成正常的字典 */
+(NSDictionary *)normalDictWithWeirdDictArr:(NSArray *)weirdDictArr;
/** 把奇怪的字典格式 转成正常的字典 */
+(NSDictionary *)normalDictWithWeirdDict:(NSDictionary *)weirdDict;

///** 把正常的字典格式数组 转成奇怪的字典数组 */
//+(NSArray *)weirdDictWithNormalDictArr:(NSArray *)normalDictArr;
/** 把正常的字典格式 转成奇怪的字典数组 keyOrder key的次序 */
+(NSArray *)weirdDictWithNormalDict:(NSDictionary *)normalDict
                       WithKeyOrder:(NSArray *)keyOrder;
/** 把正常的字典格式 转成奇怪的字典数组 */
+(NSArray *)weirdDictWithKeys:(NSArray<NSString *> *)keys
                      Objects:(NSArray<NSString *> *)objects;

/** 把正常的字典格式 转成奇怪的字典数组 */
+(NSArray *)weirdDictWithDictionarys:(NSDictionary *)dictionarys,...NS_REQUIRES_NIL_TERMINATION;


/** 从奇怪的字典数组里取值 */
+(NSString *)valueForName:(NSString *)name InArr:(NSArray *)arr;

//+(NSString *)valueForName:(NSString *)name InDict:(NSDictionary *)dict;

//+(NSArray<NSString *> *)allNameInArr:(NSArray *)arr;
//
//+(NSArray<NSString *> *)allValueInArr:(NSArray *)arr;
//
//+(NSArray<NSString *> *)allNameInDict:(NSDictionary *)dict;
//
//+(NSArray<NSString *> *)allValueInDict:(NSDictionary *)dict;

/** 保存行业分类信息 */
+(void)saveCategoryType:(NSArray *)categoryType;
/** 返回行业分类信息 */
+(NSArray *)getCategoryType;
/** 根据ID返回对应名称 */
+(NSString *)categoryNameWithID:(NSString *)categoryID;
/** 根据name返回对应ID */
+(NSString *)categoryIDWithName:(NSString *)categoryName;

/** 设置AttributedString */
+(NSMutableAttributedString *)attributedFullStr:(NSString *)fullStr
                    FullStrAttributes:(NSDictionary *)fullStrAttributes
                             RangeStr:(NSString *)rangeStr
                   RangeStrAttributes:(NSDictionary *)rangeStrAttributes
                              Options:(NSStringCompareOptions)options;

+(void)registerNotification:(NSInteger )alerTime;


/** 获取UUID */
+(NSString *)UUID;
@end
