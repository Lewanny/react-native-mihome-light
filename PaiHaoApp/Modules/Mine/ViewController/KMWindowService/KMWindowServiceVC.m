//
//  KMWindowServiceVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMWindowServiceVC.h"
#import "KMWindowServiceVM.h"

#import "KMWindowInfoCell.h"

@interface KMWindowAddView : UIView

@property (nonatomic, strong) UIView * inputBG;

@property (nonatomic, strong) UILabel * nameLbl;

@property (nonatomic, strong) UILabel * infoLbl;

@property (nonatomic, strong) UITextField * nameTF;

@property (nonatomic, strong) UITextField * infoTF;

@property (nonatomic, strong) UIButton * addBtn;

+(CGFloat)viewHeight;

@end

@implementation KMWindowAddView

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

    _nameLbl                   = [UILabel new];
    [_nameLbl setFont:kFont32];
    [_nameLbl setTextColor:kFontColorDarkGray];
    [_nameLbl setText:@"窗口名称"];
    [_inputBG addSubview:_nameLbl];

    _infoLbl                   = [UILabel new];
    [_infoLbl setFont:kFont32];
    [_infoLbl setTextColor:kFontColorDarkGray];
    [_infoLbl setText:@"窗口说明"];
    [_inputBG addSubview:_infoLbl];

    _nameTF                    = [UITextField new];
    [_nameTF setFont:kFont28];
    [_nameTF setTextColor:kFontColorGray];
    [_inputBG addSubview:_nameTF];

    _infoTF                    = [UITextField new];
    [_infoTF setFont:kFont28];
    [_infoTF setTextColor:kFontColorGray];
    [_inputBG addSubview:_infoTF];

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

    UIView *midLine            = [UIView new];
    midLine.backgroundColor    = kFontColorLightGray;
    [_inputBG addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_inputBG);
        make.left.mas_equalTo(_inputBG).offset(AdaptedWidth(24));
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(_inputBG.mas_centerY);
    }];
}

-(void)setupLayout{
    [_inputBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AdaptedHeight(20));
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(AdaptedHeight(102 * 2));
    }];

    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_inputBG).offset(AdaptedWidth(24));
        make.width.mas_equalTo([_nameLbl.text widthForFont:_nameLbl.font] + 5);
        make.top.mas_equalTo(_inputBG);
        make.height.mas_equalTo(AdaptedHeight(102));
    }];

    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_inputBG).offset(AdaptedWidth(24));
        make.width.mas_equalTo([_infoLbl.text widthForFont:_infoLbl.font] + 5);
        make.bottom.mas_equalTo(_inputBG);
        make.height.mas_equalTo(AdaptedHeight(102));
    }];

    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLbl.mas_top);
        make.height.mas_equalTo(_nameLbl.mas_height);
        make.right.mas_equalTo(_inputBG);
        make.left.mas_equalTo(_nameLbl.mas_right);
    }];

    [_infoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_infoLbl.mas_top);
        make.height.mas_equalTo(_infoLbl.mas_height);
        make.right.mas_equalTo(_inputBG);
        make.left.mas_equalTo(_infoLbl.mas_right);
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
    return AdaptedHeight(20 + 102 + 102 + 140);
}

@end


@interface KMWindowServiceVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMWindowServiceVM * viewModel;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMWindowAddView * header;

@end

@implementation KMWindowServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method -
-(void)addWindowWithName:(NSString *)winName Info:(NSString *)winInfo{
    if (winName.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入窗口名称" Duration:1];
        return;
    }
    if (winInfo.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入窗口说明" Duration:1];
        return;
    }
    @weakify(self)
    [[self.viewModel.addCommand execute:RACTuplePack(winName, winInfo)] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self km_requestData];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.winArr.count;
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
    KMWindowInfo *info         = [_viewModel.winArr objectAtIndex:indexPath.row];
    NSAttributedString *wName  = [_viewModel windowNameAttrStrWithInfo:info];
    NSAttributedString *wInfo  = [_viewModel windowInfoAttrStrWithInfo:info];
    NSAttributedString *wTime  = [_viewModel windowTimeAttrStrWithInfo:info];
    [cell km_bindData:RACTuplePack(wName, wInfo, wTime)];
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];
    @weakify(self, info)
    [[cell.deleSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(info)
        [LBXAlertAction showAlertWithTitle:@"提示" msg:NSStringFormat(@"确认删除窗口: %@ ?",info.windowName) buttonsStatement:@[@"取消", @"确认"] chooseBlock:^(NSInteger buttonIdx) {
            @strongify(self, info)
            if (buttonIdx == 1) {
                [[self.viewModel.deleCommand execute:info.ID] subscribeNext:^(id  _Nullable x) {
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
    return KMBaseNavTitle(@"服务窗口");
}

#pragma mark - BaseViewControllerInterface
-(void)km_requestData{
    [self.viewModel.listCommand execute:nil];
}

-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
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
        [self addWindowWithName:self.header.nameTF.text Info:self.header.infoTF.text];
    }];
}
#pragma mark - Lazy -
-(KMWindowServiceVM *)viewModel{
    if (!_viewModel) {
    _viewModel                 = [[KMWindowServiceVM alloc]init];
    }
    return _viewModel;
}
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
-(KMWindowAddView *)header{
    if (!_header) {
    _header                    = [[KMWindowAddView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [KMWindowAddView viewHeight])];
    }
    return _header;
}
@end
