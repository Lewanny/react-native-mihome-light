//
//  KMBannerCell.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMBannerCell : KMBaseCollectionViewCell

@property (strong, nonatomic) IBOutlet SDCycleScrollView *banner;


-(void)bindImageUrlArray:(NSArray *)urlArray
             placeholder:(UIImage *)placeholder;

-(void)bindLocalImageNameArray:(NSArray *)imageNameArray;

@end
