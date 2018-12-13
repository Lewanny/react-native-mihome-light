//
//  KMHistoryQueue.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMHistoryQueue.h"
#import "KMHistoryQueueViewModel.h"
#import "KMHistoryQueueCell.h"

#import "KMEvaluateCommitVC.h"
#import "KMGroupQueueDetail.h"
@interface KMHistoryQueue ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMHistoryQueueViewModel * viewModel;

@property (nonatomic, strong) UIButton * rightBtn;

@end

@implementation KMHistoryQueue

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Push -
-(void)pushEvaluateVCWithQueueID:(NSString *)queueID{
    KMEvaluateCommitVC *vc           = [[KMEvaluateCommitVC alloc]init];
    vc.queueID                       = queueID;
    @weakify(self)
    [[vc.refreshSubject takeUntil:vc.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self km_requestData];
    }];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count                  = self.viewModel.historyList.count;
    return count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMHistoryQueueCell.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMHistoryQueueCell *cell         = [tableView dequeueReusableCellWithIdentifier:[KMHistoryQueueCell cellID]];
    KMHistoryQueueModel *model       = [self.viewModel.historyList objectAtIndex:indexPath.row];
    @weakify(model)
    [[cell.QRSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(model)
        [KMUserManager pushQRCodeVCWithData:model];
    }];
    @weakify(self)
    [[cell.evaluateSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(model, self)
        [self pushEvaluateVCWithQueueID:model.queueId];
    }];
    [cell km_bindData:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KMHistoryQueueModel *history = [self.viewModel.historyList objectAtIndex:indexPath.row];
        @weakify(self, indexPath)
        [[self.viewModel.deleHistory execute:history] subscribeNext:^(id  _Nullable x) {
            @strongify(self, indexPath)
            RACTuple *tuple          = (RACTuple *)x;
            NSNumber * status        = tuple.third;
            if (status.integerValue == 0) {
               [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationTop];
            }
        }];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KMHistoryQueueModel *history = [self.viewModel.historyList objectAtIndex:indexPath.row];
    KMGroupQueueDetail *vc = [[KMGroupQueueDetail alloc]init];
    vc.groupID = history.groupId;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"历史排队");
}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
-(void)km_requestData{
    [self.viewModel.requestHistory execute:nil];
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
        _tableView                   = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                 0,
                                                                 kNavHeight,
                                                                 KScreenWidth,
                                                                 KScreenHeight - kNavHeight)
                                                 style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate          = self;
        _tableView.dataSource        = self;
        [_tableView registerClass:[KMHistoryQueueCell class] forCellReuseIdentifier:[KMHistoryQueueCell cellID]];
    }
    return _tableView;
}

-(KMHistoryQueueViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                   = [[KMHistoryQueueViewModel alloc]init];
    }
    return _viewModel;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font    = kFont32;
        [_rightBtn setFrame:CGRectMake(0, 0, 60, 44)];
    }
    return _rightBtn;
}
@end
