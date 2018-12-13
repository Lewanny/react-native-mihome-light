//
//  KMMemberCenterCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMemberCenterCell.h"

@implementation KMMemberCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)km_layoutSubviews{
    _arrowRight.constant = AdaptedWidth(24);
}

-(void)bindDataWithImgName:(NSString *)imgName
                      Text:(NSString *)text{
    [_iconImg setImage:[UIImage imageNamed:imgName]];
    [_textLbl setText:text];
}

+(CGFloat)cellHeight{
    return AdaptedHeight(104);
}
@end
