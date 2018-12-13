//
//  KMBusinessUpgradeVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBusinessUpgradeVC.h"
#import "KMBusinessUpgradeVM.h"
#import "KMNewGroupCell.h"
#import "KMUploadImageTool.h"
@interface KMBusinessUpgradePicCell : KMBaseTableViewCell

@property (nonatomic, strong) UILabel * leftLbl;

@property (nonatomic, strong) UIImageView * iconImg;

@end
@implementation KMBusinessUpgradePicCell
#pragma mark - BaseViewInterface -
-(void)km_addSubviews{
    _leftLbl                                          = [UILabel new];
    [_leftLbl setTextColor:kFontColorDarkGray];
    [_leftLbl setFont:kFont32];
    [self.contentView addSubview:_leftLbl];

    _iconImg                                          = [UIImageView new];
    [self.contentView addSubview:_iconImg];
}
-(void)km_setupSubviewsLayout{
    UIView *content                                   = self.contentView;
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content).offset(AdaptedWidth(24));
        make.top.bottom.mas_equalTo(content);
        make.height.mas_equalTo(AdaptedHeight(216)).priorityHigh();
    }];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(content).offset(AdaptedWidth(-295));
        make.width.mas_equalTo(AdaptedWidth(160));
        make.height.mas_equalTo(AdaptedHeight(160));
        make.centerY.mas_equalTo(content.mas_centerY);
    }];
    [_iconImg layoutIfNeeded];
    [_iconImg setRoundedCorners:UIRectCornerAllCorners radius:AdaptedWidth(8)];
}

-(void)km_bindData:(id)data{
    if ([data isKindOfClass:[RACTuple class]]) {
    RACTupleUnpack(NSString *leftText, NSString *pic) = data;
        [_leftLbl setText:leftText];
        [_iconImg setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(pic ? pic : @"")] placeholder:IMAGE_NAMED(@"yinyezhizhao")];
    }
}
@end



@interface KMBusinessUpgradeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
/** 提交按钮 */
@property (nonatomic, strong) UIButton * commitBtn;

@property (nonatomic, strong) KMBusinessUpgradeVM * viewModel;

@end

@implementation KMBusinessUpgradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Privae Method -
-(void)clickCommitBtn:(UIButton *)sender{
    if ([self.viewModel verifyData]) {
        @weakify(self)
        [[self.viewModel.updateCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"商户资质");
}

#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.leftTextArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.leftTextArr[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //左边标题
    NSString *leftText                                = _viewModel.leftTextArr[indexPath.section][indexPath.row];
    //右边
    NSString *rightValue                              = [_viewModel valueForIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 2) {
    KMBusinessUpgradePicCell *cell                    = [tableView dequeueReusableCellWithIdentifier:[KMBusinessUpgradePicCell cellID]];
        [cell km_bindData:RACTuplePack(leftText, rightValue)];
        return cell;
    }else{
    KMNewGroupCell *cell                              = [tableView dequeueReusableCellWithIdentifier:[KMNewGroupCell cellID]];
        //显示样式
    NewGroupCellStyle cellStyle                       = NewGroupCellStyleTextField;
        //占位文字
    NSString *placeHolder                             = _viewModel.placeHolderArr[indexPath.section][indexPath.row];

        [cell km_bindData:RACTuplePack(@(cellStyle), placeHolder, leftText, rightValue, @(NO), @"",@(UIKeyboardTypeDefault), @(NO))];
        @weakify(self, indexPath)
        [[cell.editSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
            @strongify(self, indexPath)
            [self.viewModel edit:x IndexPath:indexPath];
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        @weakify(self)
        [KMUploadImageTool uploadWithSuccess:^(UIImage *uploadImage, NSString *imageUrl) {
            @strongify(self)
    self.viewModel.certificatespicture                = imageUrl;
            [self.tableView reloadData];
        } Failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
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

#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                                        = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - AdaptedHeight(40 + 20) - self.commitBtn.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor                        = self.view.backgroundColor;
    _tableView.delegate                               = self;
    _tableView.dataSource                             = self;
        [_tableView registerClass:[KMNewGroupCell class] forCellReuseIdentifier:[KMNewGroupCell cellID]];
        [_tableView registerClass:[KMBusinessUpgradePicCell class] forCellReuseIdentifier:[KMBusinessUpgradePicCell cellID]];
    _tableView.estimatedRowHeight                     = 60;
    _tableView.rowHeight                              = UITableViewAutomaticDimension;
    }
    return _tableView;
}
-(KMBusinessUpgradeVM *)viewModel{
    if (!_viewModel) {
    _viewModel                                        = [[KMBusinessUpgradeVM alloc]init];
    }
    return _viewModel;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                                        = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn.titleLabel setFont:kFont32];
        [_commitBtn setFrame:CGRectMake(AdaptedWidth(55), KScreenHeight - AdaptedHeight(40 + 84 + 20), KScreenWidth - AdaptedWidth(55 + 55), AdaptedHeight(84))];
        [_commitBtn setBackgroundImage:[[[UIImage imageWithColor:kMainThemeColor] imageByResizeToSize:_commitBtn.size] imageByRoundCornerRadius:_commitBtn.height/2.0] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(clickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
@end
