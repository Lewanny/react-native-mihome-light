//
//  KMNewGroupCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

typedef NS_OPTIONS(NSUInteger, NewGroupCellStyle) {
    NewGroupCellStyleArrow          = 1 << 0,
    NewGroupCellStyleLabel          = 1 << 1,
    NewGroupCellStyleSwitch         = 1 << 2,
    NewGroupCellStyleTextField      = 1 << 3,
    NewGroupCellStylePhoto          = 1 << 4,
};


@interface KMNewGroupCell : KMBaseTableViewCell

@property (nonatomic, strong) RACSubject * editSubject;

@end
