//
//  KMMyCollection.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMyCollection.h"
#import "KMMyCollectionViewModel.h"
#import "KMCollectionCell.h"
@interface KMMyCollection ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) KMMyCollectionViewModel *viewModel;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIButton * rightBtn;

@end

@implementation KMMyCollection

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count                    = self.viewModel.collectionList.count;
    return count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMCollectionCell.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    KMCollectionCell *cell             = [tableView dequeueReusableCellWithIdentifier:[KMCollectionCell cellID]];
    KMCollectionModel *data            = [self.viewModel.collectionList objectAtIndex:indexPath.row];
    [cell km_bindData:data];
    [cell km_setSeparatorLineInset:UIEdgeInsetsZero];
    @weakify(data)
    [[cell.QRSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(data)
        [KMUserManager pushQRCodeVCWithData:data];
    }];
    [[cell.mapSubject takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(data)
        CLLocationCoordinate2D coor;
        NSString *targetName           = @"";
        KMCollectionModel *model       = data;
        coor                           = CLLocationCoordinate2DMake(model.lat.floatValue, model.lng.floatValue);
        targetName                     = model.groupname;
        if (coor.latitude && coor.longitude) {
            [KMLocationManager showActionSheetWithMaps:[KMLocationManager getInstalledMapAppWithEndLocation:coor TargetName:targetName]];
        }
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KMCollectionModel *collection  = [self.viewModel.collectionList objectAtIndex:indexPath.row];
        @weakify(self, indexPath)
        [[self.viewModel.delCollection execute:collection] subscribeNext:^(id  _Nullable x) {
            @strongify(self, indexPath)
            RACTuple *tuple            = (RACTuple *)x;
            NSNumber * status          = tuple.third;
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
    KMCollectionModel *collection      = [self.viewModel.collectionList objectAtIndex:indexPath.row];
    [KMUserManager pushDetailWithGroupID:collection.groupid];
}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"我的收藏");
}
//-(UIButton *)set_rightButton{
//    return self.rightBtn;
//}
//-(void)right_button_event:(UIButton *)sender{
//    sender.selected                  = !sender.selected;
//    [self.tableView setEditing:sender.selected animated:YES];
//}
#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
-(void)km_requestData{
    [self.viewModel.requestCollection execute:nil];
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
        _tableView                     = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                  0,
                                                                  kNavHeight,
                                                                  KScreenWidth,
                                                                  KScreenHeight - kNavHeight)
                                                 style:UITableViewStyleGrouped];
        _tableView.delegate            = self;
        _tableView.dataSource          = self;
        _tableView.layoutMargins       = UIEdgeInsetsZero;
        [_tableView registerClass:[KMCollectionCell class] forCellReuseIdentifier:[KMCollectionCell cellID]];
        _tableView.tableFooterView     = [UIView new];
        _tableView.sectionFooterHeight = 0.01;
    }
    return _tableView;
}
-(KMMyCollectionViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                     = [[KMMyCollectionViewModel alloc]init];
    }
    return _viewModel;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn                      = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font      = kFont32;
        [_rightBtn setFrame:CGRectMake(0, 0, 60, 44)];
    }
    return _rightBtn;
}

@end
