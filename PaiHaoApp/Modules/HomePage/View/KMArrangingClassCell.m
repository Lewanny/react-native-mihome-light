//
//  KMArrangingClassCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMArrangingClassCell.h"
#import "KMMerchantTypeModel.h"
@interface KMArrangingClassCell ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation KMArrangingClassCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self                     = [super initWithFrame:frame]) {
    self.backgroundColor         = [UIColor whiteColor];

    }
    return self;
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    CGFloat btnW                 = KScreenWidth / 4.0;
    CGFloat btnH                 = AdaptedHeight(370) / 2.0;

    for (int i                   = 0; i < [self btnImageNameArray].count; i ++) {

    UIImage *btnImage            = [UIImage imageNamed:[[self btnImageNameArray] objectAtIndex:i]];
    NSString *btnTitle           = [[self btnTitleArray] objectAtIndex:i];

    UIButton *btn                = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitle forState:UIControlStateNormal];

        [btn setTitleColor:kFontColorDark forState:UIControlStateNormal];

        [btn setImage:btnImage forState:UIControlStateNormal];

    btn.titleLabel.font          = kFont28;

    CGFloat btnX                 = (i % 4) * btnW;
    CGFloat btnY                 = (i / 4) * btnH;

    btn.frame                    = CGRectMake(btnX, btnY, btnW, btnH);

        [btn jk_setImagePosition:LXMImagePositionTop spacing:AdaptedHeight(5)];

    UIEdgeInsets imageInsets     = btn.imageEdgeInsets;
    imageInsets.top              = AdaptedHeight(20);
    btn.imageEdgeInsets          = imageInsets;

    UIEdgeInsets titleEdgeInsets = btn.titleEdgeInsets;
    titleEdgeInsets.top          = btn.imageView.image.size.height;
    btn.titleEdgeInsets          = titleEdgeInsets;
        [self.btnArray addObject:btn];
        [self.contentView addSubview:btn];

        @weakify(btn)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(btn)
    NSString *categoryID         = [KMTool categoryIDWithName:btn.currentTitle];
            [self.btnClickSubject sendNext:categoryID];
        }];
    }
}

-(void)km_bindData:(id)data{

}


-(NSArray *)btnImageNameArray{
    return @[
             @"zhenwu",
             @"jingqu",
             @"huodong",
             @"yiyuan",
             @"canyin",
             @"piaowu",
             @"tijian",
             @"qita"
             ];
}

-(NSArray *)btnTitleArray{
   return @[
            @"政务",
            @"景区",
            @"活动",
            @"医院",
            @"餐饮",
            @"车辆",
            @"体检",
            @"其他"
            ];
}
#pragma mark - Lazy
-(NSMutableArray *)btnArray{
    if (!_btnArray) {
    _btnArray                    = [NSMutableArray array];
    }
    return _btnArray;
}
-(RACSubject *)btnClickSubject{
    if (!_btnClickSubject) {
    _btnClickSubject             = [RACSubject subject];
    }
    return _btnClickSubject;
}
@end
