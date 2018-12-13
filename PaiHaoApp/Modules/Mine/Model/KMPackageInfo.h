//
//  KMPackageInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMPackageInfo : NSObject

@property (nonatomic, copy) NSString *groups;
/** 套餐名称 */
@property (nonatomic, copy) NSString *packagename;
/** 说明 */
@property (nonatomic, copy) NSString *explain;
/** 套餐ID */
@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *relate;
/** 用户ID */
@property (nonatomic, copy) NSString *userid;
/** 创建人 */
@property (nonatomic, copy) NSString *creater;

@property (nonatomic, copy) NSString *reserve;
/** 创建时间 */
@property (nonatomic, copy) NSString *createtime;
/** 序号#号群ID；逗号分隔 */
@property (nonatomic, copy) NSString *groupIds;
@end
