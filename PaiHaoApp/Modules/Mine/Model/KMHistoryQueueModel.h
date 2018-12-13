//
//  KMHistoryQueueModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMHistoryQueueModel : NSObject
/** 排队ID(数据标识) */
@property (nonatomic, copy) NSString *queueId;
/** 地址 */
@property (nonatomic, copy) NSString *groupAdrr;
/** 号群ID */
@property (nonatomic, copy) NSString * groupId;
/** 编号(ID) */
@property (nonatomic, copy) NSString *groupNo;
/** 办理时间 */
@property (nonatomic, copy) NSString *processTime;
/** 排队状态（0排队状态，1已经处理（可评论），2过号，3退出，5已经呼叫，6.解散（可评论）（业务说明，解散叫号员有事离开或时间到了，无法处理完成。）7.已经评分） */
@property (nonatomic, copy) NSString *queueState;
/** 号群名称 */
@property (nonatomic, copy) NSString *groupName;
/** 叫号员 */
@property (nonatomic, copy) NSString *callClerk;
/** 号群图片 */
@property (nonatomic, copy) NSString *groupImg;
/** 二维码 */
@property (nonatomic, copy) NSString * qrcode;
@end
