//
//  KMGroupSearchVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupSearchVC.h"
#import "KMCategoryGroupController.h"
#import "KMSearchResultVC.h"

#import "KMGroupSearchVM.h"

#import "KMSearchHistoryCell.h"
#import "KMSearchCategoryCell.h"
@interface KMGroupSearchVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIView * _searchBG;
}
/** 搜索框 */
@property (nonatomic, strong) UITextField * searchTF;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton * searchBtn;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMGroupSearchVM * viewModel;

@end

@implementation KMGroupSearchVC
#pragma mark - Lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewModel.historyArr = [NSMutableArray arrayWithArray:[[[_searchTF loadHistroy] reverseObjectEnumerator] allObjects]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchTF resignFirstResponder];
}

#pragma mark - Push
-(void)pushCategoryVCIndex:(NSInteger)index{
    NSArray *arr                     = [KMTool getCategoryType];
    KMMerchantTypeModel *model       = [arr objectAtIndex:index];
    KMCategoryGroupController *vc    = [[KMCategoryGroupController alloc]init];
    vc.categoryID                    = model.ID;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

-(void)pushResultVCWithKeyword:(NSString *)keyword{
    KMSearchResultVC *vc             = [[KMSearchResultVC alloc] init];
    vc.keyword                       = keyword ? keyword : @"";
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - Private Method
-(void)createSearchView{
    //背景
    _searchBG                        = [UIView new];
    _searchBG.frame                  = CGRectMake(0, kNavHeight, KScreenWidth, AdaptedHeight(96));
    _searchBG.backgroundColor        = [UIColor whiteColor];
    [self.view addSubview:_searchBG];
    //搜索框
    _searchTF                        = [UITextField new];
    _searchTF.backgroundColor        = [UIColor whiteColor];
    _searchTF.font                   = kFont24;
    _searchTF.textColor              = kFontColorDarkGray;
    _searchTF.textAlignment          = NSTextAlignmentCenter;
    _searchTF.identify               = @"KMGroupSearch";
    _searchTF.delegate               = self;
    _searchTF.returnKeyType          = UIReturnKeySearch;
    _searchTF.clearButtonMode        = UITextFieldViewModeWhileEditing;
    _searchTF.borderStyle            = UITextBorderStyleRoundedRect;
    [_searchBG addSubview:_searchTF];

    NSTextAttachment *attachment     = [[NSTextAttachment alloc]init];
    attachment.image                 = IMAGE_NAMED(@"sousuo");
    attachment.bounds                = CGRectMake(0, 0, AdaptedWidth(23), AdaptedHeight(23));
    NSAttributedString *attr         = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *attrM = [NSMutableAttributedString new];
    [attrM appendAttributedString:attr];
    [attrM appendString:@"  请输入关键字或队列名称/ID"];
    attrM.font                       = kFont24;
    attrM.color                      = kFontColorGray;
    [_searchTF setAttributedPlaceholder:attrM];
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptedWidth(632));
        make.height.mas_equalTo(AdaptedHeight(56));
        make.left.mas_equalTo(_searchBG).offset(AdaptedWidth(24));
        make.centerY.mas_equalTo(_searchBG.mas_centerY);
    }];
    //搜索按钮
    _searchBtn                       = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn.titleLabel setFont:kFont24];
    [_searchBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [_searchBG addSubview:_searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(_searchBG);
        make.left.mas_equalTo(_searchTF.mas_right);
    }];
}

