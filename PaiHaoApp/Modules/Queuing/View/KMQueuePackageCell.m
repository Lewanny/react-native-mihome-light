//
//  KMQueuePackageCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMQueuePackageCell.h"
#import "KMQueueDetail.h"
@interface KMQueuePackageCell ()

/** 套餐 */
@property (nonatomic, strong) UILabel * packageLbl;

@property (nonatomic, strong) UIView * packageBG;

@end

@implementation KMQueuePackageCell

+(CGFloat)cellHeight{
//    return UITableViewAutomaticDimension;
    return AdaptedHeight(140);
}

-(void)km_addSubviews{

    //背景
    _packageBG                           = [UIView new];
    _packageBG.backgroundColor           = kFontColorLightGray;
    [self.contentView addSubview:_packageBG];
    //套餐
    _packageLbl                          = [UILabel new];
    _packageLbl.textColor                = kFontColorGray;
    _packageLbl.font                     = kFont22;
    _packageLbl.numberOfLines            = 0;
    [_packageLbl setUserInteractionEnabled:YES];
    [_packageBG addSubview:_packageLbl];
}

-(void)km_setupSubviewsLayout{
    
    [_packageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(AdaptedHeight(24), AdaptedWidth(24), AdaptedHeight(24), AdaptedWidth(24)));
    }];
    
    CGFloat labelH                       = [@"11" heightForFont:_packageLbl.font width:CGFLOAT_MAX];
    [_packageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(AdaptedHeight(10), AdaptedWidth(20), AdaptedHeight(10), AdaptedWidth(20)));
        make.height.mas_greaterThanOrEqualTo(2*labelH + 10).priorityHigh();
    }];
}

-(void)km_layoutSubviews{
    [_packageBG cornerRadius:AdaptedWidth(5) strokeSize:0.5 color:kFontColorGray];
    _packageBG.layer.masksToBounds       = YES;
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMQueueDetail class]]) {
        KMQueueDetail *detail            = data;
        NSString *fullStr                = [[detail.packageName stringByAppendingString:@": "] stringByAppendingString:detail.packageInfo];
        NSDictionary *fullAttributes     = @{NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kFontColorDarkGray};
        NSDictionary *rangeStrAttributes = @{NSFontAttributeName : kFont22, NSForegroundColorAttributeName : kFontColorGray};
        NSMutableAttributedString *attr  = [KMTool attributedFullStr:fullStr FullStrAttributes:fullAttributes RangeStr:detail.packageInfo RangeStrAttributes:rangeStrAttributes Options:NSBackwardsSearch];
        [_packageLbl setAttributedText:attr];
    }
}

-(void)km_bindRacEvent{
    @weakify(self)
    [_packageLbl addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self)
        [self.seeSubject sendNext:nil];
    }];
}

#pragma mark - Lazy -
-(RACSubject *)seeSubject{
    if (!_seeSubject) {
        _seeSubject                      = [RACSubject subject];
    }
    return _seeSubject;
}
@end
