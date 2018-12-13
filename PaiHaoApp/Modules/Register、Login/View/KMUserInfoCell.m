//
//  KMUserInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserInfoCell.h"
#import <Foundation/Foundation.h>

@implementation KMUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight{
    return AdaptedHeight(102);
}

#pragma mark - BaseViewInterface

-(void)km_addSubviews{
    _leftTextLbl.font            = kFont32;
    _leftTextLbl.textColor       = kFontColorDarkGray;
    _subTextLbl.font             = kFont28;
    _subTextLbl.textColor        = kFontColorGray;
}

-(void)km_layoutSubviews{
    _leftTextLeftMargin.constant = AdaptedWidth(24);

    if (_hideArrow) {
    _arrowImg.hidden             = YES;
    _arrowImgWidth.constant      = 0;
    _arrowImgRight.constant      = 0;
    }else{
    _arrowImg.hidden             = NO;
    _arrowImgRight.constant      = AdaptedWidth(12);
    _arrowImgWidth.constant      = AdaptedWidth(36);
    }
}
-(void)km_bindRacEvent{

}

@end
