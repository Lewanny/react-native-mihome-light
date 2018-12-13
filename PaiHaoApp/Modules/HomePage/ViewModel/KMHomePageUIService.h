//
//  KMHomePageUIService.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KMBannerCell.h"
#import "KMArrangingClassCell.h"
#import "KMHomePagePaiHaoHeader.h"

#import "KMHomePageViewModel.h"

@interface KMHomePageUIService : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 滑动时回调 改变透明度 */
@property (nonatomic, strong) RACSubject * didScrollSubject;
/** 跳转 行业队列列表 */
@property (nonatomic, strong) RACSubject * pushCategoryList;
/** 跳转 我的排号 */
@property (nonatomic, strong) RACSubject * pushMineQueueVC;

@property (nonatomic, strong) KMHomePageViewModel * viewModel;

-(instancetype)initWithCollectionView:(UICollectionView *)collectionView;

-(void)resetHeader;

@end
