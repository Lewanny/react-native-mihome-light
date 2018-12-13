//
//  KMGroupQueueDataCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueDataCell.h"
#import "KMQueueDataModel.h"
#import "KMQueueDetail.h"
@implementation KMGroupQueueDataCell
+(CGFloat)cellHeight{
    return AdaptedHeight(78);
}
#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    [self.contentView addSubview:self.numberLbl];
    [self.contentView addSubview:self.teleLbl];
    [self.contentView addSubview:self.windowLbl];
}

-(void)km_layoutSubviews{
    [_numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.25);
    }];
    [_teleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_numberLbl.mas_right);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
    }];
    [_windowLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_teleLbl.mas_right);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.25);
    }];
    [@[_numberLbl, _teleLbl, _windowLbl] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
    }];
}
-(void)km_bindData:(id)data{
    //判断是批量叫号还是单叫号，批量叫号：有窗口时显示窗口，无窗口时显示办理中，单叫：显示办理中，第一个条数据，有窗口时显示窗口，无窗口显示办理中
    if ([data isKindOfClass:[KMQueueDataModel class]]) {
        KMQueueDataModel *queueData = data;
        [_numberLbl setText:queueData.bespeakSort];
        [_teleLbl setText:queueData.phone];
        NSLog(@"%@",queueData.queueState);
        if (queueData.queueState) {
            //在 首页--景区--排号详情页
            //大于0 是为批量
            NSString *queueState = queueData.queueState;
            queueState = [queueState stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([queueState isEqualToString:@"5"]) {
                [_windowLbl setText:queueData.windowName];
                _windowLbl.textColor        = kMainThemeColor;
            }else if ([queueState isEqualToString:@"0"]){
                [_windowLbl setText:@"等待中"];
                _windowLbl.textColor        = kFontColorBlack;
            }
        }else{
            if (queueData.windowName.length) {
                //有窗口则显示窗口
                [_windowLbl setText:queueData.windowName];
                _windowLbl.textColor        = kMainThemeColor;
            }else{
                //无窗口显示办理中
                [_windowLbl setText:@"等待中"];
                _windowLbl.textColor        = kFontColorBlack;
            }
        }
    }else if ([data isKindOfClass:[KMQueueItem class]]){
        KMQueueItem *item           = data;
        [_numberLbl setText:item.bespeakSort];
        [_teleLbl setText:item.phone];
            //大于0 是为批量
        if (item.queueState) {
            //在 首页--景区--排号详情页
            //大于0 是为批量
            NSString *queueState = item.queueState;
            queueState = [queueState stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([queueState isEqualToString:@"5"]) {
                [_windowLbl setText:item.windowName];
                _windowLbl.textColor        = kMainThemeColor;
            }else if ([queueState isEqualToString:@"0"]){
                [_windowLbl setText:@"等待中"];
                _windowLbl.textColor        = kFontColorBlack;
            }
        }
//            if (item.windowName.length) {
//                //有窗口则显示窗口
//                [_windowLbl setText:item.windowName];
//                _windowLbl.textColor        = kMainThemeColor;
//            }else{
//                //无窗口显示办理中
//                [_windowLbl setText:@"办理中"];
//                _windowLbl.textColor        = kMainThemeColor;
//            }
    }
}

#pragma mark - Lazy
-(UILabel *)numberLbl{
    if (!_numberLbl) {
        _numberLbl                  = [UILabel new];
        _numberLbl.font             = kFont28;
        _numberLbl.textColor        = kMainThemeColor;
        _numberLbl.textAlignment    = NSTextAlignmentCenter;
    }
    return _numberLbl;
}
-(UILabel *)teleLbl{
    if (!_teleLbl) {
        _teleLbl                    = [UILabel new];
        _teleLbl.font               = kFont28;
        _teleLbl.textColor          = kFontColorBlack;
        _teleLbl.textAlignment      = NSTextAlignmentCenter;
    }
    return _teleLbl;
}
-(UILabel *)windowLbl{
    if (!_windowLbl) {
        _windowLbl                  = [UILabel new];
        _windowLbl.font             = kFont28;
        _windowLbl.textColor        = kFontColorBlack;
        _windowLbl.textAlignment    = NSTextAlignmentCenter;
    }
    return _windowLbl;
}
@end
