//
//  KMSeePackageCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSeePackageCell.h"

@interface KMSeePackageCell ()

@property (nonatomic, strong) UILabel * numLbl;

@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UILabel * statusLbl;

@end

@implementation KMSeePackageCell

+(CGFloat)cellHeight{
    return UITableViewAutomaticDimension;
}

#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    UIView *content                                                       = self.contentView;
    
    _numLbl                                                               = [UILabel new];
    [_numLbl setFont:kFont30];
    [_numLbl setTextColor:kFontColorGray];
    [content addSubview:_numLbl];
    
    _nameLbl                                                              = [UILabel new];
    [_nameLbl setFont:kFont30];
    [_nameLbl setTextColor:kFontColorGray];
    [_nameLbl setNumberOfLines:0];
    [_nameLbl setTextAlignment:NSTextAlignmentCenter];
    [content addSubview:_nameLbl];
    
    _statusLbl                                                            = [UILabel new];
    [_statusLbl setFont:kFont30];
    [_statusLbl setTextColor:kFontColorGray];
    [_statusLbl setTextAlignment:NSTextAlignmentRight];
    [content addSubview:_statusLbl];
}

-(void)km_setupSubviewsLayout{
    UIView *content                                                       = self.contentView;
    
    [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(content);
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.width.mas_equalTo(AdaptedWidth(130));
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(content).offset(AdaptedHeight(10));
        make.bottom.mas_equalTo(content).offset(AdaptedHeight(-10)).priorityHigh();
        make.left.mas_equalTo(_numLbl.mas_right);
        make.right.mas_equalTo(_statusLbl.mas_left);
        make.height.mas_greaterThanOrEqualTo(25);
    }];
    
    [_statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(content);
        make.right.mas_equalTo(content).offset(AdaptedWidth(-24));
        make.width.mas_equalTo(AdaptedWidth(130));
    }];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[RACTuple class]]) {
        RACTupleUnpack(NSString * num, NSString * name, NSNumber *status) = data;
        [_numLbl setText:num];
        [_nameLbl setText:name];
       
        switch ([status integerValue]) {
            case KMPackageStatusNotYet:{
                [_statusLbl setTextColor:kFontColorDark];
                [_statusLbl setText:@"未办理"];
            }
                break;
            case KMPackageStatusInProcess:{
                [_statusLbl setTextColor:kMainThemeColor];
                [_statusLbl setText:@"办理中"];
            }
                break;
            case KMPackageStatusYet:{
                [_statusLbl setTextColor:kFontColorGray];
                [_statusLbl setText:@"已办理"];
            }
                break;
            default:
                break;
        }
        [_numLbl setTextColor:_statusLbl.textColor];
        [_nameLbl setTextColor:_statusLbl.textColor]; 
    }
}

@end
