//
//  KMReplyDetailVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/14.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMReplyDetailVC.h"
#import "KMReplyDetailVM.h"
#import "KMReplyMsgCell.h"
#import "KMReplyToolBar.h"


@interface KMReplyDetailVC ()<UITableViewDelegate, UITableViewDataSource, YYTextKeyboardObserver>

@property (nonatomic, strong) KMReplyDetailVM * viewModel;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) KMReplyToolBar * toolBar;

@end

@implementation KMReplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [_toolBar.textF resignFirstResponder];
}

#pragma mark - YYTextKeyboardObserver -
-(void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition{
//    [UIView animateWithDuration:0.25 animations:^{
    self.toolBar.bottom           = transition.toFrame.origin.y;
//    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    _viewModel.reply ? [self changeNavTitle:@"2条回复"] : nil;
    return _viewModel.reply ? 2 : 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return AdaptedHeight(20);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KMReplyMsgCell *cell          = [tableView dequeueReusableCellWithIdentifier:[KMReplyMsgCell cellID]];
    cell.replyMsgType             = indexPath.section;
    [cell km_bindData:_viewModel.reply];
    return cell;
}
#pragma mark - Private Method -
-(void)changeNavTitle:(NSString *)text{
    UILabel *lable                = (UILabel *)self.navigationItem.titleView;
    lable && lable.text.length == 0 ? [lable setAttributedText:KMBaseNavTitle(text)] : nil;
}
#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
}
-(void)km_requestData{
    @weakify(self)
    [[self.viewModel.feedbackInfoCommand execute:self.messageID] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.viewModel.reply) {
    self.toolBar.hidden           = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.toolBar.textF becomeFirstResponder];
            });
        }
    }];
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
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    @weakify(self)
    [self.toolBar.sendSubject subscribeNext:^(id  _Nullable x) {
    NSString *text                = x;
        if (text.length) {
            @strongify(self)
            [[self.viewModel.feedbackCommand execute:text] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请输入回复" Duration:1];
        }
    }];
}
#pragma mark - Lazy -
-(KMReplyDetailVM *)viewModel{
    if (!_viewModel) {
    _viewModel                    = [[KMReplyDetailVM alloc]init];
    }
    return _viewModel;
}
-(KMReplyToolBar *)toolBar{
    if (!_toolBar) {
    _toolBar                      = [KMReplyToolBar toolBar];
    _toolBar.top                  = KScreenHeight - kReplyToolBarH;
    _toolBar.hidden               = YES;
    }
    return _toolBar;
}
-(UITableView *)tableView{
    if (!_tableView) {
    _tableView                    = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight - self.toolBar.height) style:UITableViewStyleGrouped];
    _tableView.delegate           = self;
    _tableView.dataSource         = self;
        [_tableView registerClass:[KMReplyMsgCell class] forCellReuseIdentifier:[KMReplyMsgCell cellID]];
    _tableView.backgroundColor    = self.view.backgroundColor;
    _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}
@end
