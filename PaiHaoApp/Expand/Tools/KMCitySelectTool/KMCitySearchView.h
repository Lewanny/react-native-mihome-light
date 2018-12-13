//
//  KMCitySearchView.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/25.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMCitySearchViewDelegate <NSObject>

-(void)citySearchViewDidSelectCity:(NSString *)cityName;

@end

@interface KMCitySearchView : UIView

@property (nonatomic, strong) NSMutableArray * reslutArr;

@property (nonatomic, weak) id<KMCitySearchViewDelegate>  delegate;

@end
