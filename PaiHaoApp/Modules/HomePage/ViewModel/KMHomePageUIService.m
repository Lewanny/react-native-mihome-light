//
//  KMHomePageUIService.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHomePageUIService.h"
#import "KMHistoryQueueCollectionViewCell.h"
@interface KMHomePageUIService ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) KMHomePagePaiHaoHeader * header;

@end

@implementation KMHomePageUIService
-(instancetype)initWithCollectionView:(UICollectionView *)collectionView{
    if (self                          = [super init]) {
    self.collectionView               = collectionView;
        [self setupCollectionView];

        //监听了登入 、 登出
        @weakify(self)
        [[RACSignal merge:@[[kNotificationCenter rac_addObserverForName:kLoginNotiName object:nil], [kNotificationCenter rac_addObserverForName:kLogoutNotiName object:nil]]] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.header btnClick:self.header.recommendBtn];
//            if (KMUserDefault.isLogin) {
//                [self.header btnClick:self.header.mineBtn];
//            }else{
//                [self.header btnClick:self.header.recommendBtn];
//            }
        }];
    }
    return self;
}

-(void)resetHeader{
    if (!_header) {
        return;
    }
    [_header.btnClickSubject sendNext:@(_viewModel.groupType)];
}


-(void)setupCollectionView{

    UICollectionView *collection      = self.collectionView;

    collection.delegate               = self;
    collection.dataSource             = self;
    collection.emptyDataSetSource     = self;
    collection.emptyDataSetDelegate   = self;


    [collection registerNib:KMBannerCell.loadNib forCellWithReuseIdentifier:KMBannerCell.cellID];
    [collection registerClass:KMArrangingClassCell.class forCellWithReuseIdentifier:KMArrangingClassCell.cellID];
    [collection registerClass:[KMBasePaiHaoCell class] forCellWithReuseIdentifier:[KMBasePaiHaoCell cellID]];
    [collection registerNib:[KMHistoryQueueCollectionViewCell loadNib] forCellWithReuseIdentifier:[KMHistoryQueueCollectionViewCell cellID]];
    [collection registerNib:KMHomePagePaiHaoHeader.loadNib
 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:NSStringFromClass(KMHomePagePaiHaoHeader.class)];

    [collection registerClass:UICollectionReusableView.class
   forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
          withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class)];
}


#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.collectionView]) {
        [self.didScrollSubject sendNext:@(scrollView.contentOffset.y)];
    }
}

