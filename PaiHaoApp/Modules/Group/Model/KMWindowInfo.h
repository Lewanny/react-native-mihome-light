//
//  KMWindowInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMWindowInfo : NSObject
/** 所属用户ID */
@property (nonatomic, copy) NSString *userId;
/** 窗口名称 */
@property (nonatomic, copy) NSString *windowName;
/** 窗口ID（数据标识） */
@property (nonatomic, copy) NSString *ID;
/** 创建人 */
@property (nonatomic, copy) NSString *creater;

@property (nonatomic, assign) NSInteger winAddress;

@property (nonatomic, copy) NSString *isValid;
/** 创建时间 */
@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *reserve;

@property (nonatomic, assign) NSInteger usestatue;

/** 选择状态 */
@property (nonatomic, assign) BOOL  selected;

@end
