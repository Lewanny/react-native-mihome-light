//
//  KMGroupQueueDetailUIService.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueDetailUIService.h"
#import "KMGroupQueueDetailInfoCell.h"
#import "KMGroupQueueDataCell.h"
#import "KMGroupCommentCell.h"
#import "KMCommentHeader.h"
#import "KMMemberModel.h"
@interface KMGroupQueueDetailUIService ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMGroupQueueDetailVM * viewModel;

@end

@implementation KMGroupQueueDetailUIService

-(instancetype)initWithTableView:(UITableView *)tableView
                       ViewModel:(KMGroupQueueDetailVM *)viewModel{
    if (self                         = [super init]) {
        _tableView                   = tableView;
        _viewModel                   = viewModel;
        [self configTableView];
        [self bindViewModelEvent];
    }
    return self;
}

#pragma mark - 自定义代码
/** 配置TableView */
-(void)configTableView{
    
    UITableView *tableView           = _tableView;
    tableView.delegate               = self;
    tableView.dataSource             = self;
    tableView.layoutMargins          = UIEdgeInsetsZero;
    tableView.estimatedRowHeight     = 100;
    [tableView registerNib:[KMGroupQueueDetailInfoCell loadNib] forCellReuseIdentifier:[KMGroupQueueDetailInfoCell cellID]];
    [tableView registerClass:[KMGroupQueueDataCell class] forCellReuseIdentifier:[KMGroupQueueDataCell cellID]];
    [tableView registerClass:[KMGroupCommentCell class] forCellReuseIdentifier:[KMGroupCommentCell cellID]];
}

/**
 号群信息 Cell

 @return KMGroupQueueDetailInfoCell
 */
-(UITableViewCell *)cellForGroupInfo{
    //号群信息
    KMGroupQueueDetailInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:[KMGroupQueueDetailInfoCell cellID]];
    KMGroupBaseInfo * baseInfo       = _viewModel.baseInfo;
    
    baseInfo.hasPackage              = _viewModel.packageList.count != 0;
    baseInfo.minutes                 = _viewModel.minutes;
    baseInfo.alreadyQueue            = _viewModel.alreadyQueue;
    
    [cell km_bindData:_viewModel.baseInfo];
    if (_viewModel.packageName.length && _viewModel.packageInfo.length) {
        KMPackageItem *item          = [KMPackageItem new];
        item.packageName             = _viewModel.packageName;
        item.pg                      = _viewModel.packageInfo;
        [cell km_bindData:item];
    }
    
    @weakify(self)
    //点击设置时间
    [[cell.setTimeSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //弹窗选择提醒时间
        [self showRemindTimeAlert];
    }];
    
    //选择语音提醒
    [[cell.voiceSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.isVoice       = [x boolValue];
    }];
    
    //点击立即排队
    [[cell.queueNowSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //处理点击了排队按钮
        [self didClickQueueBtn];
    }];
    
    //点击选择套餐
    [[cell.packageSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //跳转套餐选择
        [self.pushPackageSeleVC sendNext:nil];
    }];
    //点击二维码
    [[cell.QRSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //跳转二维码展示
        [KMUserManager pushQRCodeVCWithData:self.viewModel.baseInfo];
    }];
    //点击电话
    [[cell.mapSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //拨打电话
//        [KMTool callWithTel:self.viewModel.baseInfo.telephone];
        CLLocationCoordinate2D coor;
        NSString *targetName              = @"";
        coor                              = CLLocationCoordinate2DMake([self.viewModel.baseInfo.lat floatValue], [self.viewModel.baseInfo.lng floatValue]);
        targetName                        = self.viewModel.baseInfo.groupname;
        if (coor.latitude && coor.longitude) {
            [KMLocationManager showActionSheetWithMaps:[KMLocationManager getInstalledMapAppWithEndLocation:coor TargetName:targetName]];
        }
        
        
    }];
    return cell;
}

/**
 排队信息 Cell

 @param indexPath 下标
 @return KMGroupQueueDataCell
 */
