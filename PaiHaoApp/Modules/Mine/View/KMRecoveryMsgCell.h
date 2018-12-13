//
//  KMRecoveryMsgCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMRecoveryMsgCell : KMBaseTableViewCell
/** 更多 */
@property (nonatomic, strong) RACSubject * moreSubject;
/** 关闭 */
@property (nonatomic, strong) RACSubject * closeSuject;
+(CGFloat)cellHeight;

@end
