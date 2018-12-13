//
//  KM_BaseViewControllerInterface.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewControllerInterface <NSObject>
/** 添加子视图 */
-(void)km_addSubviews;
/** 设置约束 */
-(void)km_setupSubviewsLayout;
/** 在系统 layoutSubviews 时会调用 */
-(void)km_layoutSubviews;
/** 绑定ViewModel */
-(void)km_bindViewModel;
/** 设置导航栏 */
-(void)km_settingNavigation;
/** 发起数据请求 */
-(void)km_requestData;
/** 发起刷新请求  自行调用 */
-(void)km_refreshData;
/** 在这个方法里绑定事件 */
-(void)km_bindEvent;
/** DidDisappear 的时候取消网络请求 */
-(void)km_didDisappearCancelRequest;

/** 配置TableViewCell 自行调用 */
-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath;

@end
