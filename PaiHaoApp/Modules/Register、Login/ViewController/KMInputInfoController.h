//
//  KMInputInfoController.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"

typedef void(^InputInfoCompeleBlock)(NSString *text);

typedef NS_ENUM(NSUInteger, InputInfoType) {
    InputInfoTypeCompele = 0,  //完善信息
    InputInfoTypeChange        //修改信息
};

@interface KMInputInfoController : KMBaseViewController
/** 控制器标题 */
@property (nonatomic, copy) NSString * titleStr;
/** 占位文字 */
@property (nonatomic, copy) NSString * placeholder;
/** 待修改文字 */
@property (nonatomic, copy) NSString * needChangeText;
/** 键盘类型 */
@property (nonatomic, assign) UIKeyboardType  keyboardType;
/** 完善信息时的回调 */
@property (nonatomic, copy) InputInfoCompeleBlock  compele;
/** 完善 或 修改 */
@property (nonatomic, assign) InputInfoType  type;



@end
