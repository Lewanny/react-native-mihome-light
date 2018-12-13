//
//  KMIntroductoryPagesView.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMIntroductoryPagesView : UIView

@property (nonatomic, assign) BOOL  pageControlHidden;

-(instancetype)initPagesViewWithFrame:(CGRect)frame Images:(NSArray *)images;


@end
