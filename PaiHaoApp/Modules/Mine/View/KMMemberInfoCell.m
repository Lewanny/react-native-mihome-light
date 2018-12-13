//
//  KMMemberInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMemberInfoCell.h"
#import "KMMemberModel.h"

@interface KMMemberInfoCell ()

/** 头像 */
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
/** 名字 */
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
/** 用户类型 */
@property (strong, nonatomic) IBOutlet UILabel *userTypeLbl;
/** 升级按钮 */
@property (strong, nonatomic) IBOutlet UIButton *upgradeBtn;
/** 信用值 */
@property (strong, nonatomic) IBOutlet UILabel *userFaithLbl;
/** 箭头 */
@property (strong, nonatomic) IBOutlet UIImageView *arrowImg;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;

@end

@implementation KMMemberInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - BaseViewInterface

-(void)km_layoutSubviews{
    _arrowRight.constant          = AdaptedWidth(24);
    _imgWidth.constant            = AdaptedHeight(140);
    [_upgradeBtn setRoundedCorners:UIRectCornerAllCorners radius:_upgradeBtn.height / 2.0];
    [_iconImg setRoundedCorners:UIRectCornerAllCorners radius:5.0];
}

-(void)km_bindData:(id)data{
    if (!data) {
        return;
    }
    KMMemberModel *member         = data;
    NSString *imageUrl            = @"";
    
    KM_CustomerType customerType  = [member.customertype integerValue];
    
    if (customerType == KM_CustomerTypePersonal) {
        [_nameLbl setText:member.username];
        imageUrl                  = ImageFullUrlWithUrl(member.headportrait ? member.headportrait : @"");
    }else{
        [_nameLbl setText:member.businessname];
        imageUrl                  = ImageFullUrlWithUrl(member.picture ? member.picture : @"");
    }
    switch (customerType) {
        case KM_CustomerTypePersonal:
            [_userTypeLbl setText:@"普通用户"];
            break;
        case KM_CustomerTypeOrdinary:
            [_userTypeLbl setText:@"普通商户"];
            break;
        case KM_CustomerTypeCertification:
            [_userTypeLbl setText:@"高级商户"];
            break;
        case KM_CustomerTypeGold:
            [_userTypeLbl setText:@"白金商户"];
            break;
        default:
            break;
    }
    //信用值
    NSMutableAttributedString * s = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"信用值 %.1f 分",member.creditscore)];
    NSRange subRange              = [s.string rangeOfString:NSStringFormat(@"%.1f",member.creditscore) options:NSBackwardsSearch];
    
    [s setFont:kFont26];
    [s setFont:kFont32 range:subRange];
    [s setColor:kFontColorDarkGray];
    [s setColor:HEXCOLOR(@"f78c22") range:subRange];
    
    [_userFaithLbl setAttributedText:s];
    
    [_iconImg setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:GetNormalPlaceholderImage];
}

-(void)km_bindRacEvent{
    @weakify(self)
    [_upgradeBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self.updateSubject sendNext:nil];
    }];
}

+(CGFloat)cellHeight{
    return AdaptedHeight(140 + 20);
}

#pragma mark - Lazy -
-(RACSubject *)updateSubject{
    if (!_updateSubject) {
        _updateSubject            = [RACSubject subject];
    }
    return _updateSubject;
}

@end
