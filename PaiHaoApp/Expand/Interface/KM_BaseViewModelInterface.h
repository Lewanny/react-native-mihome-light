//
//  KM_BaseViewModelInterface.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelInterface <NSObject>
/** 绑定网络请求 */
-(void)km_bindNetWorkRequest;
/** 绑定一些其他事件 */
-(void)km_bindOtherEvent;
/** 取消网络请求 */
-(void)km_canelRequest;

@end
