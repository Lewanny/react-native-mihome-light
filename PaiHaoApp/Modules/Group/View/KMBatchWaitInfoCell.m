//
//  KMBatchWaitInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBatchWaitInfoCell.h"

@interface KMBatchWaitInfoCell ()

@property (nonatomic, strong) UILabel * waitLbl;

@end

@implementation KMBatchWaitInfoCell

+(CGFloat)cellHeight{
    return AdaptedHeight(102);
}

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    _waitLbl = [UILabel new];
    _waitLbl.numberOfLines = 0;
    [self.contentView addSubview:_waitLbl];
}

-(void)km_setupSubviewsLayout{
    [_waitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(AdaptedHeight(10), AdaptedWidth(55), AdaptedHeight(10), AdaptedWidth(55)));
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[RACTuple class]]) {
        RACTupleUnpack(NSString * currentHandel, NSString * waitNumber, NSString * waitCount) = data;
        
        //当前办理
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"当前办理 %@\n",currentHandel)];
        [attr setFont:kFont32];
        [attr setColor:kFontColorBlack];
        [attr setColor:kAppRedColor range:[attr.string rangeOfString:currentHandel options:NSBackwardsSearch]];
        
        //人数
        NSMutableAttributedString *nAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"还剩下 %@位",waitNumber)];
        [nAttr setFont:kFont32];
        [nAttr setColor:kFontColorBlack];
        [nAttr setColor:kAppRedColor range:[nAttr.string rangeOfString:NSStringFormat(@"%@位",waitNumber) options:NSBackwardsSearch]];
        [attr appendAttributedString:nAttr];

        //时间
        NSMutableAttributedString *cAttr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"     预计需要 %@分钟",waitCount)];
        [cAttr setFont:kFont32];
        [cAttr setColor:kFontColorBlack];
        [cAttr setColor:[UIColor redColor] range:[cAttr.string rangeOfString:NSStringFormat(@"%@分钟",waitCount) options:NSBackwardsSearch]];
        [attr appendAttributedString:cAttr];
        
        [_waitLbl setAttributedText:attr];
    }
}




@end
