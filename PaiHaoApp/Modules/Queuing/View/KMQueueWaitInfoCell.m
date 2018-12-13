//
//  KMQueueWaitInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMQueueWaitInfoCell.h"
#import "KMQueueDetail.h"
@interface KMQueueWaitInfoCell ()

/** 排队信息 */
@property (nonatomic, strong) UILabel * w_label;
@end

@implementation KMQueueWaitInfoCell

+(CGFloat)cellHeight{
    return AdaptedHeight(160);
}

#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    //排队信息
    _w_label                               = [UILabel new];
    _w_label.numberOfLines                 = 2;
    [_w_label setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_w_label];
}
-(void)km_setupSubviewsLayout{
    [_w_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, AdaptedWidth(24), 0, AdaptedWidth(24)));
    }];
}
-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMQueueDetail class]]) {
        KMQueueDetail *detail              = data;
        NSString *currentnoStr             = NSStringFormat(@"您的号位是 %@ , ",detail.currentno);
        NSString *currenthandleStr         = NSStringFormat(@"当前办理 %@\n",detail.currenthandle);
        NSString *waitingcountStr          = NSStringFormat(@"您前面还有 %@人 , ",detail.waitingcount);
        NSString *waitingtimeStr           = NSStringFormat(@"预计需要 %@分钟",detail.waitingtime);
        
        NSDictionary *fullAttributes       = @{NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kFontColorBlack};
        NSDictionary *redColorAttributes   = @{NSForegroundColorAttributeName : kAppRedColor};
        NSDictionary *themeColorAttributes = @{NSForegroundColorAttributeName : kMainThemeColor};
        
        NSMutableAttributedString *attr    = [KMTool attributedFullStr:currentnoStr FullStrAttributes:fullAttributes RangeStr:detail.currentno RangeStrAttributes:themeColorAttributes Options:NSBackwardsSearch];
        
        [attr appendAttributedString:[KMTool attributedFullStr:currenthandleStr FullStrAttributes:fullAttributes RangeStr:detail.currenthandle RangeStrAttributes:themeColorAttributes Options:NSBackwardsSearch]];
        
        [attr appendAttributedString:[KMTool attributedFullStr:waitingcountStr FullStrAttributes:fullAttributes RangeStr:[detail.waitingcount stringByAppendingString:@"人"] RangeStrAttributes:redColorAttributes Options:NSBackwardsSearch]];
        
        [attr appendAttributedString:[KMTool attributedFullStr:waitingtimeStr FullStrAttributes:fullAttributes RangeStr:[detail.waitingtime stringByAppendingString:@"分钟"] RangeStrAttributes:redColorAttributes Options:NSBackwardsSearch]];
        
        [_w_label setAttributedText:attr];
    }
}

@end
