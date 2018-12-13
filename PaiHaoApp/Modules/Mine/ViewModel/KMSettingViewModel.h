//
//  KMSettingViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMSettingViewModel : KMBaseViewModel

@property (nonatomic, strong) RACCommand * editReminderCommand;

/** 清除缓存 */
-(void)cleanCache:(Block_Void)callBack;
/** 缓存大小 */
-(NSString *)cacheSizeString;

-(NSArray *)titleArr;

@end
