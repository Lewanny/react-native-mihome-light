//
//  KMBasePaiHaoTableViewCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@interface KMBasePaiHaoTableViewCell : KMBaseTableViewCell

/** 号群图片 */
@property (strong, nonatomic) UIImageView *iconImageView;
/** 号群名称 */
@property (strong, nonatomic) UILabel *nameLabel;
/** 号群距离 */
@property (strong, nonatomic) UILabel *distanceLabel;
/** 号群ID */
@property (strong, nonatomic) UILabel *IDLabel;
/** 排号时间 */
@property (strong, nonatomic) UILabel *timeLabel;
/** 二维码 按钮 */
@property (nonatomic, strong) UIButton * QRBtn;
/** 地图 按钮 */
@property (nonatomic, strong) UIButton * mapBtn;
/** 排号状态 */
@property (strong, nonatomic) UILabel *statusLabel;
/** 顶部分割线 */
@property (strong, nonatomic) UIView *topGrayLine;
/** 底部分割线 */
@property (nonatomic, strong) UIView * bottomGrayLine;

/** 点击二维码 */
@property (nonatomic, strong) RACSubject * QRSubject;
/** 点击地图 */
@property (nonatomic, strong) RACSubject * mapSubject;

-(NSAttributedString *)setupStatusWithWaitNum:(NSInteger)waitNum waitTime:(NSInteger)waitTime;

+(CGFloat)cellHeight;
@end
