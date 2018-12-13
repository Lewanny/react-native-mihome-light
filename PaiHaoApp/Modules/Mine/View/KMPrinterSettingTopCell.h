//
//  KMPrinterSettingTopCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMPrinterSettingTopCell : KMBaseTableViewCell
/** 断开连接 */
@property (nonatomic, strong) RACSubject * disConnectSubject;

@end