#pragma mark - DZNEmptyDataSetSource
-(BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView{
    return YES;
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView{
    return self.viewModel.groupArr.count == 0;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return DefluatEmptyImage;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{

    return AdaptedHeight(420);
}
#pragma mark - CollectionViewDelegate && DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count                   = 0;
    switch (section) {
        case 0:
    count                             = 1;
            break;
        case 1:
    count                             = 1;
            break;
        case 2:{
    count = self.viewModel.groupArr.count;
            if (!KMUserDefault.isLogin && (self.viewModel.groupType == KM_GroupTypeMyArranging || self.viewModel.groupType == KM_GroupTypeHistory)) {
                //如果没登录 且 选择 我的排号 或 查看历史
                count = 0;
            }
        }
            break;
        default:
            break;
    }
    return count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size                       = CGSizeZero;

    switch (indexPath.section) {
        case 0:
    size                              = CGSizeMake(KScreenWidth, AdaptedHeight(340));
            break;
        case 1:
    size                              = CGSizeMake(KScreenWidth, AdaptedHeight(370));
            break;
        case 2:{
            switch (self.viewModel.groupType) {
                case KM_GroupTypeRecommend:
                case KM_GroupTypeMyArranging:
    size                              = CGSizeMake(KScreenWidth, KMBasePaiHaoCell.cellHeight);
                    break;
                case KM_GroupTypeHistory:
    size                              = CGSizeMake(KScreenWidth, KMHistoryQueueCollectionViewCell.cellHeight);
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return size;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 2) {

    KMHomePagePaiHaoHeader *header    = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(KMHomePagePaiHaoHeader.class) forIndexPath:indexPath];
    self.header                       = header;
            @weakify(self);
            [[header.btnClickSubject takeUntil:header.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self);
    KM_GroupType groupType            = [x integerValue];
    self.viewModel.groupType          = groupType;
                if (self.viewModel.groupArr.count == 0) {
                    [self.collectionView scrollToTopAnimated:NO];
                }
                
                switch (groupType) {
                    case KM_GroupTypeRecommend:{
                        [self.viewModel.requestRecommend execute:nil];
                    }
                        break;
                    case KM_GroupTypeMyArranging:{
                        if (KMUserDefault.isLogin) {
                            [self.viewModel.requestMine execute:nil];
                        }
                    }
                        break;
                    case KM_GroupTypeHistory:{
                        if (KMUserDefault.isLogin) {
                            [self.viewModel.requestHistory execute:nil];
                        }
                    }
                        break;
                    default:
                        break;
                }
                    [self.viewModel.reloadSubject sendNext:nil];
            }];
            return header;
        }else{
            return nil;
        }
    }else{
        if (indexPath.section == 1) {
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(UICollectionReusableView.class) forIndexPath:indexPath];
        }else{
            return nil;
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return CGSizeMake(KScreenWidth, KMHomePagePaiHaoHeader.viewHeight);
    }else{
        return CGSizeZero;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(KScreenWidth, AdaptedHeight(20));
    }else{
        return CGSizeZero;
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell        = [self configCellWithIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (_viewModel.groupType == KM_GroupTypeRecommend || _viewModel.groupType == KM_GroupTypeHistory) {
    KMGroupBriefModel * brief         = [_viewModel.groupArr objectAtIndex:indexPath.row];
            [KMUserManager pushDetailWithGroupID:brief.ID];
        }else if (self.viewModel.groupType == KM_GroupTypeMyArranging){
    KMQueueInfo *info                 = [self.viewModel.groupArr objectAtIndex:indexPath.row];
            [self.pushMineQueueVC sendNext:RACTuplePack(info.groupid, info.queueid)];
        }
    }
}


-(UICollectionViewCell *)configCellWithIndexPath:(NSIndexPath *)indexPath{

    UICollectionView *collectionView  = self.collectionView;
    UICollectionViewCell *cell        = nil;

    switch (indexPath.section) {
        case 0:{
    KMBannerCell *bannerCell          = [collectionView dequeueReusableCellWithReuseIdentifier:KMBannerCell.cellID forIndexPath:indexPath];
            if (!bannerCell.banner.localizationImageNamesGroup.count) {
                [bannerCell bindLocalImageNameArray:@[@"1banner1", @"2", @"3"]];
            }
    cell                              = bannerCell;
        }
            break;
        case 1:{
    KMArrangingClassCell *arrangeCell = [collectionView dequeueReusableCellWithReuseIdentifier:KMArrangingClassCell.cellID forIndexPath:indexPath];
            [arrangeCell km_bindData:self.viewModel.categoryArr];
            @weakify(self)
            [[arrangeCell.btnClickSubject takeUntil:arrangeCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.pushCategoryList sendNext:x];
            }];
    cell                              = arrangeCell;
        }
            break;
        case 2:{
    KMBasePaiHaoCell *paiHaoCell      = [collectionView dequeueReusableCellWithReuseIdentifier:KMBasePaiHaoCell.cellID forIndexPath:indexPath];
    id data                           = [self.viewModel.groupArr objectAtIndex:indexPath.row];
            [paiHaoCell km_bindData:data];
            @weakify(data)
            [[paiHaoCell.QRSubject takeUntil:paiHaoCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(data)
                [KMUserManager pushQRCodeVCWithData:data];
            }];
            [[paiHaoCell.mapSubject takeUntil:paiHaoCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
                @strongify(data)
                CLLocationCoordinate2D coor;
    NSString *targetName              = @"";
                if ([data isKindOfClass:[KMQueueInfo class]]) {
    KMQueueInfo *model                = data;
    coor                              = CLLocationCoordinate2DMake(model.lat.floatValue, model.lng.floatValue);
    targetName                        = model.groupname;
                }else if ([data isKindOfClass:[KMGroupBriefModel class]]){
    KMGroupBriefModel *model          = data;
    coor                              = CLLocationCoordinate2DMake(model.lat, model.lng);
    targetName                        = model.groupname;
                }
                if (coor.latitude && coor.longitude) {
                    [KMLocationManager showActionSheetWithMaps:[KMLocationManager getInstalledMapAppWithEndLocation:coor TargetName:targetName]];
                }
            }];
    cell                              = paiHaoCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Lazy
-(RACSubject *)didScrollSubject{
    if (!_didScrollSubject) {
    _didScrollSubject                 = [RACSubject subject];
    }
    return _didScrollSubject;
}
-(RACSubject *)pushCategoryList{
    if (!_pushCategoryList) {
    _pushCategoryList                 = [RACSubject subject];
    }
    return _pushCategoryList;
}
-(RACSubject *)pushMineQueueVC{
    if (!_pushMineQueueVC) {
    _pushMineQueueVC                  = [RACSubject subject];
    }
    return _pushMineQueueVC;
}

@end
