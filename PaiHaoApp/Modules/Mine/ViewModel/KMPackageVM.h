//
//  KMPackageVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMPackageInfo.h"
#import "KMGroupOrderInfo.h"
#import "KMEditPackageInfo.h"
@interface KMPackageVM : KMBaseViewModel

@property (nonatomic, strong) NSMutableArray * packageArr;

@property (nonatomic, strong) RACCommand * packageListCommand;

@property (nonatomic, strong) RACCommand * deleCommand;

/************************ 修改 ******************************/

@property (nonatomic, strong) KMEditPackageInfo * editPackageInfo;

@property (nonatomic, strong) RACCommand * editInfoCommand;
/** 提交修改 */
@property (nonatomic, strong) RACCommand * commitEditCommand;
/** 编辑套餐参数验证 */
-(BOOL)verifyEditPackageData;

/************************ 新建 ******************************/

@property (nonatomic, copy) NSString * packageName;

@property (nonatomic, copy) NSString * packageInfo;

/** 新建时  获取我的号群列表 */
@property (nonatomic, strong) RACCommand * groupListCommand;
/** 新建号群 */
@property (nonatomic, strong) RACCommand * addNewPackageCommand;

@property (nonatomic, strong) NSMutableArray * groupArr;

-(BOOL)verifyNewPackageData;

@end
