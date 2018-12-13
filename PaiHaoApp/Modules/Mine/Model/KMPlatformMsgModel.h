//
//  KMPlatformMsgModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 系统消息 */
@interface KMPlatformMsgModel : NSObject
/** 点赞数量 */
@property (nonatomic, assign) NSInteger praise;
/** 消息内容 */
@property (nonatomic, copy) NSString *content;
/** 发布时间 */
@property (nonatomic, copy) NSString *releaseTime;
/** 消息ID */
@property (nonatomic, copy) NSString *ID;
/** 3 系统消息 4商户消息 */
@property (nonatomic, assign) NSInteger mode;
/** 缩略图 */
@property (nonatomic, copy) NSString *thumbnail;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 发布人 */
@property (nonatomic, copy) NSString *publisher;
/** 阅览总数 */
@property (nonatomic, assign) NSInteger totalReading;
/** 评论条数 */
@property (nonatomic, assign) NSInteger commentCount;
@end
