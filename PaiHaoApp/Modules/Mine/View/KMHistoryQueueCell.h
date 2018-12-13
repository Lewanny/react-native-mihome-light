//
//  KMHistoryQueueCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMHistoryQueueCell : KMBaseTableViewCell
/** 点击二维码 */
@property (nonatomic, strong) RACSubject * QRSubject;
/** 点击评价 */
@property (nonatomic, strong) RACSubject * evaluateSubject;

+(CGFloat)cellHeight;
@end
