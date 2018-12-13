//
//  KMHistoryQueueCollectionViewCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMHistoryQueueCollectionViewCell : KMBaseCollectionViewCell
/** 队列图片 */
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
/** 队列名称 */
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
/** 队列ID */
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
/** 办理时间 */
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
/** 呼叫员 */
@property (strong, nonatomic) IBOutlet UILabel *callLbl;
/** 评价按钮 */
@property (strong, nonatomic) IBOutlet UIButton *evaluateBtn;
/** 底部分割线 */
@property (strong, nonatomic) IBOutlet UIView *topGrayLine;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconBottom;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelRight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *callLblRight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *evaluateBtnWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *evaluateBtnHeight;


+(CGFloat)cellHeight;
@end
