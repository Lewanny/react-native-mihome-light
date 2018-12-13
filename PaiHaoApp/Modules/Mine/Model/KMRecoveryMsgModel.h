//
//  KMRecoveryMsgModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMRecoveryMsgModel : NSObject
/** 商户ID/号群ID/内容ID/反馈ID */
@property (nonatomic, copy) NSString *hostId;
/** 评论ID*/
@property (nonatomic, copy) NSString *messageId;
/** 商户名称/号群名称/内容标题/反馈标题 */
@property (nonatomic, copy) NSString *hostTitle;
/** 评论时间 */
@property (nonatomic, copy) NSString *releaseTime;
/** 0商户评论，1号群评论，2内容评论，3用户反馈 */
@property (nonatomic, assign) NSInteger mode;
/** 点赞 */
@property (nonatomic, assign) NSInteger praise;
/** 评论内容 */
@property (nonatomic, copy) NSString *message;
/** 评论人 */
@property (nonatomic, copy) NSString *replyPerson;
/** 阅览总数 */
@property (nonatomic, assign) NSInteger totalReading;
/** 头像 */
@property (nonatomic, copy) NSString *headPortrait;
/** 评论数量 */
@property (nonatomic, assign) NSInteger commentCount;
@end
