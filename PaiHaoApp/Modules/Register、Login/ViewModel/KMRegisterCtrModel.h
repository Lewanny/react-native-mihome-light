//
//  KMRegisterCtrModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMRegisterCtrModel : KMBaseViewModel
/** 手机号 */
@property (nonatomic, copy) NSString * tele;
/** 验证码 */
@property (nonatomic, copy) NSString * code;
/** 输入密码 */
@property (nonatomic, copy) NSString * password1;
/** 确认密码 */
@property (nonatomic, copy) NSString * password2;
/** 用户类型 */
@property (nonatomic, assign) KM_UserType  userType;
/** 注册成功后的账户ID */
@property (nonatomic, copy) NSString * accountId;



/** 注册按钮可以点击 */
@property (nonatomic, strong) RACSignal * regBtnEnableSig;
/** 获取验证码 */
@property (nonatomic, strong) RACCommand * requestCode;
/** 倒计时 */
@property (nonatomic, strong) RACSubject * countDownSubject;
/** 提交注册 */
@property (nonatomic, strong) RACCommand * regCommand;


@end
