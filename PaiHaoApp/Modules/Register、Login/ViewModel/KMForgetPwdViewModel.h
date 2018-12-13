//
//  KMForgetPwdViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMForgetPwdViewModel : KMBaseViewModel
/** 电话号码 */
@property (nonatomic, copy) NSString * tele;
/** 验证码 */
@property (nonatomic, copy) NSString * code;
/** 输入新密码 */
@property (nonatomic, copy) NSString * password1;
/** 确认新密码 */
@property (nonatomic, copy) NSString * password2;


/** 保存按钮可以点击 */
@property (nonatomic, strong) RACSignal * btnEnableSig;
/** 获取验证码 */
@property (nonatomic, strong) RACCommand * requestCode;
/** 倒计时 */
@property (nonatomic, strong) RACSubject * countDownSubject;
/** 确认提交新密码 */
@property (nonatomic, strong) RACCommand * saveCommand;
@end
