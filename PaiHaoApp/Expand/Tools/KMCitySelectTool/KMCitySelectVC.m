//
//  KMCitySelectVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCitySelectVC.h"
#import "KMCitySelectTool.h"
#import "KMCityHeaderView.h"
#import "KMCitySelectTopCell.h"
#import "KMCitySearchView.h"
#define kHistoryCity  @"CitySelectHistoryCity"

@interface KMCitySelectVC ()<UITableViewDelegate, UITableViewDataSource, KMCitySearchViewDelegate, KMCityHeaderViewDelegate>
{
    NSInteger  _HeaderSectionTotal;           //头section的个数
}
@property (nonatomic, strong) UITableView * tableView;


/** 搜索框 当前城市 */
@property (nonatomic, strong) KMCityHeaderView * headerView;
/** 搜索视图 */
@property (nonatomic, strong) KMCitySearchView * searchView;

@property (nonatomic, strong) NSMutableArray * characterArr;

@property (nonatomic, copy) NSDictionary * sectionDic;
/** 区县 */
@property (nonatomic, strong) NSMutableArray * areaArrM;

/** 最近访问城市 */
@property (nonatomic, strong) NSMutableArray * historyCityArr;
/** 热门城市*/
@property (nonatomic, strong) NSArray *hotCityArray;
/** 当前城市 */
@property (nonatomic, copy) NSString * curCity;

@end

@implementation KMCitySelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _HeaderSectionTotal                    = 3;
    [self initHistory];
    NSString *locationCity                 = [NSUserDefaults stringForKey:kLocationCity];
    _curCity                               = locationCity;
    if (_curCity.length == 0) {
    _curCity                               = @"正在定位...";
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
#pragma mark - Private Method -
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initHistory{
    self.historyCityArr                    = [NSUserDefaults arcObjectForKey:kHistoryCity];
}
-(void)addHistory:(NSString *)cityName{
    //避免重复添加，先删除再添加
    [_historyCityArr removeObject:cityName];
    [_historyCityArr insertObject:cityName atIndex:0];
    if (_historyCityArr.count > 3) {
        [_historyCityArr removeLastObject];
    }
    [NSUserDefaults setArcObject:_historyCityArr forKey:kHistoryCity];
}

-(void)selectCity:(NSString *)cityName{
    self.headerView.cityName               = cityName;
    [self addHistory:cityName];
    [KMCitySelectTool didSelectCity:cityName];
    _didSelectCity ? _didSelectCity(cityName) : nil;
    [self dismiss];
}

-(void)areaWithCityName:(NSString *)cityName Select:(BOOL)select{
    if (select) {//获取该城市 所有区县
        @weakify(self)
        [KMCitySelectTool loadAreaData:cityName CallBack:^(NSArray *areaArr) {
            @strongify(self)
            [self.areaArrM addObjectsFromArray:areaArr];
            //添加一行cell
            [_tableView beginUpdates];
            [_characterArr insertObject:@"#" atIndex:0];
    _HeaderSectionTotal                    = 4;
            [_tableView insertSection:0 withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
        }];
    }else{
        if (self.areaArrM.count != 0) {
            //清空区县名称数组
            [self.areaArrM removeAllObjects];
            //删除一行cell
            [_tableView beginUpdates];
            [_characterArr removeObjectAtIndex:0];
    _HeaderSectionTotal                    = 3;
            [_tableView deleteSection:0 withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
        }
    }
}

#pragma mark - KMCityHeaderViewDelegate -
- (void)beginSearch{
    [_tableView scrollToTopAnimated:YES];
    [self.view addSubview:self.searchView];
}
- (void)endSearch{
    [_searchView removeFromSuperview];
    _searchView                            = nil;
}
- (void)searchWithKeyword:(NSString *)keyword{
   @weakify(self)
   [KMCitySelectTool searchCityData:keyword CallBack:^(NSArray *relustArr) {
        @strongify(self)
       if (relustArr.count) {
    self.searchView.backgroundColor        = [UIColor colorWithPatternImage:[[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.85]] imageByBlurLight]];
    self.searchView.reslutArr              = [NSMutableArray arrayWithArray:relustArr];
       }
   }];
}

#pragma mark - KMCitySearchViewDelegate -
-(void)citySearchViewDidSelectCity:(NSString *)cityName{
    [self selectCity:cityName];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.characterArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section < _HeaderSectionTotal ? 1 : [self.sectionDic[[self.characterArr objectAtIndex:section]] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < _HeaderSectionTotal) {
    NSArray *arr                           = @[];
        if (indexPath.section == _HeaderSectionTotal - 4) {
    arr                                    = self.areaArrM;
        }
        if (indexPath.section == _HeaderSectionTotal - 3) {
    NSString *locationCity                 = [NSUserDefaults stringForKey:kLocationCity];
    arr                                    = locationCity ? @[locationCity] : @[@"正在定位..."];
        }
        if (indexPath.section == _HeaderSectionTotal - 2) {
    arr                                    = self.historyCityArr;
        }
        if (indexPath.section == _HeaderSectionTotal - 1) {
    arr                                    = self.hotCityArray;
        }
        return [KMCitySelectTopCell cellHeightWithCityNameArr:arr];
    }
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section < _HeaderSectionTotal) {

    KMCitySelectTopCell *cell              = [tableView dequeueReusableCellWithIdentifier:[KMCitySelectTopCell cellID]];
        if (indexPath.section == _HeaderSectionTotal - 4) {
    cell.cityNameArray                     = self.areaArrM;
        }
        if (indexPath.section == _HeaderSectionTotal - 3) {
    NSString *locationCity                 = [NSUserDefaults stringForKey:kLocationCity];
    cell.cityNameArray                     = locationCity ? @[locationCity] : @[@"正在定位..."];
        }
        if (indexPath.section == _HeaderSectionTotal - 2) {
    cell.cityNameArray                     = self.historyCityArr;
        }
        if (indexPath.section == _HeaderSectionTotal - 1) {
    cell.cityNameArray                     = self.hotCityArray;
        }
        @weakify(self)
    cell.selectCity                        = ^(NSString *str) {
            @strongify(self)
            [self selectCity:str];
        };
        return cell;
    }else{
    UITableViewCell *cell                  = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell cellID] forIndexPath:indexPath];
    NSArray *currentArray                  = self.sectionDic[_characterArr[indexPath.section]];
        [cell setBackgroundColor:self.view.backgroundColor];
        [cell.contentView setBackgroundColor:self.view.backgroundColor];
        [cell.textLabel setBackgroundColor:self.view.backgroundColor];
    cell.textLabel.text                    = currentArray[indexPath.row];
    cell.textLabel.textColor               = kFontColorDarkGray;
    cell.textLabel.font                    = kFont30;
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.characterArr objectAtIndex:section];
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.characterArr;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header                         = [UIView new];
    [header setBackgroundColor:self.view.backgroundColor];
    UILabel *label                         = [UILabel new];
    [label setFrame:CGRectMake(AdaptedWidth(24), 0, KScreenWidth - AdaptedWidth(24 * 2), 40)];
    [label setFont:kFont30];
    [label setTextColor:kFontColorDarkGray];
    NSString *title                        = @"";
    NSInteger headerSection                = section;
    if (_HeaderSectionTotal == 4) {
    headerSection                          -= 1;
    }
    switch (headerSection) {
        case -1:
    title                                  = @"选择区县";
            break;
        case 0:
    title                                  = @"定位城市";
            break;
        case 1:
    title                                  = @"最近访问的城市";
            break;
        case 2:
    title                                  = @"热门城市";
            break;
        default:
    title                                  = [self.characterArr objectAtIndex:section];
            break;
    }

    [label setText:title];
    [header addSubview:label];
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell                  = [tableView cellForRowAtIndexPath:indexPath];
    _headerView.cityName                   = cell.textLabel.text;
    [self selectCity:cell.textLabel.text];
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"选择城市");
}
-(UIButton *)set_leftButton{
    UIButton *btn                          = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:IMAGE_NAMED(@"chaa") forState:UIControlStateNormal];
    return btn;
}
-(void)left_button_event:(UIButton *)sender{
    [self dismiss];
}
#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [_tableView setTableHeaderView: self.headerView];
}
-(void)km_bindEvent{
    @weakify(self)
    [KMCitySelectTool loadCityData:^(NSArray *characterArr, NSDictionary *sectionDic) {
        @strongify(self)
        [self.characterArr addObjectsFromArray:characterArr];
    self.sectionDic                        = sectionDic;
        DISPATCH_ON_MAIN_THREAD(^{
           [self.tableView reloadData];
        });
    }];
}
#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                             = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor             = self.view.backgroundColor;
    _tableView.delegate                    = self;
    _tableView.dataSource                  = self;
    _tableView.sectionIndexColor           = kMainThemeColor;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell cellID]];
        [_tableView registerClass:[KMCitySelectTopCell class] forCellReuseIdentifier:[KMCitySelectTopCell cellID]];
    }
    return _tableView;
}
-(KMCityHeaderView *)headerView{
    if (!_headerView) {
    _headerView                            = [[KMCityHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, AdaptedHeight(184))];
    _headerView.delegate                   = self;
    NSString *locationCity                 = [NSUserDefaults stringForKey:kLocationCity];
    NSString *currentCity                  = [NSUserDefaults stringForKey:kCurrentCity];
        [_headerView setCityName:currentCity ? currentCity : (locationCity ? locationCity : @"正在定位...")];
        @weakify(self)
    _headerView.areaSelect                 = ^(NSString *cityName, BOOL ret) {
            @strongify(self)
            [self areaWithCityName:cityName Select:ret];
        };
    }
    return _headerView;
}

