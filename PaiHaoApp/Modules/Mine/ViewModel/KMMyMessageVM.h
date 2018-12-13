//
//  KMMyMessageVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMPlatformMsgModel.h"
#import "KMRecoveryMsgModel.h"
#import "KMRemindMsgModel.h"
@interface KMMyMessageVM : KMBaseViewModel

@property (nonatomic, assign) NSInteger  currentPage;

@property (nonatomic, strong) NSMutableArray * platformMsgArr;

@property (nonatomic, strong) NSMutableArray * recoveryMsgArr;

@property (nonatomic, strong) NSMutableArray * queueRemindArr;

@property (nonatomic, assign) KMMyMsgType  msgType;

@property (nonatomic, assign) NSInteger  remindNumber;

@property (nonatomic, assign) NSInteger  dtNumber;

/** 动态消息 */
@property (nonatomic, strong) RACCommand * dtMsgCommand;

/** 排号提醒 */
@property (nonatomic, strong) RACCommand * remindInfoCommand;

/** 添加阅读记录 */
@property (nonatomic, strong) RACCommand * addBrowsingHistoryCommand;

/** 删除消息 */
@property (nonatomic, strong) RACCommand * deleteRemindCommand;


/** 获取排号提醒消息 未读数量 */
@property (nonatomic, strong) RACCommand * remindNumberCommand;

/** 获取动态消息 未读数量 */
@property (nonatomic, strong) RACCommand * dtNumberCommand;


-(void)deleRemindMessage:(NSInteger)msgID;



@end
