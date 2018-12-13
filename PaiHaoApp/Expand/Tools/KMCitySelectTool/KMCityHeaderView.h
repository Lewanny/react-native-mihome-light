//
//  KMCityHeaderView.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AreaSelectBlock)(NSString *cityName, BOOL ret);

@protocol KMCityHeaderViewDelegate <NSObject>

- (void)beginSearch;
- (void)endSearch;
- (void)searchWithKeyword:(NSString *)keyword;

@end

@interface KMCityHeaderView : UIView

@property (nonatomic, copy) NSString * cityName;

@property (nonatomic, copy) AreaSelectBlock areaSelect;

@property (nonatomic, weak) id<KMCityHeaderViewDelegate>  delegate;

@end
