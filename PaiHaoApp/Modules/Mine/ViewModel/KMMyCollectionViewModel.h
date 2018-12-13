//
//  KMMyCollectionViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMCollectionModel.h"
@interface KMMyCollectionViewModel : KMBaseViewModel

@property (nonatomic, strong) NSMutableArray * collectionList;
/** 请求收藏列表 */
@property (nonatomic, strong) RACCommand * requestCollection;
/** 删除收藏排号 */
@property (nonatomic, strong) RACCommand * delCollection;
@end
