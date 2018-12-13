//
//  KMGroupQueueDetailInfoCell.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueDetailInfoCell.h"
#import "KMGroupBaseInfo.h"
#import "KMPackageItem.h"
@interface KMGroupQueueDetailInfoCell ()

@property (strong, nonatomic) IBOutlet UIView *groupInfoBG;
@property (strong, nonatomic) IBOutlet UIView *groupInfoLine;

@property (strong, nonatomic) IBOutlet UIView *remindBG;
@property (strong, nonatomic) IBOutlet UIView *remindLine;

@property (strong, nonatomic) IBOutlet UIView *setTimeBG;
@property (strong, nonatomic) IBOutlet UIView *setTimeLine;

@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *IDLbl;
@property (strong, nonatomic) IBOutlet UILabel *distanceLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
@property (strong, nonatomic) IBOutlet UILabel *addressLbl;
@property (strong, nonatomic) IBOutlet UIButton *msgRemindBtn;
@property (strong, nonatomic) IBOutlet UIButton *voiceRemindBtn;
@property (strong, nonatomic) IBOutlet UILabel *setTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeTextLbl;
@property (strong, nonatomic) IBOutlet UIButton *queueNowBtn;
@property (strong, nonatomic) IBOutlet UILabel *waitInfoLbl;

@property (strong, nonatomic) IBOutlet UIButton *QRBtn;
@property (strong, nonatomic) IBOutlet UILabel *tipsLbl1;
@property (strong, nonatomic) IBOutlet UILabel *tipsLbl2;



//约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *groupInfoBGHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *remindBGHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *setTimeBGHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconTop;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconLeft;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *queueBtnBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *distanceWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *remindBtnWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *waitInfoHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *queueBtnW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *queueBtnH;



//套餐
@property (nonatomic, strong) UIView * comboBG;
@property (nonatomic, strong) UIView * comboContent;
@property (nonatomic, strong) UILabel * comboLeftLbl;
@property (nonatomic, strong) UILabel * comboRightLbl;
@property (nonatomic, strong) UIView * comboLine;
@end

@implementation KMGroupQueueDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithCombo:(BOOL)combo{
    if (combo) {
        return UITableViewAutomaticDimension;
//       return AdaptedHeight(214 + 104 + 104 + 120 + 140);
    }
    return AdaptedHeight(214 + 104 + 104 + 120);
}

-(void)createComboView{
    if (_comboBG) {
        return;
    }
    //套餐背景
    _comboBG                              = [UIView new];
    [self.contentView addSubview:_comboBG];
    //套餐content
    _comboContent                         = [UIView new];
    _comboContent.backgroundColor         = kFontColorLightGray;
    [_comboBG addSubview:_comboContent];
    //左边
    _comboLeftLbl                         = [UILabel new];
    _comboLeftLbl.backgroundColor         = kMainThemeColor;
    _comboLeftLbl.textColor               = [UIColor whiteColor];
    _comboLeftLbl.font                    = kFont30;
     _comboLeftLbl.textAlignment          = NSTextAlignmentCenter;
    [_comboLeftLbl setText:@"选择套餐"];
    [_comboContent addSubview:_comboLeftLbl];
    //右边
    _comboRightLbl                        = [UILabel new];
    _comboRightLbl.backgroundColor        = [UIColor clearColor];
    _comboRightLbl.textColor              = kFontColorGray;
    _comboRightLbl.font                   = kFont22;
    _comboRightLbl.numberOfLines          = 0;
    [_comboRightLbl setText:@"您可以选择多个队列组成的套餐,一次排号,自动优先到最快的队列。"];
    [_comboContent addSubview:_comboRightLbl];
    //底部分割线
    _comboLine                            = [UIView new];
    _comboLine.backgroundColor            = [UIColor lightGrayColor];
    [_comboBG addSubview:_comboLine];
    
    //点击事件
    _comboBG.userInteractionEnabled       = YES;
    @weakify(self)
    [_comboBG addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self)
        [self.packageSubject sendNext:nil];
    }];
    
    
    [_comboBG mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_setTimeBG.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(AdaptedHeight(-120)).priorityHigh();
    }];
    [_comboContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(AdaptedHeight(24), AdaptedWidth(24), AdaptedHeight(24), AdaptedWidth(24)));
    }];
    
    [_comboLeftLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(_comboContent);
        make.width.mas_equalTo(AdaptedWidth(160));
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    
    CGFloat labelH                        = [@"11" heightForFont:_comboRightLbl.font width:CGFLOAT_MAX];
    [_comboRightLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_comboContent).offset(AdaptedHeight(10));
        make.bottom.mas_equalTo(_comboContent).offset(AdaptedHeight(-10));
        make.right.mas_equalTo(_comboContent).offset(AdaptedWidth(-20));
        make.left.mas_equalTo(_comboLeftLbl.mas_right).offset(5);
        make.height.mas_equalTo(2*labelH + 10);
    }];
    
    [_comboLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(_comboBG);
        make.height.mas_equalTo(0.5);
    }];
    
    [self layoutIfNeeded];
}


