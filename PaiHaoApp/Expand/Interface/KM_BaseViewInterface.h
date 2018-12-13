//
//  KM_BaseViewInterface.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewInterface <NSObject>

@optional

/** 添加子视图 配置子视图属性 */
-(void)km_addSubviews;
/** 绑定ViewModel */
-(void)km_bindViewModel;
/** 设置约束 */
-(void)km_setupSubviewsLayout;
/** 在 视图本身的 layoutSubviews 时会调用*/
-(void)km_layoutSubviews;
/** 绑定数据 */
-(void)km_bindData:(id)data;
/** 绑定RAC 事件 */
-(void)km_bindRacEvent;

@end
