//
//  KMUserInfoHeadCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/26.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserInfoHeadCell.h"

@implementation KMUserInfoHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




#pragma mark - BaseViewInterface

-(void)km_addSubviews{
    _leftTextLbl.font            = kFont32;
    _leftTextLbl.textColor       = kFontColorDarkGray;
}

-(void)km_layoutSubviews{
    _leftTextLeftMargin.constant = AdaptedWidth(24);
    if (_hideArrow) {
    _arrowImg.hidden             = YES;
    _arrowImgWidth.constant      = 0;
    _arrowRightMargin.constant   = 0;
    _imgRightMargin.constant     = AdaptedWidth(24);
    }else{
    _arrowImg.hidden             = NO;
    _arrowRightMargin.constant   = AdaptedWidth(12);
    _arrowImgWidth.constant      = AdaptedWidth(36);
    _imgRightMargin.constant     = AdaptedWidth(12);
    }
    [_headImg setRoundedCorners:UIRectCornerAllCorners radius:_headImg.height / 2.0];
}
-(void)km_bindData:(id)data{
    NSString *url                = data;
    if (url.length) {
        [_headImg setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(url ? url : @"")] placeholder:GetHeaderPlaceholderImage];
    }else{
    _headImg.image               = GetHeaderPlaceholderImage;
    }

}
@end
