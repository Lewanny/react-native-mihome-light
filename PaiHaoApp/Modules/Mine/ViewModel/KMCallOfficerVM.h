//
//  KMCallOfficerVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMCallerInfo.h"
@interface KMCallOfficerVM : KMBaseViewModel

@property (nonatomic, strong) NSMutableArray * callerArr;

@property (nonatomic, strong) RACCommand * listCommand;

@property (nonatomic, strong) RACCommand * deleCommand;

@property (nonatomic, strong) RACCommand * addCommand;

-(NSAttributedString *)callerIDAttrStrWithInfo:(KMCallerInfo *)info;
-(NSAttributedString *)callerNameAttrStrWithInfo:(KMCallerInfo *)info;
-(NSAttributedString *)callerPwdAttrStrWithInfo:(KMCallerInfo *)info;

@end
