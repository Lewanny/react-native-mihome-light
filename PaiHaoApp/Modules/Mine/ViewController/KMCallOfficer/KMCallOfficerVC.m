//
//  KMCallOfficerVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCallOfficerVC.h"
#import "KMWindowInfoCell.h"
#import "KMCallOfficerVM.h"
@interface KMCallerAddView : UIView

@property (nonatomic, strong) UIView * inputBG;

@property (nonatomic, strong) UILabel * callerLbl;

@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UILabel * passwordLbl;

@property (nonatomic, strong) UITextField * callerTF;

@property (nonatomic, strong) UITextField * nameTF;

@property (nonatomic, strong) UITextField * passwordTF;

@property (nonatomic, strong) UIButton * addBtn;

+(CGFloat)viewHeight;

@end

@implementation KMCallerAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self                       = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    _inputBG                   = [UIView new];
    _inputBG.backgroundColor   = [UIColor whiteColor];
    [self addSubview:_inputBG];

    _callerLbl                 = [UILabel new];
    _nameLbl                   = [UILabel new];
    _passwordLbl               = [UILabel new];

    @weakify(self)
    [@[_callerLbl, _nameLbl, _passwordLbl] enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        [label setFont:kFont32];
        [label setTextColor:kFontColorDarkGray];
        [label setText:@[@"呼叫员", @"姓名", @"密码"][idx]];
        [self.inputBG addSubview:label];
    }];

    _callerTF                  = [UITextField new];
    _nameTF                    = [UITextField new];
    _passwordTF                = [UITextField new];

    [@[_callerTF, _nameTF, _passwordTF] enumerateObjectsUsingBlock:^(UITextField *tf, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        [tf setFont:kFont28];
        [tf setTextColor:kFontColorGray];
        [self.inputBG addSubview:tf];
    }];

    _addBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [_addBtn.titleLabel setFont:kFont32];
    [self addSubview:_addBtn];

    [self setupLayout];

    UIView *topLine            = [UIView new];
    topLine.backgroundColor    = kFontColorLightGray;
    [_inputBG addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(_inputBG);
        make.height.mas_equalTo(0.5);
    }];
    UIView *bottomLine         = [UIView new];
    bottomLine.backgroundColor = kFontColorLightGray;
    [_inputBG addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(_inputBG);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)setupLayout{
    [_inputBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AdaptedHeight(20));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(AdaptedHeight(102 * 3));
    }];

    CGFloat labelW             = [_callerLbl.text widthForFont:_callerLbl.font] + 5;
    [@[_callerLbl, _nameLbl, _passwordLbl] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[_callerLbl, _nameLbl, _passwordLbl] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_inputBG).offset(AdaptedWidth(24));
        make.width.mas_equalTo(labelW);
    }];
    @weakify(self)
    [@[_callerLbl, _nameLbl] enumerateObjectsUsingBlock:^(UIView * aView, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
    UIView *line               = [UIView new];
    line.backgroundColor       = kFontColorLightGray;
        [self.inputBG addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.inputBG).offset(AdaptedWidth(24));
            make.top.mas_equalTo(aView.mas_bottom);
            make.right.mas_equalTo(self.inputBG);
            make.height.mas_equalTo(0.5);
        }];
    }];
    [@[_callerTF, _nameTF, _passwordTF] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[_callerTF, _nameTF, _passwordTF] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_callerLbl.mas_right);
        make.right.mas_equalTo(_inputBG);
    }];

    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptedWidth(160));
        make.height.mas_equalTo(AdaptedHeight(60));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self).offset(AdaptedHeight(-40));
    }];

    [_addBtn layoutIfNeeded];
    [_addBtn cornerRadius:AdaptedWidth(8) strokeSize:0.5 color:kMainThemeColor];
}

+(CGFloat)viewHeight{
    return AdaptedHeight(20 + 102 * 3 + 140);
}

@end


@interface KMCallOfficerVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMCallerAddView * header;

@property (nonatomic, strong) KMCallOfficerVM * viewModel;

@end

@implementation KMCallOfficerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method -
-(void)addCallerWithUserName:(NSString *)uName
                   LoginName:(NSString *)lName
                    LoginPwd:(NSString *)lPwd{
    if (uName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入呼叫员ID" Duration:1];
        return;
    }
    if (lName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入姓名" Duration:1];
        return;
    }
    if (lPwd.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码" Duration:1];
        return;
    }
    @weakify(self)
    [[self.viewModel.addCommand execute:RACTuplePack(uName, lName, lPwd)] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self km_requestData];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.callerArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMWindowInfoCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMWindowInfoCell *cell     = [tableView dequeueReusableCellWithIdentifier:[KMWindowInfoCell cellID]];
    KMCallerInfo *info         = [_viewModel.callerArr objectAtIndex:indexPath.row];
    NSAttributedString *cID    = [_viewModel callerIDAttrStrWithInfo:info];
    NSAttributedString *cName  = [_viewModel callerNameAttrStrWithInfo:info];
    NSAttributedString *cPwd   = [_viewModel callerPwdAttrStrWithInfo:info];
    [cell km_bindData:RACTuplePack(cID, cName, cPwd)];
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];
    @weakify(self, info)
    [[cell.deleSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(info)
        [LBXAlertAction showAlertWithTitle:@"提示" msg:NSStringFormat(@"确认删除呼叫员: %@ ?",info.loginName) buttonsStatement:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
            @strongify(self, info)
            if (buttonIdx == 1) {
    NSString * aId             = info.accountId;
    NSString * uId             = info.userId;
    RACTuple * t               = RACTuplePack(aId, uId);
                [[self.viewModel.deleCommand execute:t] subscribeNext:^(id  _Nullable x) {
                    @strongify(self)
                    [self km_requestData];
                }];
            }
        }];
    }];
    return cell;
}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"添加呼叫员");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}

-(void)km_requestData{
    [self.viewModel.listCommand execute:nil];
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
-(void)km_bindEvent{
    @weakify(self)
    [self.header.addBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [self addCallerWithUserName:self.header.nameTF.text
                          LoginName:self.header.callerTF.text
                           LoginPwd:self.header.passwordTF.text];
    }];
}
#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                 = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.layoutMargins   = UIEdgeInsetsZero;
    _tableView.tableHeaderView = self.header;
        [_tableView registerClass:[KMWindowInfoCell class]
           forCellReuseIdentifier:[KMWindowInfoCell cellID]];
    }
    return _tableView;
}
-(KMCallerAddView *)header{
    if (!_header) {
    _header                    = [[KMCallerAddView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [KMCallerAddView viewHeight])];
    }
    return _header;
}
-(KMCallOfficerVM *)viewModel{
    if (!_viewModel) {
    _viewModel                 = [[KMCallOfficerVM alloc]init];
    }
    return _viewModel;
}
@end
