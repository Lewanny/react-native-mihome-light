//
//  KMReplyMsgCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger, KMReplyMsgType) {
    KMReplyMsgTypeFeedback = 0, //反馈
    KMReplyMsgTypeReply         //回复
};

@interface KMReplyMsgCell : KMBaseTableViewCell

@property (nonatomic, assign) KMReplyMsgType  replyMsgType;

@end
