//
//  KMCityCollectionViewCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCityCollectionViewCell.h"

@interface KMCityCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation KMCityCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self                 = [super initWithFrame:frame]) {
    UILabel *label           = [[UILabel alloc] initWithFrame:self.bounds];
    label.backgroundColor    = [UIColor whiteColor];
    label.textColor          = kFontColorDarkGray;
    label.textAlignment      = NSTextAlignmentCenter;
    label.font               = kFont28;
        [self addSubview:label];
    self.label               = label;
    }
    return self;
}

/// 设置collectionView cell的border
- (void)layoutSubviews {
    [super layoutSubviews];
    [self cornerRadius:AdaptedWidth(8) strokeSize:0.5 color:HEXCOLOR(@"d6d7dc")];
    self.layer.masksToBounds = YES;
}

- (void)setTitle:(NSString *)title {
    self.label.text          = title;
}

@end
