//
//  KMBannerCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBannerCell.h"

@implementation KMBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _banner.currentPageDotImage             = IMAGE_NAMED(@"zsqi");
    _banner.pageDotImage                    = IMAGE_NAMED(@"zhishiqi");

}

-(void)bindImageUrlArray:(NSArray *)urlArray
             placeholder:(UIImage *)placeholder{
    self.banner.imageURLStringsGroup        = urlArray;
    self.banner.placeholderImage            = placeholder;
}

-(void)bindLocalImageNameArray:(NSArray *)imageNameArray{
    self.banner.localizationImageNamesGroup = imageNameArray;
}

@end
