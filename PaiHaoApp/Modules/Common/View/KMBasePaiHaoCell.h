//
//  KMBasePaiHaoCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMBasePaiHaoCell : KMBaseCollectionViewCell

/** 点击 二维码 */
@property (nonatomic, strong) RACSubject * QRSubject;

/** 点击 地图 */
@property (nonatomic, strong) RACSubject * mapSubject;

-(NSAttributedString *)setupStatusWithWaitNum:(NSInteger)waitNum waitTime:(NSInteger)waitTime;

+(CGFloat)cellHeight;

@end
