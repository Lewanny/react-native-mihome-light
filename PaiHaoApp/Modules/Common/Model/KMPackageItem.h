//
//  KMPackageItem.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMPackageItem : NSObject<YYModel>
/** 说明 */
@property (nonatomic, copy) NSString * explain;
/** 套餐名称 */
@property (nonatomic, copy) NSString * packageName;
/** 号情信息 序号.名称.排序 */
@property (nonatomic, copy) NSString * pg;
/** ID */
@property (nonatomic, copy) NSString * ID;

//自定义选择
@property (nonatomic, assign) BOOL  selected;

@end
