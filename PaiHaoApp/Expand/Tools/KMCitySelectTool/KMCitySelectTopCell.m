//
//  KMCitySelectTopCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCitySelectTopCell.h"
#import "KMCityCollectionFlowLayout.h"
#import "KMCityCollectionViewCell.h"
@interface KMCitySelectTopCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation KMCitySelectTopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self                        = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (![self.subviews containsObject:self.collectionView]) {
        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}


+(CGFloat)cellHeightWithCityNameArr:(NSArray *)cityNameArr{
    CGFloat height                  = 0;

    CGFloat h                       = AdaptedHeight(76 + 24);
    if (cityNameArr.count == 0) {
    height                          = 0;
    }else if (cityNameArr.count % 3 != 0){
    height                          = ((cityNameArr.count / 3) + 1 ) * h;
    }else{
    height                          = (cityNameArr.count / 3) * h;
    }

    return height;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cityNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KMCityCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:[KMCityCollectionViewCell cellID] forIndexPath:indexPath];
    cell.title                      = _cityNameArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cityName              = _cityNameArray[indexPath.row];
    self.selectCity ? self.selectCity(cityName) : nil;
}


#pragma mark - Setter -
- (void)setCityNameArray:(NSArray *)cityNameArray {
    _cityNameArray                  = [cityNameArray copy];
    [_collectionView reloadData];
}

#pragma mark - Lazy -
- (UICollectionView *)collectionView {
    if (!_collectionView) {
    _collectionView                 = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[KMCityCollectionFlowLayout new]];
        [_collectionView registerClass:[KMCityCollectionViewCell class] forCellWithReuseIdentifier:[KMCityCollectionViewCell cellID]];
    _collectionView.dataSource      = self;
    _collectionView.delegate        = self;
    _collectionView.backgroundColor = kBackgroundColor;
    }
    return _collectionView;
}

@end
