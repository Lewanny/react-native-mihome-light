//
//  KMCommentHeader.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCommentHeader.h"
#import "HCSStarRatingView.h"
#import "KMGroupCommentModel.h"
@interface KMCommentHeader ()

@property (strong, nonatomic) IBOutlet UILabel *commentNumLbl;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UILabel *scoreLbl;
@property (strong, nonatomic) IBOutlet UILabel *averageTextLbl;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (strong, nonatomic) IBOutlet UILabel *rateLbl;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentNumLeft;


@end

@implementation KMCommentHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self km_addSubviews];
        [self km_setupSubviewsLayout];
        [self km_bindViewModel];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self km_addSubviews];
    [self km_setupSubviewsLayout];
    [self km_bindViewModel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self km_layoutSubviews];
}

+(CGFloat)viewHeight{
    return AdaptedHeight(220);
}

#pragma mark - BaseViewInterface

-(void)km_bindViewModel{}
-(void)km_bindRacEvent{}
-(void)km_setupSubviewsLayout{}

-(void)km_addSubviews{

    _commentNumLbl.textColor              = kFontColorDark;
    _commentNumLbl.font                   = [kFont28 fontWithBold];
    
    _commentBtn.titleLabel.font           = kFont26;
    [_commentBtn setTitleColor:kFontColorDark forState:UIControlStateNormal];
    
    _scoreLbl.font                        = [AdaptedFontSizePx(60) fontWithBold];
    _scoreLbl.textColor                   = HEXCOLOR(@"ff9402");
    
    _averageTextLbl.font                  = kFont26;
    _averageTextLbl.textColor             = kFontColorDarkGray;
    
    _rateLbl.font                         = kFont26;
    _rateLbl.textColor                    = kFontColorDarkGray;
    
    _starView.userInteractionEnabled      = NO;
    
    
    {
        _commentBtn.hidden                = YES;
        _arrow.hidden                     = YES;
    }
}

-(void)km_layoutSubviews{
    _arrowTop.constant                    = AdaptedHeight(24);
    _arrowRight.constant                  = AdaptedWidth(24);
    _commentNumLeft.constant              = AdaptedWidth(24);
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMGroupCommentModel class]]) {
        KMGroupCommentModel * commentInfo = data;
        
        [_scoreLbl setText:NSStringFormat(@"%.1f",commentInfo.averageScore)];
        [_rateLbl setText:NSStringFormat(@"好评率%ld%%",commentInfo.favorableRate)];
        [_starView setValue:commentInfo.averageScore];
        
        NSString *numStr                  = NSStringFormat(@"(%ld)",commentInfo.total);
        NSString *fullStr                 = NSStringFormat(@"用户评价 %@",numStr);
        
        
        NSMutableAttributedString * attr  = [KMTool attributedFullStr:fullStr
                                                   FullStrAttributes:@{NSFontAttributeName : _commentNumLbl.font, NSForegroundColorAttributeName : _commentNumLbl.textColor}
                                                            RangeStr:numStr
                                                  RangeStrAttributes:@{NSFontAttributeName : kFont26, NSForegroundColorAttributeName : kFontColorDarkGray}
                                                             Options:NSBackwardsSearch];
        [_commentNumLbl setAttributedText:attr];
    }
}

@end
