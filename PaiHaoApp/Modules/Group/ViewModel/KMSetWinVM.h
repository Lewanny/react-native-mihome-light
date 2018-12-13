//
//  KMSetWinVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

#import "KMWindowInfo.h"

@interface KMSetWinVM : KMBaseViewModel

@property (nonatomic, assign) KM_WindowBindState  bindState;

/** 窗口分配列表 */
@property (nonatomic, strong) NSMutableArray * unabsorbedWinArr;
/** 窗口解绑列表 */
@property (nonatomic, strong) NSMutableArray * bindedWinArr;

/** 加载当前用户名下未分配的窗口  窗口分配列表 */
@property (nonatomic, strong) RACCommand * unabsorbedWin;
/** 获取当前号群已经绑定的窗口列表 窗口解绑列表 */
@property (nonatomic, strong) RACCommand * bindedWin;

/** 提交 */
@property (nonatomic, strong) RACCommand * commitCommand;
-(BOOL)verifyData;

-(NSArray *)dataArr;

@end
