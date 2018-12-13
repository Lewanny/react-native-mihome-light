//
//  KMSearchCategoryCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"
#import "KMMerchantTypeModel.h"
@interface KMSearchCategoryCell : KMBaseTableViewCell
/** 点击 */
@property (nonatomic, strong) RACSubject * clickSubject;

+(CGFloat)cellHeight;

@end
