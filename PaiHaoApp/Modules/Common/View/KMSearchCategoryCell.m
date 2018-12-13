//
//  KMSearchCategoryCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSearchCategoryCell.h"

#define BtnTag  999

@interface KMSearchCategoryCell ()

@property (nonatomic, strong) NSMutableArray * btns;

@end

@implementation KMSearchCategoryCell


-(void)btnClick:(UIButton *)sender{
    [self.clickSubject sendNext:@(sender.tag - BtnTag)];
}

+(CGFloat)cellHeight{
    return UITableViewAutomaticDimension;
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    self.backgroundColor   = [UIColor clearColor];
    NSArray *arr           = [KMTool getCategoryType];
    @weakify(self)
    [arr enumerateObjectsUsingBlock:^(KMMerchantTypeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
    UIButton *btn          = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:model.typeName forState:UIControlStateNormal];
        [btn setTitleColor:kFontColorDarkGray forState:UIControlStateNormal];
    btn.backgroundColor    = [UIColor whiteColor];
        [btn cornerRadius:3 strokeSize:0.5 color:HEXCOLOR(@"d6d7dc")];
        [btn.titleLabel setFont:kFont28];
    btn.tag                = BtnTag + idx;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [self.btns addObject:btn];
    }];
}
-(void)km_setupSubviewsLayout{
    UIView *content        = self.contentView;
    CGFloat btnW           = AdaptedWidth(220);
    CGFloat btnH           = AdaptedHeight(76);
    CGFloat vMargin        = AdaptedHeight(20);
    CGFloat hMargin        = AdaptedWidth(20);
    __block NSInteger row  = 0;
    __block NSInteger line = 0;
    [self.btns enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
    row                    = idx % 3;
        if (idx != 0 && idx % 3 == 0) {
            line ++ ;
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(content).offset(vMargin + (line * (vMargin + btnH)));
            make.left.mas_equalTo(content).offset(hMargin + (row * (hMargin + btnW)));
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
            if (idx == self.btns.count - 1) {
                make.bottom.mas_lessThanOrEqualTo(content).offset(-vMargin).priorityHigh();
            }
        }];
    }];
}


#pragma mark - Lazy
-(NSMutableArray *)btns{
    if (!_btns) {
    _btns                  = [NSMutableArray array];
    }
    return _btns;
}
-(RACSubject *)clickSubject{
    if (!_clickSubject) {
    _clickSubject          = [RACSubject subject];
    }
    return _clickSubject;
}
@end
