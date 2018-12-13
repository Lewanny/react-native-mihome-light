//
//  KMMemberCenterCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMMemberCenterCell : KMBaseTableViewCell
/** 右边 Icon */
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
/** 内容文字 */
@property (strong, nonatomic) IBOutlet UILabel *textLbl;
/** 箭头 */
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowRight;

-(void)bindDataWithImgName:(NSString *)imgName
                      Text:(NSString *)text;

+(CGFloat)cellHeight;

@end
