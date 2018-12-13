//
//  KMCategorySortView.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMCategorySortView : UIView
/** 点击刷新 */
@property (nonatomic, strong) RACSubject * reloadSubject;

//-(void)setCity:(NSString *)city;
//
//-(void)setQueueStatus:(KMCategoryQueueSort)status;

-(void)setSortType:(KMCategorySortType)sortType;

@end