#pragma mark - BaseViewInterface
-(void)km_addSubviews{
    _nameLbl.textColor                    = kFontColorBlack;
    _IDLbl.textColor                      = kMainThemeColor;
    _distanceLbl.textColor                = kFontColorGray;
    _timeLbl.textColor                    = kFontColorGray;
    _addressLbl.textColor                 = kFontColorGray;
    
    _msgRemindBtn.titleLabel.textColor    = kFontColorBlack;
    _voiceRemindBtn.titleLabel.textColor  = kFontColorBlack;
    
    _setTimeLbl.textColor                 = kFontColorBlack;
    _timeTextLbl.textColor                = kFontColorLightGray;
    
    [_queueNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _nameLbl.font                         = kFont32;
    _nameLbl.adjustsFontSizeToFitWidth    = YES;
    _nameLbl.numberOfLines                = 0;
    _IDLbl.font                           = kFont24;
    _distanceLbl.font                     = kFont24;
    _timeLbl.font                         = kFont26;
    _addressLbl.font                      = kFont26;
    
    _msgRemindBtn.titleLabel.font         = kFont28;
    _msgRemindBtn.selected                = YES;
    _msgRemindBtn.userInteractionEnabled  = NO;
    
    _voiceRemindBtn.titleLabel.font       = kFont28;
    _voiceRemindBtn.selected                = YES;
    
    _setTimeLbl.font                      = kFont28;
    _timeTextLbl.font                     =kFont28;
    
    _queueNowBtn.titleLabel.font          = kFont32;
    
    _tipsLbl1.font                        = kFont22;
    _tipsLbl2.font                        = kFont22;
    
    
    [_queueNowBtn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
    
    _setTimeBG.userInteractionEnabled     = YES;
}

-(void)km_setupSubviewsLayout{
    _groupInfoBGHeight.constant           = AdaptedHeight(214);
    _remindBGHeight.constant              = AdaptedHeight(104);
    _setTimeBGHeight.constant             = AdaptedHeight(104);
    
    _iconTop.constant                     = AdaptedHeight(24);
    _iconLeft.constant                    = AdaptedWidth(24);
    _iconBottom.constant                  = AdaptedHeight(24);
    _labelRight.constant                  = AdaptedWidth(24);
    _queueBtnH.constant                   = AdaptedHeight(120 - 24 -24);
    _queueBtnBottom.constant              = AdaptedHeight(24);
    _remindBtnWidth.constant              = AdaptedWidth(180);
    _waitInfoHeight.constant              = AdaptedHeight(120);
    _queueBtnW.constant                   = AdaptedWidth(170);
    
    [self layoutIfNeeded];
    
    [_iconImg setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
    [_queueNowBtn setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(5)];
}

-(void)km_layoutSubviews{
    
    if (_comboBG) {
        [_comboContent cornerRadius:AdaptedWidth(5) strokeSize:0.5 color:kFontColorGray];
        _comboContent.layer.masksToBounds = YES;
    }
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[KMGroupBaseInfo class]]) {
        KMGroupBaseInfo *info             = data;
        //队列图片
        [_iconImg setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(info.groupphoto ? info.groupphoto : @"")] placeholder:GetNormalPlaceholderImage];
        //队列名称
        [_nameLbl setText:info.groupname];
        //队列ID
        [_IDLbl setText:NSStringFormat(@"ID:%@",info.groupno)];
        //时间段
        [_timeLbl setText:info.timespan];
        //队列地址
        [_addressLbl setText:info.groupaddr];
        
        //计算距离
        CLLocation *location              = [[CLLocation alloc]initWithLatitude:[info.lat floatValue] longitude:[info.lng floatValue]];
        NSString * distance               = [KMLocationManager distanceWithTargetLocation:location];
        [_distanceLbl setText:distance];
        
        //等待信息
        NSString *waitNum                 = NSStringFormat(@"前面人数%@人  ",info.frontnumber);
        NSString *waitTime                = NSStringFormat(@"预计%@分钟",info.waittime);
        
        NSDictionary *fullStrAttributes   = @{NSFontAttributeName : kFont22, NSForegroundColorAttributeName : kFontColorGray};
        NSDictionary *rangeStrAttributes  = @{NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kAppRedColor};
        
        NSMutableAttributedString *attr   = [KMTool attributedFullStr:waitNum FullStrAttributes:fullStrAttributes RangeStr:info.frontnumber RangeStrAttributes:rangeStrAttributes Options:NSBackwardsSearch];
        
        [attr appendAttributedString:[KMTool attributedFullStr:waitTime FullStrAttributes:fullStrAttributes RangeStr:info.waittime RangeStrAttributes:rangeStrAttributes Options:NSBackwardsSearch]];
        [_waitInfoLbl setAttributedText:attr];
        
        //提醒时间
        [_timeTextLbl setText:info.minutes == nil || [info.minutes isEqualToNumber:@(0)] ? @"" : NSStringFormat(@"%@分钟",info.minutes)];
        
        //是否已经排队
        [_queueNowBtn setTitle:info.alreadyQueue ? @"退出排队" : @"立即排队" forState:UIControlStateNormal];
        [_queueNowBtn setBackgroundImage:[UIImage imageWithColor:info.alreadyQueue ? kAppRedColor : kMainThemeColor] forState:UIControlStateNormal];
        //是否有套餐
        if (info.hasPackage && !_comboBG) {
            [self createComboView];
        }
        
        //有套餐且已经在排队
        if (info.hasPackage) {
            _comboBG.userInteractionEnabled = !info.alreadyQueue;
            [_comboLeftLbl setBackgroundColor:info.alreadyQueue?kFontColorGray:kMainThemeColor];
        }
        
        //判断队列解散
        if (info.groupstatus == 1) {
            //队列已解散
            [_queueNowBtn setTitle:@"队列已解散" forState:UIControlStateDisabled];
            _queueNowBtn.enabled = NO;
        }
        
    }else if ([data isKindOfClass:[KMPackageItem class]]){
        KMPackageItem *item               = data;
        NSString *fullStr                 = [[item.packageName stringByAppendingString:@": "] stringByAppendingString:item.pg];
        NSDictionary *fullAttributes      = @{NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kFontColorDarkGray};
        NSDictionary *rangeStrAttributes  = @{NSFontAttributeName : kFont22, NSForegroundColorAttributeName : kFontColorGray};
        NSMutableAttributedString *attr   = [KMTool attributedFullStr:fullStr FullStrAttributes:fullAttributes RangeStr:item.pg RangeStrAttributes:rangeStrAttributes Options:NSBackwardsSearch];
        [_comboRightLbl setAttributedText:attr];
    }
}




