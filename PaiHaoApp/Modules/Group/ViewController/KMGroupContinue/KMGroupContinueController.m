//
//  KMGroupContinueController.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupContinueController.h"

#import "KMGroupContinueVM.h"

#import "KMSegmentView.h"

#import "KMUserInfoCell.h"
#import "KMStartEndCell.h"
#import "KMSelectCell.h"

#import "KMSelectWeekVC.h"

#import "ActionSheetPicker.h"

@interface KMGroupContinueController ()<KMSegmentViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMGroupContinueVM * viewModel;

@property (nonatomic, strong) KMSegmentView * segment;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * commitBtn;

@end

@implementation KMGroupContinueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Push
-(void)pushSettingWeekVC{
    KMSelectWeekVC *vc             = [[KMSelectWeekVC alloc]init];
    vc.selectWeek                  = self.viewModel.weeks;
    @weakify(self)
    vc.action                      = ^(id object) {
        @strongify(self)
    KMWeek weeks                   = [object integerValue];
    self.viewModel.weeks           = weeks;
        [self.tableView reloadData];
    };
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - Private Method
-(void)showActionSheetDatePickerWithTimeStyle:(TimeStyle)style
                                     timeSlot:(KMTimeSlot)timeSlot
                                    dateOrder:(DateOrder)order {
    switch (_viewModel.continueStyle) {
        case ContinueStyleManual:
            [self manualShowDatePickerWithTimeStyle:style dateOrder:order];
            break;
        case ContinueStyleAuto:
            [self autoShowDatePickerWithTimeStyle:style timeSlot:timeSlot dateOrder:order];
            break;
        default:
            break;
    }
}
//最后弹出 Picker
-(void)showDatePickerWithTitle:(NSString *)title
                datePickerMode:(UIDatePickerMode)datePickerMode
                  selectedDate:(NSDate *)selectedDate
                   minimumDate:(NSDate *)minimumDate
                   maximumDate:(NSDate *)maximumDate
                   selectBlock:(Block_Obj)selectBlock{
    @weakify(self)
    ActionSheetDatePicker *picker  = [[ActionSheetDatePicker alloc]initWithTitle:title datePickerMode:datePickerMode selectedDate:selectedDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        @strongify(self)
        selectBlock ? selectBlock(selectedDate) : nil;
        [self.tableView reloadData];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        @strongify(self)
        [self.tableView reloadData];
    } origin:self.view];

    picker.locale                  = [[NSLocale alloc] initWithLocaleIdentifier:datePickerMode == UIDatePickerModeTime ? @"en_GB" : @"zh_CN"]; //@"zh_CN" //设置为中
    if (minimumDate) {
    picker.minimumDate             = minimumDate;
    }
    if (maximumDate) {
    picker.maximumDate             = maximumDate;
    }
    [picker showActionSheetPicker];
}
-(void)commit{
    if (![self.viewModel verifyData]) {
        return;
    }
    @weakify(self)
    if (self.viewModel.continueStyle == ContinueStyleManual) {
    NSString *day                  = [_viewModel.manualDay stringWithFormat:@"yyyy-MM-dd"];
    NSString *start                = [_viewModel.manualDateStart stringWithFormat:@"HH:mm"];
    NSString *end                  = [_viewModel.manualDateEnd stringWithFormat:@"HH:mm"];
    NSString *fullStart            = NSStringFormat(@"%@ %@",day, start);
    NSString *fullEnd              = NSStringFormat(@"%@ %@",day, end);
    RACTuple *tuple                = RACTuplePack(self.groupID, fullStart, fullEnd);

        [[_viewModel.manualCommit execute:tuple] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else if (self.viewModel.continueStyle == ContinueStyleAuto){
        [[_viewModel.autoCommit execute:_groupID] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - 手动续建
-(void)manualShowDatePickerWithTimeStyle:(TimeStyle)style dateOrder:(DateOrder)order{
    switch (style) {
        case TimeStyleDay:
            [self manualShowDayPicker];
            break;
        case TimeStyleTime:
            [self manualShowTimePickerWithDateOrder:order];
            break;
        default:
            break;
    }
}
#pragma mark 手动续建 选择日期
-(void)manualShowDayPicker{
    //手动 选择 日期
    @weakify(self)
    [self showDatePickerWithTitle:@"日期"
                   datePickerMode:UIDatePickerModeDate
                     selectedDate:[NSDate date]
                      minimumDate:[NSDate date]
                      maximumDate:[[NSDate date]
                                   dateByAddingWeeks:1]
                      selectBlock:^(id object) {
        @strongify(self)
    self.viewModel.manualDay       = object;
    }];
}
#pragma mark 手动续建 选择时间
-(void)manualShowTimePickerWithDateOrder:(DateOrder)order{
    switch (order) {
        case DateOrderSatrt:{
            @weakify(self)
            [self showDatePickerWithTitle:@"开始时间"
                           datePickerMode:UIDatePickerModeTime
                             selectedDate:self.viewModel.manualDateStart minimumDate:nil
                              maximumDate:nil
                              selectBlock:^(id object) {
                @strongify(self)
    self.viewModel.manualDateStart = object;
            }];
        }
            break;
        case DateOrderEnd:{
            @weakify(self)
            [self showDatePickerWithTitle:@"结束时间"
                           datePickerMode:UIDatePickerModeTime
                             selectedDate:self.viewModel.manualDateEnd
                              minimumDate:nil
                              maximumDate:nil
                              selectBlock:^(id object) {
                @strongify(self)
    self.viewModel.manualDateEnd   = object;
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 自动续建
-(void)autoShowDatePickerWithTimeStyle:(TimeStyle)style
                              timeSlot:(KMTimeSlot)timeSlot
                             dateOrder:(DateOrder)order{
    switch (style) {
        case TimeStyleDay:
            [self autoShowDayPickerWithDateOrder:order];
            break;
        case TimeStyleTime:
            self.viewModel.autoStyle == AutoStyleNormal ? [self autoNormalShowTimePickerWithDateOrder:order] : [self autoSectionShowTimePickerWithTimeSlot:timeSlot dateOrder:order];
            break;
        default:
            break;
    }

}

#pragma mark 自动续建 选择日期
-(void)autoShowDayPickerWithDateOrder:(DateOrder)order{
    switch (order) {
        case DateOrderSatrt:{
            @weakify(self)
            [self showDatePickerWithTitle:@"开始日期"
                           datePickerMode:UIDatePickerModeDate
                             selectedDate:self.viewModel.autoDayStart
                              minimumDate:nil//[NSDate date]
                              maximumDate:nil
                              selectBlock:^(id object) {
                @strongify(self)
                  self.viewModel.autoDayStart    = object;
            }];
        }
            break;
        case DateOrderEnd:{
            @weakify(self)
            [self showDatePickerWithTitle:@"结束日期"
                           datePickerMode:UIDatePickerModeDate
                             selectedDate:self.viewModel.autoDayEnd
                              minimumDate:_viewModel.autoDayStart
                              maximumDate:nil //[_viewModel.autoDayStart dateByAddingWeeks:1]
                              selectBlock:^(id object) {
                @strongify(self)
    self.viewModel.autoDayEnd      = object;
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark 自动续建 选择时间

-(void)autoNormalShowTimePickerWithDateOrder:(DateOrder)order{
    NSString *title                = @"";
    NSDate *selectedDate           = [NSDate date];
    Block_Obj selectBlock;
    @weakify(self)
    switch (order) {
        case DateOrderSatrt:{
    title                          = @"开始时间";
    selectedDate                   = self.viewModel.autoDateStart;
    selectBlock                    = ^(id obj){
                @strongify(self)
    self.viewModel.autoDateStart   = obj;
            };
        }
            break;
        case DateOrderEnd:{
    title                          = @"结束时间";
    selectedDate                   = self.viewModel.autoDateEnd;
    selectBlock                    = ^(id obj){
                @strongify(self)
    self.viewModel.autoDateEnd     = obj;
            };
        }
            break;
        default:
            break;
    }
    [self showDatePickerWithTitle:title
                   datePickerMode:UIDatePickerModeTime
                     selectedDate:selectedDate
                      minimumDate:nil
                      maximumDate:nil
                      selectBlock:^(id object) {
                          selectBlock ? selectBlock(object) : nil;
                      }];
}

-(void)autoSectionShowTimePickerWithTimeSlot:(KMTimeSlot)timeSlot
                                   dateOrder:(DateOrder)order{
    NSString *title                = @"";
    NSDate *selectedDate           = [NSDate date];
    Block_Obj selectBlock;
    @weakify(self)
    switch (order) {
        case DateOrderSatrt:{
    title                          = @"开始时间";
            switch (timeSlot) {
                case KMTimeSlotAM:
    selectedDate                   = self.viewModel.autoAMSatrt;
                    break;
                case KMTimeSlotPM:
    selectedDate                   = self.viewModel.autoPMSatrt;
                    break;
                case KMTimeSlotNight:
    selectedDate                   = self.viewModel.autoNightStart;
                    break;
                default:
                    break;
            }
    selectBlock                    = ^(id obj){
                @strongify(self)
                switch (timeSlot) {
                    case KMTimeSlotAM:
    self.viewModel.autoAMSatrt     = obj;
                        break;
                    case KMTimeSlotPM:
    self.viewModel.autoPMSatrt     = obj;
                        break;
                    case KMTimeSlotNight:
    self.viewModel.autoNightStart  = obj;
                        break;
                    default:
                        break;
                }
            };
        }
            break;
        case DateOrderEnd:{
    title                          = @"结束时间";
            switch (timeSlot) {
                case KMTimeSlotAM:
    selectedDate                   = self.viewModel.autoAMEnd;
                    break;
                case KMTimeSlotPM:
    selectedDate                   = self.viewModel.autoPMEnd;
                    break;
                case KMTimeSlotNight:
    selectedDate                   = self.viewModel.autoNightEnd;
                    break;
                default:
                    break;
            }
    selectBlock                    = ^(id obj){
                @strongify(self)
                switch (timeSlot) {
                    case KMTimeSlotAM:
    self.viewModel.autoAMEnd       = obj;
                        break;
                    case KMTimeSlotPM:
    self.viewModel.autoPMEnd       = obj;
                        break;
                    case KMTimeSlotNight:
    self.viewModel.autoNightEnd    = obj;
                        break;
                    default:
                        break;
                }
            };
        }
            break;
        default:
            break;
    }
    [self showDatePickerWithTitle:title
                   datePickerMode:UIDatePickerModeTime
                     selectedDate:selectedDate
                      minimumDate:nil
                      maximumDate:nil
                      selectBlock:^(id object) {
        selectBlock ? selectBlock(object) : nil;
    }];
}

#pragma mark - Cell
-(UITableViewCell *)manualDayCell{
    KMUserInfoCell *dayCell        = [self.tableView dequeueReusableCellWithIdentifier:[KMUserInfoCell cellID]];
    dayCell.leftTextLbl.text       = @"日期";
    dayCell.hideArrow              = NO;
    [dayCell.subTextLbl setText:[self.viewModel.manualDay stringWithFormat:@"yyyy-MM-dd"]];
    return dayCell;
}
-(UITableViewCell *)manualTimeCell{
    KMStartEndCell *tCell          = [self.tableView dequeueReusableCellWithIdentifier:[KMStartEndCell cellID]];
    tCell.timeSlot                 = KMTimeSlotNone;
    tCell.timeStyle                = TimeStyleTime;
    [tCell km_bindData:RACTuplePack(self.viewModel.manualDateStart, self.viewModel.manualDateEnd)];
    @weakify(self)
    tCell.startAction              = ^{
        @strongify(self)
        [self manualShowDatePickerWithTimeStyle:TimeStyleTime dateOrder:DateOrderSatrt];
    };
    tCell.endAction                = ^{
        @strongify(self)
        [self manualShowDatePickerWithTimeStyle:TimeStyleTime dateOrder:DateOrderEnd];
    };
    return tCell;
}

-(UITableViewCell *)autoDayCell{
    KMStartEndCell *dCell          = [self.tableView dequeueReusableCellWithIdentifier:[KMStartEndCell cellID]];
    dCell.timeSlot                 = KMTimeSlotNone;
    dCell.timeStyle                = TimeStyleDay;
    [dCell km_bindData:RACTuplePack(self.viewModel.autoDayStart, self.viewModel.autoDayEnd)];
    @weakify(self)
    dCell.startAction              = ^{
        @strongify(self)
        [self autoShowDatePickerWithTimeStyle:TimeStyleDay
                                     timeSlot:KMTimeSlotNone
                                    dateOrder:DateOrderSatrt];
    };
    dCell.endAction                = ^{
        @strongify(self)
        [self autoShowDatePickerWithTimeStyle:TimeStyleDay
                                     timeSlot:KMTimeSlotNone
                                    dateOrder:DateOrderEnd];
    };
    [dCell km_setSeparatorLineInset:UIEdgeInsetsZero];
    return dCell;
}

-(UITableViewCell *)autoWeekCell{
    KMUserInfoCell *wCell          = [self.tableView dequeueReusableCellWithIdentifier:[KMUserInfoCell cellID]];
    [wCell.leftTextLbl setText:@"设置"];
    __block NSString *weekText     = @"";
    @weakify(self)
    [@[@"一", @"二", @"三", @"四", @"五", @"六", @"日"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
    KMWeek selectW                 = 1 << idx;
        if (self.viewModel.weeks & selectW) {
    weekText                       = [weekText stringByAppendingString:[weekText containsString:@"星期"] ? NSStringFormat(@"、%@",obj) : NSStringFormat(@"星期%@",obj)];
        }
    }];
    if (weekText.length) {
       [wCell.subTextLbl setText:weekText];
    }else{
        [wCell.subTextLbl setText:@"请选择星期"];
    }
    [wCell setHideArrow:NO];
    return wCell;
}

-(UITableViewCell *)autoNormalSelectCell{
    KMSelectCell *sCell            = [self.tableView dequeueReusableCellWithIdentifier:[KMSelectCell cellID]];
    [sCell.textLbl setText:@"普通续建（适用于每天一个起止时段）"];
    [sCell km_bindData:[NSNumber numberWithBool:_viewModel.autoStyle == AutoStyleNormal]];
    [sCell km_setSeparatorLineInset:UIEdgeInsetsMake(0, KScreenWidth, 0, 0)];
    return sCell;
}
-(UITableViewCell *)autoNormalDateCell{
    KMStartEndCell *dCell          = [self.tableView dequeueReusableCellWithIdentifier:[KMStartEndCell cellID]];
    dCell.timeSlot                 = KMTimeSlotNone;
    dCell.timeStyle                = TimeStyleTime;
    [dCell km_bindData:RACTuplePack(self.viewModel.autoDateStart, self.viewModel.autoDateEnd)];
    @weakify(self)
    dCell.startAction              = ^{
        @strongify(self)
        [self autoShowDatePickerWithTimeStyle:TimeStyleTime
                                     timeSlot:KMTimeSlotNone
                                    dateOrder:DateOrderSatrt];
    };
    dCell.endAction                = ^{
        @strongify(self)
        [self autoShowDatePickerWithTimeStyle:TimeStyleTime
                                     timeSlot:KMTimeSlotNone
                                    dateOrder:DateOrderEnd];
    };
    return dCell;
}
-(UITableViewCell *)autoSectionSelectCell{
    KMSelectCell *sCell            = [self.tableView dequeueReusableCellWithIdentifier:[KMSelectCell cellID]];
    [sCell.textLbl setText:@"分段续建（适用于每天多个起止时段）"];
    [sCell km_bindData:[NSNumber numberWithBool:_viewModel.autoStyle == AutoStyleSection]];
    [sCell km_setSeparatorLineInset:UIEdgeInsetsMake(0, KScreenWidth, 0, 0)];
    return sCell;
}
-(UITableViewCell *)autoSectionDateCellWithIndexPath:(NSIndexPath *)indexPath{
    KMStartEndCell *dCell          = [self.tableView dequeueReusableCellWithIdentifier:[KMStartEndCell cellID]];
    dCell.timeSlot                 = indexPath.row;
    dCell.timeStyle                = TimeStyleTime;
    switch (indexPath.row) {
        case 1:{
            [dCell km_bindData:RACTuplePack(self.viewModel.autoAMSatrt, self.viewModel.autoAMEnd)];
        }
            break;
        case 2:{
            [dCell km_bindData:RACTuplePack(self.viewModel.autoPMSatrt, self.viewModel.autoPMEnd)];
        }
            break;
        case 3:{
            [dCell km_bindData:RACTuplePack(self.viewModel.autoNightStart, self.viewModel.autoNightEnd)];
        }
            break;
        default:
            break;
    }
    @weakify(self, indexPath)
    dCell.startAction              = ^{
        @strongify(self, indexPath)
        [self autoShowDatePickerWithTimeStyle:TimeStyleTime
                                     timeSlot:indexPath.row
                                    dateOrder:DateOrderSatrt];
    };
    dCell.endAction                = ^{
        @strongify(self, indexPath)
        [self autoShowDatePickerWithTimeStyle:TimeStyleTime
                                     timeSlot:indexPath.row
                                    dateOrder:DateOrderEnd];
    };
    [dCell km_setSeparatorLineInset:UIEdgeInsetsZero];
    return dCell;
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count                = 0;
    switch (self.viewModel.continueStyle) {
        case ContinueStyleManual:
    count                          = 2;
            break;
        case ContinueStyleAuto:
    count                          = 3;
            break;
        default:
            break;
    }
    return count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count                = 0;
    switch (self.viewModel.continueStyle) {
        case ContinueStyleManual:
    count                          = 1;
            break;
        case ContinueStyleAuto:{
            switch (section) {
                case 0:
    count                          = 2;
                    break;
                case 1:
    count                          = _viewModel.autoStyle == AutoStyleNormal ? 2 : 1;
                    break;
                case 2:
    count                          = _viewModel.autoStyle == AutoStyleSection ? 4 : 1;
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height                 = 0;
    switch (self.viewModel.continueStyle) {
        case ContinueStyleManual:
    height                         = indexPath.section == 0 ? [KMUserInfoCell cellHeight] : [KMStartEndCell cellHeight];
            break;
        case ContinueStyleAuto:{
            if (indexPath.section == 0) {
    height                         = indexPath.row == 0 ? [KMStartEndCell cellHeight] : [KMUserInfoCell cellHeight];
            }else {
    height                         = indexPath.row == 0 ? [KMSelectCell cellHeight] : [KMStartEndCell cellHeight];
            }
        }
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self km_configTableCellWithIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.viewModel.continueStyle) {
        case ContinueStyleManual:{
            if (indexPath.section == 0) {
                [self manualShowDatePickerWithTimeStyle:TimeStyleDay
                                              dateOrder:DateOrderNone];
            }
        }
            break;
        case ContinueStyleAuto:{
            if (indexPath.section != 0 && indexPath.row == 0) {
    _viewModel.autoStyle           = indexPath.section == 1 ? AutoStyleNormal : AutoStyleSection;
                    [tableView beginUpdates];
                    [tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
                    [tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
                    [tableView endUpdates];
            }else if (indexPath.section == 0 && indexPath.row ==1){
                [self pushSettingWeekVC];
            }

        }
            break;
        default:
            break;
    }
}

#pragma mark - KMSegmentViewDelegate
-(void)segmentViewDidClick:(NSInteger)index{
    self.viewModel.continueStyle   = index;
    [self.tableView reloadData];
}

#pragma mark - BaseViewControllerInterface
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"续建");
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.segment];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
}
-(void)km_requestData{
    [self.viewModel.autoInfoCommand execute:self.groupID];
    [self.viewModel.autoTimeInfoCommand execute:self.groupID];
}
-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        DISPATCH_ON_MAIN_THREAD(^{
            @strongify(self)
            [self.tableView reloadData];
        });
    }];
}
-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell          = nil;
    KMGroupContinueVM *vm          = self.viewModel;
    if (vm.continueStyle == ContinueStyleManual) {
    cell                           = indexPath.section == 0 ? [self manualDayCell] : [self manualTimeCell];
    }else if (vm.continueStyle == ContinueStyleAuto){
        if (indexPath.section == 0) {
    cell                           = indexPath.row == 0 ? [self autoDayCell] : [self autoWeekCell];
        }else if (indexPath.section == 1){
    cell                           = indexPath.row == 0 ? [self autoNormalSelectCell] : [self autoNormalDateCell];
        }else if (indexPath.section == 2){
    cell                           = indexPath.row == 0 ? [self autoSectionSelectCell] : [self autoSectionDateCellWithIndexPath:indexPath];
        }
    }
    return cell;
}
#pragma mark - Lazy
-(KMSegmentView *)segment{
    if (!_segment) {
    _segment                       = [[KMSegmentView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, 50)
                                                Titles:@[@"手动续建", @"自动续建"]
                                      VerticalLineShow:YES];
    _segment.delegate              = self;
    }
    return _segment;
}
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                     = [[UITableView alloc]initWithFrame:CGRectMake(0, self.segment.bottom, KScreenWidth, KScreenHeight - self.segment.bottom - AdaptedHeight(80) - self.commitBtn.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor     = [UIColor clearColor];
    _tableView.dataSource          = self;
    _tableView.delegate            = self;
    _tableView.layoutMargins       = UIEdgeInsetsZero;
        [_tableView registerNib:[KMUserInfoCell loadNib]
         forCellReuseIdentifier:[KMUserInfoCell cellID]];

        [_tableView registerClass:[KMStartEndCell class]
           forCellReuseIdentifier:[KMStartEndCell cellID]];

        [_tableView registerClass:[KMSelectCell class]
           forCellReuseIdentifier:[KMSelectCell cellID]];
    }
    return _tableView;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setFrame:CGRectMake(AdaptedWidth(55), KScreenHeight - AdaptedHeight(60 + 84), AdaptedWidth(640), AdaptedHeight(84))];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_commitBtn.titleLabel setFont:kFont32];
        [_commitBtn setBackgroundImage:[[UIImage imageWithColor:kMainThemeColor size:_commitBtn.size] imageByRoundCornerRadius:_commitBtn.height / 2.0] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
-(KMGroupContinueVM *)viewModel{
    if (!_viewModel) {
    _viewModel                     = [[KMGroupContinueVM alloc]init];
    }
    return _viewModel;
}
@end
