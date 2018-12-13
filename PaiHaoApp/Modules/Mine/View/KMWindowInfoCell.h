//
//  KMWindowInfoCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMWindowInfoCell : KMBaseTableViewCell

@property (nonatomic, strong) RACSubject * deleSubject;

+(CGFloat)cellHeight;

@end