//行业分类
-(UITableViewCell *)categoryCell{
    KMSearchCategoryCell *cCell = [self.tableView dequeueReusableCellWithIdentifier:[KMSearchCategoryCell cellID]];
    @weakify(self)
    [[cCell.clickSubject takeUntil:cCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushCategoryVCIndex:[x integerValue]];
    }];
    return cCell;
}
//搜索历史
-(UITableViewCell *)searchHistoryCellWithIndexPath:(NSIndexPath *)indexPath{
    KMSearchHistoryCell *hCell       = [self.tableView dequeueReusableCellWithIdentifier:[KMSearchHistoryCell cellID]];
    NSString *searchStr              = [self.viewModel.historyArr objectAtIndex:indexPath.row];
    [hCell km_bindData:searchStr];
    [hCell km_setSeparatorLineInset:UIEdgeInsetsZero];
    @weakify(self)
    [[hCell.deleSubject takeUntil:hCell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        for (NSString *str in self.viewModel.historyArr) {
            if ([str isEqualToString:searchStr]) {
                [self.viewModel.historyArr removeObject:str];
                [self.viewModel.reloadSubject sendNext:nil];
                break;
            }
        }
    }];
    return hCell;
}

-(void)clearHistory{
    [_searchTF clearHistory];
    self.viewModel.historyArr        = [NSMutableArray array];
    [self.tableView reloadData];
}

-(void)search{
    [_searchTF synchronize];
    _viewModel.historyArr            = [NSMutableArray arrayWithArray:[[[_searchTF loadHistroy] reverseObjectEnumerator] allObjects]];
    [_tableView reloadData];
    [self pushResultVCWithKeyword:_searchTF.text];
}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"搜索");
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count                  = 1;
    if (_viewModel.historyArr.count) {
    count                            = 2;
    }
    return count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count                  = 0;
    switch (section) {
        case 0:
    count                            = 1;
            break;
        case 1:
    count                            = _viewModel.historyArr.count;
            break;
        default:
            break;
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height                   = 0;
    switch (indexPath.section) {
        case 0:
    height                           = [KMSearchCategoryCell cellHeight];
            break;
        case 1:
    height                           = [KMSearchHistoryCell cellHeight];
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell            = nil;
    if (indexPath.section == 0){
    cell                             = [self categoryCell];
    }else if (indexPath.section == 1){
    cell                             = [self searchHistoryCellWithIndexPath:indexPath];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return AdaptedHeight(80);
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header                   = [UIView new];
    if (section == 1) {
    UILabel *label                   = [UILabel new];
        [label setText:@"搜索历史"];
        [label setTextColor:kFontColorDarkGray];
        [label setFont:kFont36];
        [label setFrame:CGRectMake(AdaptedWidth(24), 0, KScreenWidth - AdaptedWidth(24), AdaptedHeight(80))];
        [header addSubview:label];
    }
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height                   = 0.01;
    if (section == 1) {
    height                           = AdaptedHeight(50);
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot                     = [UIView new];
    if (section == 1) {
    UIButton *btn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
        [btn setTitleColor:kFontColorGray forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont28];
        [btn setFrame:CGRectMake(0, 0, KScreenWidth, AdaptedHeight(50))];
        [btn setBackgroundColor:[UIColor whiteColor]];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self clearHistory];
        }];
        [foot addSubview:btn];
    }
    return foot;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
    NSString *str                    = [self.viewModel.historyArr objectAtIndex:indexPath.row];
    _searchTF.text                   = str;
        [self search];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    return YES;
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self createSearchView];
    [self.view addSubview:self.tableView];
}

-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - Lazy

-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                       = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchBG.bottom, KScreenWidth, KScreenHeight - _searchBG.bottom) style:UITableViewStyleGrouped];
    _tableView.backgroundColor       = [UIColor clearColor];
    _tableView.delegate              = self;
    _tableView.dataSource            = self;
    _tableView.estimatedRowHeight    = 100.0;
        [_tableView registerClass:[KMSearchCategoryCell class] forCellReuseIdentifier:[KMSearchCategoryCell cellID]];
        [_tableView registerClass:[KMSearchHistoryCell class] forCellReuseIdentifier:[KMSearchHistoryCell cellID]];
    }
    return _tableView;
}

-(KMGroupSearchVM *)viewModel{
    if (!_viewModel) {
    _viewModel                       = [[KMGroupSearchVM alloc]init];
    }
    return _viewModel;
}
@end
