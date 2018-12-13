//
//  KMGroupInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupInfoCell.h"
#import "KMGroupInfo.h"
#import "KMGroupDetailInfo.h"
@implementation KMGroupInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight{
    return AdaptedHeight(244);
}
#pragma mark - BaseViewInterface
-(void)km_bindData:(id)data{
    
    [self.distanceLabel setHidden:YES];
    [self.mapBtn setHidden:YES];
    
    if ([data isKindOfClass:[KMGroupInfo class]]) {
        KMGroupInfo *info = data;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(info.photo ? info.photo : @"")] placeholder:GetNormalPlaceholderImage];
        [self.nameLabel setText:info.groupname];
        [self.IDLabel setText:NSStringFormat(@"ID:%@",info.groupno)];
        [self.timeLabel setText:info.timespan];

        NSString *numStr               = NSStringFormat(@"%ld",info.waitingcount);
        NSAttributedString *attrNumStr = [KMTool attributedFullStr:NSStringFormat(@"等待人数%@人",numStr)
                                                 FullStrAttributes:@{
                                                                     NSForegroundColorAttributeName : kFontColorGray,
                                                                     NSFontAttributeName : kFont26
                                                                     }
                                                          RangeStr:numStr
                                                RangeStrAttributes:@{
                                                                     NSForegroundColorAttributeName : kAppRedColor,
                                                                     NSFontAttributeName : kFont32
                                                                     }
                                                           Options:NSBackwardsSearch];
        [self.statusLabel setAttributedText:attrNumStr];
    }else if ([data isKindOfClass:[KMGroupDetailInfo class]]){
        KMGroupDetailInfo *info        = data;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(info.photo ? info.photo : @"")] placeholder:GetNormalPlaceholderImage];
        [self.nameLabel setText:info.groupname];
        [self.IDLabel setText:NSStringFormat(@"ID:%@",info.groupno)];
        [self.timeLabel setText:info.queuingtime];
        NSString *numStr               = info.currentcount;
        NSAttributedString *attrNumStr = [KMTool attributedFullStr:NSStringFormat(@"排队总人数%@人",numStr)
                                                 FullStrAttributes:@{
                                                                     NSForegroundColorAttributeName : kFontColorGray,
                                                                     NSFontAttributeName : kFont26
                                                                     }
                                                          RangeStr:numStr
                                                RangeStrAttributes:@{
                                                                     NSForegroundColorAttributeName : kAppRedColor,
                                                                     NSFontAttributeName : kFont32
                                                                     }
                                                           Options:NSBackwardsSearch];
        [self.statusLabel setAttributedText:attrNumStr];
    }
}



@end
