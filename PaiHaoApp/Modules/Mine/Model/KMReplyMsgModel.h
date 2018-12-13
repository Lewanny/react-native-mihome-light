//
//  KMReplyMsgModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMReplyMsgModel : NSObject
/** 反馈ID */
@property (nonatomic, copy) NSString *hostId;
/** 反馈内容 */
@property (nonatomic, copy) NSString *hostMessage;
/** 反馈人 */
@property (nonatomic, copy) NSString *submitPerson;
/** 反馈时间 */
@property (nonatomic, copy) NSString *submitTime;
/** 回复ID */
@property (nonatomic, copy) NSString *messageId;
/** 评论时间 */
@property (nonatomic, copy) NSString *releaseTime;
/** 评论内容 */
@property (nonatomic, copy) NSString *message;
/** 反馈人头像 */
@property (nonatomic, copy) NSString *headPortrait;
@end
