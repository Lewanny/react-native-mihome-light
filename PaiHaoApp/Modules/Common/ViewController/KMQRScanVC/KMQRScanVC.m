//
//  KMQRScanVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMQRScanVC.h"
#import "KMGroupQueueDetail.h"
#import "KMGroupQueueInfoVC.h"
@interface KMQRScanVC ()

@end

@implementation KMQRScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏背景色
    self.navigationController.navigationBar.barTintColor = kMainThemeColor;
    
    //标题设置
    [self set_Title:KMBaseNavTitle(@"二维码扫描")];

    //设置扫码区域参数
    LBXScanViewStyle *style       = [[LBXScanViewStyle alloc]init];

    style.centerUpOffset          = 44;
    style.photoframeAngleStyle    = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW         = 2;
    style.photoframeAngleW        = 18;
    style.photoframeAngleH        = 18;
    style.isNeedShowRetangle      = YES;
    style.anmiationStyle          = LBXScanViewAnimationStyle_LineMove;
    style.colorAngle              = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];

    //qq里面的线条图片
    UIImage *imgLine              = [UIImage imageNamed:@"CodeScan.bundle/qrcode_Scan_weixin_Line"];
    style.animationImage          = imgLine;
    self.style                    = style;

    //启动文字
    self.cameraInvokeMsg          = @"相机启动中";
}

#pragma mark - Push
-(void)pushGroupQueueWithGroupID:(NSString *)groupID{
    KMGroupQueueDetail *detail    = [[KMGroupQueueDetail alloc]init];
    detail.groupID                = groupID;
    [self.navigationController cyl_pushViewController:detail animated:YES];
}

//队列详情 已排队
-(void)pushMineQueueInfoWithGroupID:(NSString *)groupID QueueID:(NSString *)queueID{
    KMGroupQueueInfoVC *vc        = [[KMGroupQueueInfoVC alloc]init];
    vc.groupID                    = groupID;
    vc.queueID                    = queueID;
    [self.navigationController cyl_pushViewController:vc animated:YES];
}
#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];

        return;
    }

    LBXScanResult *scanResult     = array[0];

    NSString*strResult            = scanResult.strScanned;

    self.scanImage                = scanResult.imgScanned;

    if (!strResult) {

        [self popAlertMsgWithScanResult:nil];

        return;
    }

    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...

    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
    strResult                     = @"识别失败";
    }
    @weakify(self)
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {
        @strongify(self)
        [self reStartDevice];
    }];
}
//http://weixin.paihao123.com/web/index/detailed.html?id=gro1500889631131f2017c96548b7a7772c4&groupNo=1092
- (void)showNextVCWithScanResult:(LBXScanResult*)strResult {
    KMLog(@"二维码扫描结果 ====== %@",strResult.strScanned);
    NSDictionary *params          = [NSDictionary dictionaryWithURLQuery:strResult.strScanned];
    NSString *key                 = @"id";
    if ([params containsObjectForKey:key]) {
    NSString *groupID             = [params objectForKey:key];
        [KMUserManager pushDetailWithGroupID:groupID];
    }else{
        [self popAlertMsgWithScanResult:strResult.strScanned];
    }
}
- (void)showError:(NSString*)str {
    [UIAlertView alertWithCallBackBlock:nil
                                  title:@"提示"
                                message:str
                       cancelButtonName:@"知道了"
                      otherButtonTitles:nil, nil];
}


-(void)set_Title:(NSMutableAttributedString *)title {
    UILabel *navTitleLabel        = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines   = 0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment   = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = navTitleLabel;
}


@end
