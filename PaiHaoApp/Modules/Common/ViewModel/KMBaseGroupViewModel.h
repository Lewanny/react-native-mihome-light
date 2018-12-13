//
//  KMBaseGroupViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"



@interface KMBaseGroupViewModel : KMBaseViewModel
/** 号群分类 */
@property (nonatomic, assign) KM_GroupType  groupType;
/** 号群列表 */
@property (nonatomic, strong) NSMutableArray * groupList;

@property (nonatomic, strong) RACCommand *loadListDataCommand;

-(instancetype)initWithGroupType:(KM_GroupType)groupType;


-(NSString *)controllerTitle;

@end
