//
//  KMPlatformMsgCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMPlatformMsgCell : KMBaseTableViewCell
/** 点赞 */
@property (nonatomic, strong) RACSubject * zanSubject;
/** 评论 */
@property (nonatomic, strong) RACSubject * commentSubject;
/** 关闭 */
@property (nonatomic, strong) RACSubject * closeSuject;
@end
