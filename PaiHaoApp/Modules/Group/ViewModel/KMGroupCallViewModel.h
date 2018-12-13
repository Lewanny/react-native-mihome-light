//
//  KMGroupCallViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMGroupDetailInfo.h"
#import "KMQueueDataModel.h"
#import "KMTicketInfo.h"
#import "KMWindowInfo.h"

#import <iflyMSC/iflyMSC.h>
#import <QuartzCore/QuartzCore.h>


typedef NS_ENUM(NSUInteger, QueueReloadStatus) {
    QueueReloadStatusNoCall = 0,
    QueueReloadStatusCallCurrent,
    QueueReloadStatusCallNext,
    QueueReloadStatusCallPass
};

@interface KMGroupCallViewModel : KMBaseViewModel<IFlySpeechSynthesizerDelegate>

//语音合成单例
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

/** 号群ID */
@property (nonatomic, copy) NSString * groupID;
/** 批量叫号人数 */
@property (nonatomic, assign) NSInteger singleNumber;
/** 选择的窗口 */
@property (nonatomic, copy) NSString * selectWindowID;

/** 选择窗口的名称 */
@property (nonatomic, copy) NSString * selectWindowName;

/** 等待时间 */
@property (nonatomic, copy) NSString * waitingTime;
/** 等待人数 */
@property (nonatomic, copy) NSString * waitingCount;
/** 当前办理 */
@property (nonatomic, copy) NSString * currentHandle;


/** 号群详情 */
@property (nonatomic, strong) KMGroupDetailInfo * detailInfo;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * queueArr;
/** 该号群已绑定的窗口 */
@property (nonatomic, strong) NSMutableArray * bindedWinArr;
/** 刷新数据 */
//@property (nonatomic, strong) RACSubject * refreshSubject;


/** 占用该窗口 */
@property (nonatomic, strong) RACCommand * bindCallWindow;
/** 获取已绑定的窗口 */
@property (nonatomic, strong) RACCommand * bindedWinCommand;
/** 请求号群详情 */
@property (nonatomic, strong) RACCommand * detailCommand;
/** 获取号群排队信息 */
@property (nonatomic, strong) RACCommand * requestQueueData;
/** 过号 */
@property (nonatomic, strong) RACCommand * expireCommand;
/** 呼叫当前 */
@property (nonatomic, strong) RACCommand * callCommand;
/** 下一位 */
@property (nonatomic, strong) RACCommand * nextCommand;
/** 暂停 */
@property (nonatomic, strong) RACCommand * pauseCommand;
/** 解散 */
@property (nonatomic, strong) RACCommand * dissolveCommand;

/** 新增 套餐排队接口 */
@property (nonatomic, strong) RACCommand * packageQueueCommand;

/** 现场排号 */
@property (nonatomic, strong) RACCommand * sceneQueueCommand;

/** 获取票据信息 */
@property (nonatomic, strong) RACCommand * billInfoCommand;
/** 打印 */
@property (nonatomic, strong) RACSubject * printSubject;
/** 有没有人排队 */
-(BOOL)checkQueueExist;

#pragma mark - 批量
/** 批量叫号 排队列表信息 */
@property (nonatomic, strong) RACCommand * batchQueueDataCommand;
/** 结束上一批 */
@property (nonatomic, strong) RACCommand * batchEndLastCommand;
/** 批量暂停 */
@property (nonatomic, strong) RACCommand * batchSuspendCommand;
/** 更改排队状态 */
@property (nonatomic, strong) RACCommand * editQueueStateCommand;
@end
