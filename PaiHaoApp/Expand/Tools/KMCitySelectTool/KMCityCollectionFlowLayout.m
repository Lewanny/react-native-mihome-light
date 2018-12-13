//
//  KMCityCollectionFlowLayout.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCityCollectionFlowLayout.h"

@implementation KMCityCollectionFlowLayout
/// 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW                = (self.collectionView.frame.size.width - AdaptedWidth(24 + 40 + 40 + 50))/ 3;
    self.itemSize                = CGSizeMake(itemW, AdaptedHeight(76));

    //设置最小间距
    self.minimumLineSpacing      = AdaptedHeight(24);
    self.minimumInteritemSpacing = AdaptedHeight(24);
    self.sectionInset            = UIEdgeInsetsMake(0, AdaptedHeight(24), 0, AdaptedWidth(50));
}
@end
