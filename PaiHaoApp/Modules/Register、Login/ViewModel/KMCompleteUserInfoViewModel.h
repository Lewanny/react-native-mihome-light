//
//  KMCompleteUserInfoViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMCompleteUserInfoViewModel : KMBaseViewModel
/** 用户名 */
@property (nonatomic, copy) NSString * userName;
/** 邮箱 */
@property (nonatomic, copy) NSString * mail;
/** 定位 */
@property (nonatomic, copy) NSString * location;
/** 账号ID */
@property (nonatomic, copy) NSString * accountId;

/** 保存按钮可点击 */
@property (nonatomic, strong) RACSignal * saveBtnEnableSig;
/** 保存用户信息 */
@property (nonatomic, strong) RACCommand * saveCommand;
/** 保存成功 */
@property (nonatomic, strong) RACSubject * successSubject;

@end
