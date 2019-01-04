//
//  KMGroupQueueDetailInfoCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMGroupQueueDetailInfoCell : KMBaseTableViewCell

/** 设置时间 */
@property (nonatomic, strong) RACSubject * setTimeSubject;
/** 立即排队 */
@property (nonatomic, strong) RACSubject * queueNowSubject;
/** 语音提醒 */
@property (nonatomic, strong) RACSubject * voiceSubject;
/** 点击选择套餐 */
@property (nonatomic, strong) RACSubject * packageSubject;
/** 点击二维码 */
@property (nonatomic, strong) RACSubject * QRSubject;
/** 点击电话 */
@property (nonatomic, strong) RACSubject * teleSubject;
/** 点击 地图 */
@property (nonatomic, strong) RACSubject * mapSubject;

/** 点击 图片 */
@property (nonatomic, strong) RACSubject * iconSubject;

+(CGFloat)cellHeightWithCombo:(BOOL)combo;

@end
