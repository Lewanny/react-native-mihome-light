//
//  KMUserInfoHeadCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMUserInfoHeadCell : KMBaseTableViewCell
/** 左边文字 */
@property (strong, nonatomic) IBOutlet UILabel *leftTextLbl;
/** 头像 */
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
/** 右边箭头 */
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;

/** 文字左间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftTextLeftMargin;
/** 图片上间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgTopMargin;
/** 图片下间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgBottomMargin;
/** 图片右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgRightMargin;
/** 箭头右间距 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowRightMargin;
/** 箭头宽度 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowImgWidth;

/** 头像地址 */
@property (nonatomic, copy) NSString * headUrl;

/** 隐藏箭头 */
@property (nonatomic, assign, getter=isHideArrow) BOOL  hideArrow;

@end
