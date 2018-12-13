//
//  KMCollectionCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCollectionCell.h"
#import "KMCollectionModel.h"
@implementation KMCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    [super km_addSubviews];
    [self.bottomGrayLine setHidden:NO];
}
-(void)km_bindData:(id)data{
    KMCollectionModel *collection = data;
    [self.nameLabel setText:collection.groupname];
    [self.iconImageView setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(collection.groupphoto ? collection.groupphoto : @"")]
                           placeholder:GetNormalPlaceholderImage];
    [self.distanceLabel setText:@"1.9km"];
    [self.IDLabel setText:NSStringFormat(@"ID:%@",collection.groupno)];
    [self.timeLabel setText:collection.timespan];
    [self.statusLabel setAttributedText: [self setupStatusWithWaitNum:collection.frontnumber waitTime:collection.waittime]];
}
@end
