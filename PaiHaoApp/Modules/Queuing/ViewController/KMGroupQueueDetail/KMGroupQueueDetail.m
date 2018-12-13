//
//  KMGroupQueueDetail.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupQueueDetail.h"
#import "KMGroupQueueDetailUIService.h"
#import "KMGroupQueueDetailVM.h"

#import "KMEvaluateCommitVC.h"
#import "KMCommentList.h"
#import "KMPackageSelectVC.h"

#import "KMPackageItem.h"

#import "KMSystemShareTool.h"


@interface KMGroupQueueDetail ()

@property (nonatomic, strong) KMGroupQueueDetailVM * viewModel;

@property (nonatomic, strong) KMGroupQueueDetailUIService * service;

@property (nonatomic, strong) UIButton * markBtn;

@property (nonatomic, strong) UITableView * tableViwe;

@end

@implementation KMGroupQueueDetail
#pragma mark - Lift Cycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [SVProgressHUD show];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self km_refreshData];
}
#pragma mark - Push -
//填写评论
-(void)pushEvaluateCommitVC{
    KMEvaluateCommitVC *vc = [[KMEvaluateCommitVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

//评论列表
-(void)pushCommentListVC:(NSArray *)commentList{
    KMCommentList * vc = [[KMCommentList alloc] init];
    vc.commentList = commentList;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

//选择套餐
-(void)pushPackageSelectVC:(NSArray *)packageList{
    KMPackageSelectVC *vc = [[KMPackageSelectVC alloc] init];
    vc.packageList = packageList;
    vc.viewModel = self.viewModel;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - Private Method -
-(void)setupNavRightButton{
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"fxiang"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"fxiang"] forState:UIControlStateHighlighted];
    shareBtn.frame = CGRectMake(0, 0, 30, 44);
    
    [shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_markBtn setImage:IMAGE_NAMED(@"shouc") forState:UIControlStateNormal];
    [_markBtn setImage:IMAGE_NAMED(@"shouc") forState:UIControlStateHighlighted];
    [_markBtn setImage:IMAGE_NAMED(@"wdsc") forState:UIControlStateSelected];
    [_markBtn setFrame:CGRectMake(0, 0, 30, 44)];
    [_markBtn addTarget:self action:@selector(clickMarkButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:_markBtn];
    
    //调整按钮位置
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width= -5;
    self.navigationItem.rightBarButtonItems = @[spaceItem, item1, item2];
}

-(void)setAttributedTitle:(NSMutableAttributedString *)title {
    UILabel *navTitleLabel = (UILabel *)self.navigationItem.titleView;
    [navTitleLabel setAttributedText:title];
}

-(void)cacheGroupInfo{
    KMGroupBriefModel *model = [KMGroupBriefModel new];
    KMGroupBaseInfo *info = self.viewModel.baseInfo;
    model.waitcount = info.frontnumber.integerValue;
    model.ID = info.groupid;
    model.waittime = info.waittime.integerValue;
    model.groupname = info.groupname;
    model.groupphoto = info.groupphoto;
    model.groupaddr = info.groupaddr;
    model.groupno = info.groupno;
    model.qrcode = info.qrcode;
    model.lat = info.lat.floatValue;
    model.lng = info.lng.floatValue;
    
    NSArray *arr = [NSUserDefaults arcObjectForKey:kHistory];
    NSMutableArray *arrM = arr ? arr.mutableCopy : @[].mutableCopy;
    if (arrM.count) {
        for (KMGroupBriefModel *obj in arrM) {
            if ([obj.ID isEqualToString:model.ID]) {
                [arrM removeObject:obj];
                break;
            }
        }
        [arrM insertObject:model atIndex:0];
    }else{
        [arrM addObject:model];
    }
    [NSUserDefaults setArcObject:arrM forKey:kHistory];
}
//点击收藏按钮
-(void)clickMarkButton:(UIButton *)btn{
    //需要判断登录
    if ([KMUserManager checkLoginWithPresent:YES]) {
        if (self.viewModel.isCollection) {
            //如果已经收藏
            if (self.viewModel.collectionID.length) {
                [self.viewModel.deleCollection execute:self.groupID];
            }
        }else{
            //如果还没收藏
            [self.viewModel.addCollection execute:self.groupID];
        }
    }
}

-(void)clickShareBtn:(UIButton *)sender{
    if (!_viewModel.baseInfo) {
        return;
    }
    //http://weixin.paihao123.com/web/index/detailed.html?id=gro1504521318e338010dccd14ebab9654d4&groupNo=1145
    NSString *textToShare = NSStringFormat(@"http://weixin.paihao123.com/web/index/detailed.html?id=%@&groupNo=%@",_viewModel.baseInfo.groupid, _viewModel.baseInfo.groupno);
    NSURL *urlToShare = [NSURL URLWithString:textToShare];
    [KMSystemShareTool shareWithURL:urlToShare Text:textToShare Image:nil];
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"号群详情");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    
    [self setupNavRightButton];
    [self.view addSubview:self.tableViwe];
    [self service];
}

-(void)km_refreshData{
    if (KMUserDefault.isLogin) {
        //已登录才能判断是否已经排队
        [self.viewModel.checkQueue execute:self.groupID];
    }
    [self.viewModel.requestQueueInfo execute:self.groupID];
    @weakify(self)
    [[self.viewModel.requestGroupInfo execute:self.groupID] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self setAttributedTitle:KMBaseNavTitle(self.viewModel.baseInfo.groupname)];
        [self cacheGroupInfo];
    }];
}

-(void)km_requestData{
    @weakify(self)
    [[self.viewModel.requestGroupInfo execute:self.groupID] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self setAttributedTitle:KMBaseNavTitle(self.viewModel.baseInfo.groupname)];
        [self cacheGroupInfo];
    }];
    [self.viewModel.requestPackageInfo execute:self.groupID];
    [self.viewModel.requestQueueInfo execute:self.groupID];
    [self.viewModel.requestComment execute:self.groupID];
    
    if (KMUserDefault.isLogin) {
        //已登录才能判断是否收藏
        [self.viewModel.checkCollectionStatus execute:self.groupID];
    }
}

