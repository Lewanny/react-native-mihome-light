//
//  KMBaseCollectionViewCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseCollectionViewCell.h"

@implementation KMBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self km_addSubviews];
        [self km_setupSubviewsLayout];
        [self km_bindViewModel];
        [self km_bindRacEvent];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self km_addSubviews];
    [self km_setupSubviewsLayout];
    [self km_bindViewModel];
    [self km_bindRacEvent];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self km_layoutSubviews];
}


#pragma mark - BaseViewInterface
-(void)km_addSubviews{}
-(void)km_bindViewModel{}
-(void)km_bindRacEvent{}
-(void)km_layoutSubviews{}
-(void)km_setupSubviewsLayout{}
-(void)km_bindData:(id)data{}
@end
