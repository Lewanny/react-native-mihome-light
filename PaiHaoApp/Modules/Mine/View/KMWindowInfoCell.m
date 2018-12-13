//
//  KMWindowInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMWindowInfoCell.h"

@interface KMWindowInfoCell ()

@property (nonatomic, strong) YYLabel * labelA;

@property (nonatomic, strong) YYLabel * labelB;

@property (nonatomic, strong) YYLabel * labelC;

@property (nonatomic, strong) UIButton * deleBtn;

@end

@implementation KMWindowInfoCell

+(CGFloat)cellHeight{
    return AdaptedHeight(190);
}

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    UIView * content             = self.contentView;
    _labelA                      = [YYLabel new];
    [content addSubview:_labelA];
    _labelB                      = [YYLabel new];
    [content addSubview:_labelB];
    _labelC                      = [YYLabel new];
    [content addSubview:_labelC];
    _deleBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleBtn.titleLabel setFont:kFont32];
    [_deleBtn setBackgroundColor:kAppRedColor];
    @weakify(self)
    [_deleBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.deleSubject sendNext:nil];
    }];
    [content addSubview:_deleBtn];
}
-(void)km_setupSubviewsLayout{
    UIView * content             = self.contentView;
    [_labelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(content);
        make.height.mas_equalTo(content.mas_height).multipliedBy(1.0/3);
        make.right.mas_lessThanOrEqualTo(_deleBtn.mas_left);
    }];
    [_labelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(_labelA.mas_bottom);
        make.height.mas_equalTo(content.mas_height).multipliedBy(1.0/3);
        make.right.mas_lessThanOrEqualTo(_deleBtn.mas_left);
    }];
    [_labelC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.mas_equalTo(_labelB.mas_bottom);
        make.height.mas_equalTo(content.mas_height).multipliedBy(1.0/3);
        make.right.mas_lessThanOrEqualTo(_deleBtn.mas_left);
    }];
    [_deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(content);
        make.width.mas_equalTo(AdaptedWidth(130));
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[RACTuple class]]) {
        RACTuple *t              = data;
        NSAttributedString *strA = t.first;
        [_labelA setAttributedText:strA];
        NSAttributedString *strB = t.second;
        [_labelB setAttributedText:strB];
        NSAttributedString *strC = t.third;
        [_labelC setAttributedText:strC];
    }
}
#pragma mark - Lazy -
-(RACSubject *)deleSubject{
    if (!_deleSubject) {
        _deleSubject             = [RACSubject subject];
    }
    return _deleSubject;
}
@end
