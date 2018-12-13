//
//  KMNewGroupController.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMNewGroupController.h"
#import "KMNewGroupViewModel.h"

#import "KMNewGroupCell.h"



@interface KMNewGroupController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMNewGroupViewModel * viewModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView * footView;

@end

@implementation KMNewGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method
-(UITableViewCell *)configCellWithIndexPath:(NSIndexPath *)indexPath{
    KMNewGroupCell *cell          = [self.tableView dequeueReusableCellWithIdentifier:[KMNewGroupCell cellID]];

    NewGroupCellStyle style       = [_viewModel cellStyleWithIndexPath:indexPath];
    NSString *placeHolder         = [_viewModel.placeHolderArr objectAtIndex:indexPath.row];
    NSString *leftText            = [_viewModel.leftTextArr objectAtIndex:indexPath.row];
    NSString *rightText           = [_viewModel rightTextWithIndexPath:indexPath];
    BOOL switchOn                 = [_viewModel switchValueWithIndexPath:indexPath];
    NSString *photo               = [_viewModel isNewBuiltGroup] ? _viewModel.groupNew.photo : _viewModel.origin.photo;
    UIKeyboardType keyboardType   = [_viewModel keyboardTypeWithIndexPath:indexPath];
    BOOL rightTapEnable           = indexPath.row == 5;


    [cell km_bindData:RACTuplePack(@(style), placeHolder, leftText, rightText, @(switchOn), photo, @(keyboardType), @(rightTapEnable))];
    @weakify(self, indexPath)
    [[cell.editSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self, indexPath)
        [self.viewModel editWithData:x IndexPath:indexPath];
    }];
    return cell;
}

-(void)clickCommitBtn:(UIButton *)sender{
    //新建队列
    if ([_viewModel isNewBuiltGroup]) {
        if ([_viewModel verifyNewGroupParams]) {//验证数据
            @weakify(self)
            [[self.viewModel.addNewCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else{
    //编辑队列
        if ([_viewModel verifyEditGroupParams]) {//验证数据
            @weakify(self)
            [[self.viewModel.editGroupCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.leftTextArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AdaptedHeight(64 + 84 + 64);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self configCellWithIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel didSelectIndexPath:indexPath];
}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(_titleStr);
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}

-(void)km_requestData{
    if (![self.viewModel isNewBuiltGroup]) {
        [self.viewModel.infoCommand execute:self.groupID];
    }
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

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
        [_tableView registerClass:[KMNewGroupCell class] forCellReuseIdentifier:[KMNewGroupCell cellID]];
    _tableView.delegate           = self;
    _tableView.dataSource         = self;
    _tableView.rowHeight          = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 60.0;
    }
    return _tableView;
}
-(UIView *)footView{
    if (!_footView) {
    _footView                     = [UIView new];
    UIButton *btn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"提  交" forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont32];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kMainThemeColor] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(AdaptedWidth(55), AdaptedHeight(64), AdaptedWidth(640), AdaptedHeight(84))];
    btn.layer.cornerRadius        = btn.height / 2.0;
    btn.layer.masksToBounds       = YES;
        [btn addTarget:self action:@selector(clickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
    }
    return _footView;
}
-(KMNewGroupViewModel *)viewModel{
    if (!_viewModel) {
    _viewModel                    = [[KMNewGroupViewModel alloc]initWithGroupID:self.groupID];
    }
    return _viewModel;
}
@end