-(UITableViewCell *)cellForQueueInfo:(NSIndexPath *)indexPath{
    //排队信息
    KMGroupQueueDataCell *queueCell  = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupQueueDataCell cellID]];
    queueCell.backgroundColor        = indexPath.row % 2 == 0 ? [UIColor whiteColor] : [UIColor clearColor];
    [queueCell km_bindData:[self.viewModel.queueArr objectAtIndex:indexPath.row]];
    [queueCell km_setSeparatorLineInset:UIEdgeInsetsZero];
    if (indexPath.row == 0) {
        KMQueueDataModel *model = [self.viewModel.queueArr objectAtIndex:indexPath.row];
        if (model.windowName.length > 0) {
            queueCell.windowLbl.text = model.windowName;
            queueCell.windowLbl.textColor = kMainThemeColor;
        }else{
            queueCell.windowLbl.text = @"办理中";
            queueCell.windowLbl.textColor = kMainThemeColor;
        }
    }
    return queueCell;
}

/**
 评价信息 Cell

 @param indexPath 下标
 @return KMGroupCommentCell
 */
-(UITableViewCell *)cellForGroupComment:(NSIndexPath *)indexPath{
    //评价信息
    KMGroupCommentCell *commentCell = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupCommentCell cellID]];
    KMCommentItem *item             = [self.viewModel.evaluateArr objectAtIndex:indexPath.row];
    [commentCell km_bindData:item];
    [commentCell km_setSeparatorLineInset:UIEdgeInsetsZero];
    return commentCell;
}
/** 段头视图 */
-(UIView *)headerForScetionStyle:(SectionStyle)style{
    if (style == SectionStyleGroupInfo) {
        return [UIView new];
    }
    UIView *header                  = [UIView new];
    header.backgroundColor          = [UIColor whiteColor];
    
    //顶部分割线
    UIView *line                    = [UIView new];
    line.backgroundColor            = [UIColor lightGrayColor];
    line.frame                      = CGRectMake(0, 0, kScreenWidth, 0.5);
    [header addSubview:line];
    
    if (style == SectionStyleQueueInfo) {
        //排队信息
        UILabel *label              = [UILabel new];
        [label setText:@"现场排队情况"];
        label.font                  = kFont32;
        label.textColor             = kFontColorBlack;
        label.frame                 = CGRectMake(AdaptedWidth(24), 0, kScreenWidth - AdaptedWidth(24), AdaptedHeight(78));
        [header addSubview:label];
    }else if (style == SectionStyleEvaluate){
        //评论信息
        KMCommentHeader *header     = [KMCommentHeader loadInstanceFromNib];
        header.frame                = CGRectMake(0, 0, KScreenWidth, [KMCommentHeader viewHeight]);
        [header km_bindData:self.viewModel.commentInfo];
        return header;
    }
    return header;
}
/** 段头视图高度 */
-(CGFloat)headerHeightForScetionStyle:(SectionStyle)style{
    CGFloat height                  = 0.01;
    if (style == SectionStyleQueueInfo) {
        height                      = AdaptedHeight(78);
    }else if (style == SectionStyleEvaluate){
        height                      = [KMCommentHeader viewHeight];
    }
    return height;
}