-(void)km_bindViewModel{
    @weakify(self)
    //评论列表
    [self.service.pushCommentListVC subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushCommentListVC:x];
    }];
    //套餐选择
    [self.service.pushPackageSeleVC subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushPackageSelectVC:self.viewModel.packageList];
    }];
    //收藏状态
    [self.viewModel.checkCollectionStatus.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        RACTuple *tuple           = x;
        NSInteger status          = [tuple[3] integerValue];
        if (status == 0) {      //已收藏
            self.markBtn.selected = YES;
        }else if (status == 3){ //未收藏
            self.markBtn.selected = NO;
        }
    }];
    
    [self.viewModel.addCollection.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        RACTuple *tuple           = x;
        NSInteger status          = [tuple[3] integerValue];
        if (status == 0) {      //收藏成功
            [SVProgressHUD showSuccessWithStatus:@"收藏成功" Duration:1];
        }
        //刷新收藏状态
        [self.viewModel.checkCollectionStatus execute:self.groupID];
    }];
    [self.viewModel.deleCollection.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        RACTuple *tuple           = x;
        NSInteger status          = [tuple[3] integerValue];
        if (status == 0) {      //取消收藏成功
            [SVProgressHUD showSuccessWithStatus:@"已取消收藏" Duration:1];
        }
        //刷新收藏状态
        [self.viewModel.checkCollectionStatus execute:self.groupID];
    }];
    [self.viewModel.refreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self km_refreshData];
    }];
}

#pragma mark - Lazy
-(KMGroupQueueDetailVM *)viewModel{
    if (!_viewModel) {
        _viewModel         = [[KMGroupQueueDetailVM alloc]init];
        _viewModel.groupID = self.groupID;
        _viewModel.isVoice = YES;
    }
    return _viewModel;
}
-(KMGroupQueueDetailUIService *)service{
    if (!_service) {
        _service           = [[KMGroupQueueDetailUIService alloc] initWithTableView:self.tableViwe ViewModel:self.viewModel];
    }
    return _service;
}

-(UITableView *)tableViwe{
    if (!_tableViwe) {
        _tableViwe         = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    }
    return _tableViwe;
}

@end
