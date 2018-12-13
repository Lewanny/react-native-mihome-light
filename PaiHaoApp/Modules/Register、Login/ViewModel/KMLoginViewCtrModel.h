//
//  KMLoginViewCtrModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMLoginViewCtrModel : KMBaseViewModel

/** 用户名 */
@property (nonatomic, copy) NSString * userName;
/** 密码 */
@property (nonatomic, copy) NSString * password;
/** 登录指令 */
@property (nonatomic, strong) RACCommand * loginCommand;
/** 登录按钮可点击 */
@property (nonatomic, strong) RACSignal * loginBtnEnableSig;
/** 登录成功 */
@property (nonatomic, strong) RACSubject * loginSuccessSubject;

@end