-(void)bindViewModelEvent{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - 事件响应

/** 弹窗选择提醒时间 */
-(void)showRemindTimeAlert{
    @weakify(self)
    UIAlertView *alert         = [[UIAlertView alloc]initWithTitle:@"设置提醒时间" message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"10分钟", @"20分钟", @"30分钟", @"45分钟", @"60分钟", nil];
    [alert show];
    [[[alert rac_buttonClickedSignal] takeUntil:alert.rac_willDeallocSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        self.viewModel.minutes = [self.viewModel.timeArr objectAtIndex:[x integerValue]];
        [self.tableView reloadData];
    }];
}
/** 点击了排队 */
-(void)didClickQueueBtn{
    //需要判断是否已经登录
    if ([KMUserManager checkLoginWithPresent:YES]) {
        if (self.viewModel.alreadyQueue) {
            @weakify(self)
            [LBXAlertAction showAlertWithTitle:@"提示" msg:@"退出和过号都会影响你的信用值，退出每次扣0.5分，过号每次扣1分，扣分过多，可能会被暂时封号，请谨慎操作，你确认要退出排号吗？" buttonsStatement:@[@"确认退出", @"返回"] chooseBlock:^(NSInteger buttonIdx) {
                if (buttonIdx == 0) {
                    //若已经在排队 则退出排队
                    @strongify(self)
                    [self.viewModel.exitQueueCommand execute:nil];
                }
            }];
        }else {
            //是否可以排队
            @weakify(self)
            [[self.viewModel.userInfoCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                RACTuple *tuple   = x;
                NSArray *entrySet = tuple.first;
                KMMemberModel *member = [KMMemberModel modelWithJSON:entrySet.firstObject];
                if (member.creditscore > 0) {
                    @strongify(self)
                    if (self.viewModel.checkCanQueue) {
                        [self.viewModel.joinQueueCommand execute:nil];
                    }
                }else {
                    [UIAlertView showMessage:@"用户信用值为0不能排队"];
                }
            }];
        }
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSections];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfRowsInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height     = 0;
    SectionStyle style = [self.viewModel styleForSection:indexPath.section];
    switch (style) {
        case SectionStyleGroupInfo:
            height     = [KMGroupQueueDetailInfoCell cellHeightWithCombo:_viewModel.packageList.count != 0];
            break;
        case SectionStyleQueueInfo:
            height     = [KMGroupQueueDataCell cellHeight];
            break;
        case SectionStyleEvaluate:
            height     = UITableViewAutomaticDimension;//[KMGroupCommentCell cellHeight];
            break;
        default:
            break;
    }
    
    return height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    SectionStyle style    = [self.viewModel styleForSection:indexPath.section];
    
    if (style == SectionStyleGroupInfo) {
        cell              = [self cellForGroupInfo];
    }else if (style == SectionStyleQueueInfo){
        cell              = [self cellForQueueInfo:indexPath];
    }else if (style == SectionStyleEvaluate){
        cell              = [self cellForGroupComment:indexPath];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self headerHeightForScetionStyle:[self.viewModel styleForSection:section]];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headerForScetionStyle:[self.viewModel styleForSection:section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    SectionStyle style = [self.viewModel styleForSection:section];
    if (style == SectionStyleEvaluate) {
        return AdaptedHeight(90);
    }
    return AdaptedHeight(20);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    SectionStyle style              = [self.viewModel styleForSection:section];
    if (style == SectionStyleEvaluate) {
        UIView *foot                = [UIView new];
        foot.backgroundColor        = [UIColor whiteColor];
        foot.frame                  = CGRectMake(0, 0, KScreenWidth, AdaptedHeight(90));
        //查看用户全部评价
        UILabel *label              = [UILabel new];
        [label setText:@"查看用户全部评价"];
        label.font                  = kFont26;
        label.textColor             = kFontColorDarkGray;
        label.frame                 = CGRectMake(AdaptedWidth(24), 0, [label.text widthForFont:label.font], foot.height);
        
        //箭头
        UIImageView *arrow          = [UIImageView new];
        arrow.frame                 = CGRectMake(foot.width - AdaptedWidth(24) - 10, 0, 10, foot.height);
        arrow.contentMode           = UIViewContentModeRight;
        arrow.image                 = IMAGE_NAMED(@"youjt");
        
        //评论总数
        UILabel *numLbl             = [UILabel new];
        numLbl.font                 = kFont22;
        numLbl.textColor            = kFontColorGray;
        numLbl.textAlignment        = NSTextAlignmentRight;
        [numLbl setText:NSStringFormat(@"共%ld条",self.viewModel.commentInfo.total)];
        
        CGFloat labW                = [numLbl.text widthForFont:numLbl.font];
        numLbl.frame                = CGRectMake(arrow.left - labW - 5, 0, labW, foot.height);
        
        [foot addSubview:numLbl];
        [foot addSubview:arrow];
        [foot addSubview:label];
        
        //点击事件  跳转评论列表
        foot.userInteractionEnabled = YES;
        @weakify(self)
        [foot addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            @strongify(self)
            [self.pushCommentListVC sendNext:self.viewModel.commentInfo.commentInfo];
        }];
        return foot;
    }
    
    return [UIView new];
}


#pragma mark - Lazy
-(RACSubject *)pushEvaluateCommitVC{
    if (!_pushEvaluateCommitVC) {
        _pushEvaluateCommitVC = [RACSubject subject];
    }
    return _pushEvaluateCommitVC;
}
-(RACSubject *)pushCommentListVC{
    if (!_pushCommentListVC) {
        _pushCommentListVC    = [RACSubject subject];
    }
    return _pushCommentListVC;
}
-(RACSubject *)pushPackageSeleVC{
    if (!_pushPackageSeleVC) {
        _pushPackageSeleVC    = [RACSubject subject];
    }
    return _pushPackageSeleVC;
}

@end