-(KMCitySearchView *)searchView{
    if (!_searchView) {
    CGRect frame                           = [UIScreen mainScreen].bounds;
    _searchView                            = [[KMCitySearchView alloc]initWithFrame: CGRectMake(0, kNavHeight + self.headerView.height / 2.0, frame.size.width, frame.size.height - (kNavHeight + self.headerView.height / 2.0))];
    _searchView.backgroundColor            = [kFontColorDark colorWithAlphaComponent:0.7];
    _searchView.delegate                   = self;
    }
    return _searchView;
}

-(NSMutableArray *)characterArr{
    if (!_characterArr) {
    _characterArr                          = [NSMutableArray arrayWithObjects:@"已", @"最", @"热", nil];
    }
    return _characterArr;
}
-(NSArray *)hotCityArray{
    if (!_hotCityArray) {
    _hotCityArray                          = @[@"北京", @"上海", @"广州", @"深圳", @"天津", @"杭州", @"南京", @"重庆", @"武汉"];
    }
    return _hotCityArray;
}
-(NSMutableArray *)historyCityArr{
    if (!_historyCityArr) {
    _historyCityArr                        = [NSMutableArray array];
    }
    return _historyCityArr;
}
-(NSMutableArray *)areaArrM{
    if (!_areaArrM) {
    _areaArrM                              = [NSMutableArray array];
    }
    return _areaArrM;
}
@end
