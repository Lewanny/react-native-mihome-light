//
//  KMMemberInfoCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMMemberInfoCell : KMBaseTableViewCell

@property (nonatomic, strong) RACSubject * updateSubject;

+(CGFloat)cellHeight;

@end
