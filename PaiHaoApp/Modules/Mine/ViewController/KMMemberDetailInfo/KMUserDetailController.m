//
//  KMUserDetailController.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/27.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserDetailController.h"
#import "KMUserDetailViewModel.h"
#import "KMUserInfoHeadCell.h"
#import "KMUserInfoCell.h"

#import "KMInputInfoController.h"
#import "KMUploadImageTool.h"
@interface KMUserDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMUserDetailViewModel *viewModel;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private Method
-(UITableViewCell *)configCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell             = nil;
    UITableView *tableView            = self.tableView;
    if (indexPath.row == 1) {
        KMUserInfoHeadCell *headCell  = [tableView dequeueReusableCellWithIdentifier:[KMUserInfoHeadCell cellID]];
        headCell.leftTextLbl.text     = self.viewModel.leftTextArr[indexPath.row];
        headCell.hideArrow            = NO;
        [headCell km_bindData:self.viewModel.userDetail.headportrait];
        cell                          = headCell;
    }else{
        KMUserInfoCell *infoCell      = [tableView dequeueReusableCellWithIdentifier:[KMUserInfoCell cellID]];
        infoCell.leftTextLbl.text     = self.viewModel.leftTextArr[indexPath.row];
        infoCell.hideArrow            = NO;
        cell                          = infoCell;
        
        NSString *placeholder         = @"暂无";
        NSString *text                = [self.viewModel needCompeleTextWithIndexPath:indexPath];
        infoCell.subTextLbl.text      = text.length ? text : placeholder;
    
    }
    return cell;
}
#pragma mark - TableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.leftTextArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return AdaptedHeight(144);
    }
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self configCellWithIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //数据还没请求下来 直接返回
    if (!self.viewModel.userDetail) {
        return;
    }
    NSString *leftText                = [self.viewModel.leftTextArr objectAtIndex:indexPath.row];
    NSArray <NSString *> *notChange   = @[@"微信号"];
    if ([notChange containsObject:leftText]) {
        //不做修改
        return;
    }
    
    if ([leftText isEqualToString:@"头像"]) {
        //选择头像
        @weakify(self)
        [KMUploadImageTool uploadWithSuccess:^(UIImage *uploadImage, NSString *imageUrl) {
            @strongify(self)
            [self.viewModel.editHeadPortrait execute:imageUrl];
        } Failure:^(NSError *error) {
            
        }];
    }else {
        NSString *titleStr            = [self.viewModel.titles objectAtIndex:indexPath.row];
        
        KMInputInfoController *input  = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMInputUserInfoIdentifier);
        input.type                    = InputInfoTypeChange;
        input.titleStr                = titleStr;
        input.placeholder             = titleStr;
        input.needChangeText          = [self.viewModel needCompeleTextWithIndexPath:indexPath];
        input.keyboardType            = [self.viewModel keyboardTypeWithIndexPath:indexPath];
        @weakify(self, indexPath, input)
        input.compele                 = ^(NSString *text) {
            @strongify(self, indexPath, input)
            [self.viewModel compeleText:text IndexPath:indexPath CallBack:^{
                [SVProgressHUD showSuccessWithStatus:@"修改成功" Duration:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.viewModel.reloadSubject sendNext:nil];
                    [input.navigationController popViewControllerAnimated:YES];
                });
            }];
        };
        [self.navigationController pushViewController:input animated:YES];
    }
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"用户资料");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}

-(void)km_requestData{
    [self.viewModel.userDetailCommand execute:nil];
}

-(void)km_bindViewModel{
    @weakify(self)
    [self.viewModel.reloadSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - Lazy
-(KMUserDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                    = [[KMUserDetailViewModel alloc]init];
    }
    return _viewModel;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate           = self;
        _tableView.dataSource         = self;
        [_tableView registerNib:[KMUserInfoHeadCell loadNib] forCellReuseIdentifier:[KMUserInfoHeadCell cellID]];
        [_tableView registerNib:[KMUserInfoCell loadNib] forCellReuseIdentifier:[KMUserInfoCell cellID]];
        _tableView.estimatedRowHeight = 44.0;
    }
    return _tableView;
}
@end
