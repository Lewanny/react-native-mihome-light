//
//  KMIntroductoryPagesHelper.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMIntroductoryPagesView.h"
@interface KMIntroductoryPagesHelper : NSObject

+ (instancetype)shareInstance;

+ (void)showIntroductoryPageView:(NSArray *)imageArray;

@end
