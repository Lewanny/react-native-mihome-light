//
//  KMEditPackageInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KMPackageRelate : NSObject
/** 队列ID */
@property (nonatomic, copy) NSString *groupId;
/** 队列名称 */
@property (nonatomic, copy) NSString *groupName;
/** 是否被选中 */
@property (nonatomic, assign) BOOL selected;
/** 序号 */
@property (nonatomic, assign) NSInteger sort;

@end

@interface KMEditPackageInfo : NSObject
/** 套餐ID */
@property (nonatomic, assign) NSInteger ID;
/** 队列关系 */
@property (nonatomic, strong) NSArray<KMPackageRelate *> *relate;
/** 套餐名称 */
@property (nonatomic, copy) NSString *packageName;
/** 说明 */
@property (nonatomic, copy) NSString *explain;

@end
