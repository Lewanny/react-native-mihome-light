//
//  KMPackageSelectVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/11.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMPackageSelectVC.h"
#import "KMSegmentView.h"
#import "KMPackageInfoCell.h"
#import "KMPackageItem.h"
@interface KMPackageSelectVC ()<UITableViewDelegate, UITableViewDataSource> //KMSegmentViewDelegate

//@property (nonatomic, strong) KMSegmentView * segment;

@property (nonatomic, strong) UIButton * queuqBtn;

@property (nonatomic, strong) UILabel * tipsLabel;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMPackageSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Privath Method -
//提交套餐排队
-(void)commitQueue{
    if (!_selectedID.length) {
        [SVProgressHUD showInfoWithStatus:@"请选择一个套餐" Duration:1];
        return;
    }
    //需要判断是否登录
    if ([KMUserManager checkLoginWithPresent:YES]) {
        @weakify(self)
        //判断套餐中号群是否有的已经排队，倘若有不允许再排套餐
        [[self.viewModel.checkPackageCommand execute:self.selectedID] subscribeNext:^(id  _Nullable x) {
            RACTuple *t = x;
            NSNumber * status = t.fourth;
            if (status.integerValue == 0) {
                //0 已排队 其他未排
                [SVProgressHUD showErrorWithStatus:@"套餐中号群有的已经排队，不允许再排套餐" Duration:1];
            }else{
                @strongify(self)
                [[self.viewModel.packageQueueCommand execute:self.selectedID] subscribeNext:^(id  _Nullable x) {
                    @strongify(self)
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.packageList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [KMPackageInfoCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMPackageInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[KMPackageInfoCell cellID]];
    KMPackageItem *item = [self.packageList objectAtIndex:indexPath.row];
    item.selected = [item.ID isEqualToString:_selectedID];
    [cell km_bindData:[self.packageList objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KMPackageItem *item = [self.packageList objectAtIndex:indexPath.row];
    self.selectedID = item.ID;
    [tableView reloadData];
}
//#pragma mark - KMSegmentViewDelegate
//-(void)segmentViewDidClick:(NSInteger)index{
//    
//}

#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"选择套餐");
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
//    [self.view addSubview:self.segment];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.queuqBtn];
    [self.view addSubview:self.tipsLabel];
}

#pragma mark - Lazy
//-(KMSegmentView *)segment{
//    if (!_segment) {
//        _segment = [[KMSegmentView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, 50)
//                                                Titles:@[@"推荐套餐", @"自定义套餐"]
//                                      VerticalLineShow:YES];
//        _segment.delegate = self;
//    }
//    return _segment;
//}
-(UIButton *)queuqBtn{
    if (!_queuqBtn) {
        _queuqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queuqBtn setTitle:@"确认排队" forState:UIControlStateNormal];
        [_queuqBtn setFrame:CGRectMake(AdaptedWidth(55), kScreenHeight - AdaptedHeight(60 + 84), KScreenWidth - AdaptedWidth(55 + 55), AdaptedHeight(84))];
        [_queuqBtn setBackgroundImage:[[[UIImage imageWithColor:kMainThemeColor] imageByResizeToSize:_queuqBtn.size] imageByRoundCornerRadius:_queuqBtn.height / 2.0] forState:UIControlStateNormal];
        [_queuqBtn addTarget:self action:@selector(commitQueue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queuqBtn;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - AdaptedHeight(84 + 60 + 15) - self.tipsLabel.height) style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 100;
        _tableView.delegate           = self;
        _tableView.dataSource         = self;
        _tableView.backgroundColor    = [UIColor clearColor];
        [_tableView registerClass:[KMPackageInfoCell class] forCellReuseIdentifier:[KMPackageInfoCell cellID]];
    }
    return _tableView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        [_tipsLabel setText:@"注:有序号的按序号先后排队,无序号的自动分流,人少时间快的优先"];
        [_tipsLabel setFrame:CGRectMake(self.queuqBtn.left, self.queuqBtn.top - AdaptedHeight(15) - 30, self.queuqBtn.width, 30)];
        [_tipsLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipsLabel setAdjustsFontSizeToFitWidth:YES];
        [_tipsLabel setTextColor:kMainThemeColor];
    }
    return _tipsLabel;
}
@end
