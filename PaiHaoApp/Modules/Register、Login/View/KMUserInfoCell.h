//
//  KMUserInfoCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMUserInfoCell : KMBaseTableViewCell
/** 左文字 */
@property (strong, nonatomic) IBOutlet UILabel *leftTextLbl;
/** 右箭头 */
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;
/** 内容文字 */
@property (strong, nonatomic) IBOutlet UILabel *subTextLbl;
/** 左间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftTextLeftMargin;
/** 箭头右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowImgRight;
/** 箭头宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowImgWidth;

/** 隐藏箭头 */
@property (nonatomic, assign, getter=isHideArrow) BOOL  hideArrow;

+(CGFloat)cellHeight;

@end