-(void)km_bindRacEvent{
    @weakify(self)
    
    [[_voiceRemindBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected                        = !x.selected;
        [self.voiceSubject sendNext:[NSNumber numberWithBool:x.selected]];
    }];
 
    [_setTimeBG addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self)
        [self.setTimeSubject sendNext:self.timeTextLbl];
    }];
    
    [[_queueNowBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.queueNowSubject sendNext:nil];
    }];
    [[_QRBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.QRSubject sendNext:nil];
    }];
//    [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self)
//        [self.teleSubject sendNext:nil];
//    }];
    [[_callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.mapSubject sendNext:nil];
    }];
}

#pragma mark - Lazy
-(RACSubject *)setTimeSubject{
    if (!_setTimeSubject) {
        _setTimeSubject                   = [RACSubject subject];
    }
    return _setTimeSubject;
}

-(RACSubject *)queueNowSubject{
    if (!_queueNowSubject) {
        _queueNowSubject                  = [RACSubject subject];
    }
    return _queueNowSubject;
}
-(RACSubject *)voiceSubject{
    if (!_voiceSubject) {
        _voiceSubject                     = [RACSubject subject];
    }
    return _voiceSubject;
}
-(RACSubject *)packageSubject {
    if (!_packageSubject) {
        _packageSubject                   = [RACSubject subject];
    }
    return _packageSubject;
}
-(RACSubject *)QRSubject{
    if (!_QRSubject) {
        _QRSubject                        = [RACSubject subject];
    }
    return _QRSubject;
}
-(RACSubject *)teleSubject{
    if (!_teleSubject) {
        _teleSubject                      = [RACSubject subject];
    }
    return _teleSubject;
}
-(RACSubject *)mapSubject{
    if (!_mapSubject) {
        _mapSubject                     = [RACSubject subject];
    }
    return _mapSubject;
}
@end
