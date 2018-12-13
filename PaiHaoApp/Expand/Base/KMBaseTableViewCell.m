//
//  KMBaseTableViewCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseTableViewCell.h"

@implementation KMBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self km_addSubviews];
        [self km_setupSubviewsLayout];
        [self km_bindRacEvent];
        [self km_bindViewModel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self km_layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self km_addSubviews];
    [self km_setupSubviewsLayout];
    [self km_bindRacEvent];
    [self km_bindViewModel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - BaseViewInterface
-(void)km_addSubviews{}
-(void)km_bindViewModel{}
-(void)km_bindRacEvent{}
-(void)km_layoutSubviews{}
-(void)km_setupSubviewsLayout{}
-(void)km_bindData:(id)data{}
@end
