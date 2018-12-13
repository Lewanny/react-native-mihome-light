//
//  KMGroupWaitInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupWaitInfoCell.h"
#import "KMGroupDetailInfo.h"
@implementation KMGroupWaitInfoCell

+(CGFloat)cellHeight{
    return AdaptedHeight(88);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    [self.contentView addSubview:self.waitLabel];
}

-(void)km_layoutSubviews{
    [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptedWidth(24));
        make.right.mas_equalTo(self.contentView).offset(AdaptedWidth(-24));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
}
-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMGroupDetailInfo class]]) {
        KMGroupDetailInfo *info         = data;
        NSString *waitNumStr            = NSStringFormat(@"%@位",info.waitingcount);
        NSString *waitTimeStr           = NSStringFormat(@"%@分钟",info.waitingtime);
        NSString *fullNumStr            = NSStringFormat(@"还剩下 %@ ,",waitNumStr);
        NSString *fullTimeStr           = NSStringFormat(@"预计需要 %@",waitTimeStr);
        NSMutableAttributedString *attr = [KMTool attributedFullStr:fullNumStr
                                                  FullStrAttributes:@{
                                                                      NSFontAttributeName : kFont32,
                                                                      NSForegroundColorAttributeName : kFontColorBlack
                                                                      }
                                                           RangeStr:waitNumStr
                                                 RangeStrAttributes:@{
                                                                      NSForegroundColorAttributeName : kAppRedColor
                                                                      }
                                                            Options:NSBackwardsSearch];
        [attr appendAttributedString:[KMTool attributedFullStr:fullTimeStr
                                            FullStrAttributes:@{
                                                                NSFontAttributeName : kFont32,
                                                                NSForegroundColorAttributeName : kFontColorBlack
                                                                }
                                                     RangeStr:waitTimeStr
                                           RangeStrAttributes:@{
                                                                NSForegroundColorAttributeName : kAppRedColor
                                                                }
                                                       Options:NSBackwardsSearch]];
        [_waitLabel setAttributedText:attr];
    }
}
#pragma mark - Lazy;
-(UILabel *)waitLabel{
    if (!_waitLabel) {
        _waitLabel                      = [UILabel new];
        _waitLabel.textAlignment        = NSTextAlignmentCenter;
    }
    return _waitLabel;
}
@end
