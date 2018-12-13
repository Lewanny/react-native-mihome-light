//
//  KMCommentList.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCommentList.h"

#import "KMGroupCommentCell.h"
#import "KMGroupCommentModel.h"

@interface KMCommentList ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation KMCommentList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentList.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self km_configTableCellWithIndexPath:indexPath];
}
#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"全部评价");
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
}
-(UITableViewCell *)km_configTableCellWithIndexPath:(NSIndexPath *)indexPath{
    KMGroupCommentCell * cell     = [self.tableView dequeueReusableCellWithIdentifier:[KMGroupCommentCell cellID]];
    [cell km_bindData:[_commentList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Lazy
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
        [_tableView registerClass:[KMGroupCommentCell class] forCellReuseIdentifier:[KMGroupCommentCell cellID]];
    _tableView.delegate           = self;
    _tableView.dataSource         = self;
    _tableView.estimatedRowHeight = 100.0;
    }
    return _tableView;
}

@end
