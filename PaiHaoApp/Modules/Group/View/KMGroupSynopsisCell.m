//
//  KMGroupSynopsisCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupSynopsisCell.h"
#import "KMGroupDetailInfo.h"
@implementation KMGroupSynopsisCell


#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    [self.contentView addSubview:self.textLbl];
}
-(void)km_setupSubviewsLayout{
    [_textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(AdaptedHeight(20), AdaptedWidth(20), AdaptedHeight(20), AdaptedWidth(20)));
        make.height.mas_greaterThanOrEqualTo(20).priorityHigh();
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMGroupDetailInfo class]]) {
        KMGroupDetailInfo *info           = data;
        NSString *title                   = @"商户简介: ";
        NSMutableAttributedString *attr   = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kFontColorBlack}];

        NSAttributedString * synopsisAttr = [[NSAttributedString alloc]initWithString:info.synopsis attributes:@{NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kFontColorGray}];
        [attr appendAttributedString:synopsisAttr];
        [_textLbl setAttributedText:attr];
    }
}

#pragma mark - Lazy
-(YYLabel *)textLbl{
    if (!_textLbl) {
        _textLbl                          = [YYLabel new];
        _textLbl.numberOfLines            = 0;
        _textLbl.preferredMaxLayoutWidth  = KScreenWidth - AdaptedWidth(20 + 20);
    }
    return _textLbl;
}

@end
