//
//  KMSearchHistoryCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMSearchHistoryCell : KMBaseTableViewCell
/** 删除事件 */
@property (nonatomic, strong) RACSubject * deleSubject;

+(CGFloat)cellHeight;

@end
