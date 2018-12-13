//
//  KMBaseGroupController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseGroupController.h"
#import "KMBaseGroupViewModel.h"
@interface KMBaseGroupController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) KMBaseGroupViewModel *viewModel;

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation KMBaseGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - CollectionViewDelegate && DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count                    = self.viewModel.groupList.count;
    return count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size                        = CGSizeMake(KScreenWidth, KMBasePaiHaoCell.cellHeight);
    return size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KMBasePaiHaoCell *paiHaoCell       = [collectionView dequeueReusableCellWithReuseIdentifier:KMBasePaiHaoCell.cellID forIndexPath:indexPath];
    [paiHaoCell km_bindData:[self.viewModel.groupList objectAtIndex:indexPath.row]];
    return paiHaoCell;
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    NSString *title                    = [self.viewModel controllerTitle];
    return KMBaseNavTitle(title);
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
}

-(void)km_requestData{
    @weakify(self);
    [[self.viewModel.loadListDataCommand execute:nil] subscribeNext:^(RACTuple * x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}



#pragma mark - Lazy
-(KMBaseGroupViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                         = [[KMBaseGroupViewModel alloc]initWithGroupType:self.groupType];
    }
    return _viewModel;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];

    _collectionView                    = [[UICollectionView alloc]initWithFrame:CGRectMake(
                                                                            0,
                                                                            kNavHeight,
                                                                            KScreenWidth,
                                                                            KScreenHeight - kNavHeight)
                                            collectionViewLayout:layout];
    _collectionView.backgroundColor    = kBackgroundColor;
    _collectionView.delegate           = self;
    _collectionView.dataSource         = self;
        [_collectionView registerClass:[KMBasePaiHaoCell class] forCellWithReuseIdentifier:[KMBasePaiHaoCell cellID]];

    }
    return _collectionView;
}

@end
