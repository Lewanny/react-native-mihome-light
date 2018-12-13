//
//  KMApplyMerchantVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMApplyMerchantVC.h"
#import "KMApplyMerchantVM.h"
#import "KMNewGroupCell.h"
#import "KMInputInfoController.h"
#import "KMAddressPicker.h"
@interface KMApplyMerchantVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMApplyMerchantVM * viewModel;
/** 提交按钮 */
@property (nonatomic, strong) UIButton * commitBtn;

@end

@implementation KMApplyMerchantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Privae Method -
-(void)clickCommitBtn:(UIButton *)sender{
    if ([self.viewModel verifyData]) {
        @weakify(self)
        [[self.viewModel.applyCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"商户申请");
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
#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.leftTextArr.count;
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
    KMNewGroupCell *cell          = [tableView dequeueReusableCellWithIdentifier:[KMNewGroupCell cellID]];
    //显示样式
    NewGroupCellStyle cellStyle   = [_viewModel cellStyleWithIndexPath:indexPath];
    //占位文字
    NSString *placeHolder         = [_viewModel.placeHolderArr objectAtIndex:indexPath.row];
    //左边标题
    NSString *leftText            = [_viewModel.leftTextArr objectAtIndex:indexPath.row];
    //右边文字
    NSString *rightText           = [_viewModel rightTextWithIndexPath:indexPath];
    [cell km_bindData:RACTuplePack(@(cellStyle), placeHolder, leftText, rightText, @(NO), @"",@(UIKeyboardTypeDefault), @(NO))];
    @weakify(self, indexPath)
    [[cell.editSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self, indexPath)
        [self.viewModel edit:x IndexPath:indexPath];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        //选择省市区
    @weakify(self)
    [KMAddressPicker showWithCallBack:^(NSString *province, NSString *city, NSString *area) {
        @strongify(self)
    self.viewModel.province       = province;
    self.viewModel.city           = city;
    self.viewModel.area           = area;
            [self.tableView reloadData];
    }];
    }else if (indexPath.row == 5){
        //填写商家简介
        //占位文字
    NSString *placeHolder         = [_viewModel.placeHolderArr objectAtIndex:indexPath.row];
        //左边标题
    NSString *leftText            = [_viewModel.leftTextArr objectAtIndex:indexPath.row];
    KMInputInfoController *input  = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMInputUserInfoIdentifier);
    input.type                    = InputInfoTypeCompele;
    input.titleStr                = leftText;
    input.placeholder             = placeHolder;
    input.needChangeText          = _viewModel.synopsis;
    input.keyboardType            = UIKeyboardTypeDefault;
        @weakify(self)
    input.compele                 = ^(NSString *text) {
            @strongify(self)
    self.viewModel.synopsis       = text;
            [self.tableView reloadData];
        };
        [self.navigationController cyl_pushViewController:input animated:YES];
    }
}

#pragma mark - Lazy -
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - AdaptedHeight(40 + 20) - self.commitBtn.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor    = self.view.backgroundColor;
    _tableView.delegate           = self;
    _tableView.dataSource         = self;
        [_tableView registerClass:[KMNewGroupCell class] forCellReuseIdentifier:[KMNewGroupCell cellID]];
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight          = UITableViewAutomaticDimension;
    }
    return _tableView;
}
-(KMApplyMerchantVM *)viewModel{
    if (!_viewModel) {
    _viewModel                    = [[KMApplyMerchantVM alloc]init];
    }
    return _viewModel;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
    _commitBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
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
