//
//  KMMemberCenterViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMMemberModel.h"
@interface KMMemberCenterViewModel : KMBaseViewModel
/** 简单的用户信息 */
@property (nonatomic, strong) KMMemberModel * member;
/** 获取用户信息 */
@property (nonatomic, strong) RACCommand * userInfoCommand;
/** 获取用户的类型 */
-(KM_CustomerType)customerType;

/** 能否升级账户 */
-(BOOL)checkCanUpdate;

-(NSArray *)titleArr;
-(NSArray *)imgNameArr;
@end
