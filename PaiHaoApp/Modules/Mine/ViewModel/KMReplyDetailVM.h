//
//  KMReplyDetailVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMReplyMsgModel.h"
@interface KMReplyDetailVM : KMBaseViewModel

@property (nonatomic, strong) KMReplyMsgModel * reply;

/** 请求回复信息 */
@property (nonatomic, strong) RACCommand * feedbackInfoCommand;
/** 发布回复 */
@property (nonatomic, strong) RACCommand * feedbackCommand;
@end
