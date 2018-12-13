//
//  KMWindowServiceVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMWindowInfo.h"
@interface KMWindowServiceVM : KMBaseViewModel

@property (nonatomic, strong) NSMutableArray * winArr;
/** 请求列表 */
@property (nonatomic, strong) RACCommand * listCommand;
/** 删除窗口 */
@property (nonatomic, strong) RACCommand * deleCommand;
/** 添加窗口 */
@property (nonatomic, strong) RACCommand * addCommand;

-(NSAttributedString *)windowNameAttrStrWithInfo:(KMWindowInfo *)info;
-(NSAttributedString *)windowInfoAttrStrWithInfo:(KMWindowInfo *)info;
-(NSAttributedString *)windowTimeAttrStrWithInfo:(KMWindowInfo *)info;
@end
