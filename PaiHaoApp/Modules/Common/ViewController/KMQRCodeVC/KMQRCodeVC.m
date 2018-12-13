//
//  KMQRCodeVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMQRCodeVC.h"

#import "KMBluetoothManager.h"
#import "KMBluetoothPrinter.h"

#import "KMFindPrinterVC.h"

#import "LBXScanNative.h"

@interface KMQRCodeVC ()

@property (nonatomic, strong) UIView * background;

@property (nonatomic, strong) UIView * imageBG;

@property (nonatomic, strong) UIImageView * QRIcon;

@property (nonatomic, strong) UILabel * nameLbl;

@end

@implementation KMQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Push -
//发现打印机
-(void)pushPrinterFindVC{
    KMFindPrinterVC *vc         = [[KMFindPrinterVC alloc]init];
    [self.navigationController cyl_pushViewController:vc animated:YES];
}

#pragma mark - Private Method
-(void)createBackgroundView{
    _background                 = [UIView new];
    _background.backgroundColor = [UIColor whiteColor];
    [_background setLayerShadow:kFontColorDarkGray offset:CGSizeMake(0.5, AdaptedHeight(5)) radius:3];
    [self.view addSubview:_background];
    [_background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavHeight + AdaptedHeight(226));
        make.width.mas_equalTo(AdaptedWidth(500));
        make.height.mas_equalTo(AdaptedHeight(560));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [_background setUserInteractionEnabled:YES];
    @weakify(self)
    [_background addLongPressActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self)
        [self showActionSheet];
    }];

    _imageBG                    = [UIView new];
    _imageBG.backgroundColor    = [UIColor whiteColor];
    [_background addSubview:_imageBG];
    [_imageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AdaptedHeight(40));
        make.width.mas_equalTo(AdaptedWidth(384));
        make.height.mas_equalTo(AdaptedHeight(384) * 1.1);
        make.centerX.mas_equalTo(_background.mas_centerX);
    }];
}
-(void)createQRView{

    _QRIcon                     = [UIImageView new];
    [_QRIcon setImageWithURL:[NSURL URLWithString:ImageFullUrlWithUrl(_groupQRIcon ? _groupQRIcon : @"")] placeholder:GetNormalPlaceholderImage options:YYWebImageOptionRefreshImageCache completion:nil];
    [_imageBG addSubview:_QRIcon];
    [_QRIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageBG);
        make.width.mas_equalTo(AdaptedWidth(384));
        make.height.mas_equalTo(AdaptedHeight(384));
        make.centerX.mas_equalTo(_imageBG.mas_centerX);
    }];

    _nameLbl                    = [UILabel new];
    [_nameLbl setFont:kFont30];
    [_nameLbl setTextColor:kFontColorDark];
    [_nameLbl setTextAlignment:NSTextAlignmentCenter];
    [_nameLbl setText:NSStringFormat(@"%@  ID:%@",_groupName, _groupID)];
    [_nameLbl setNumberOfLines:0];
    [_background addSubview:_nameLbl];

    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_background);
        make.left.mas_equalTo(_QRIcon.mas_left);
        make.right.mas_equalTo(_QRIcon.mas_right);
        make.top.mas_equalTo(_imageBG.mas_bottom).offset(AdaptedHeight(-20));
    }];
}

-(void)showActionSheet{
    if ([_QRIcon.image isEqual:GetNormalPlaceholderImage]) {
        return;
    }
   @weakify(self)
   [LBXAlertAction showActionSheetWithTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@[@"打印二维码",@"保存二维码到相册"] chooseBlock:^(NSInteger buttonIdx) {
       @strongify(self)
       //打印二维码
       if (buttonIdx == 1) {
           [self printQRCode];
       }else if (buttonIdx == 2){
        //保存二维码到相册
          UIImageWriteToSavedPhotosAlbum([self.background screenshot:0], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
       }
   }];
}
//打印二维码
-(void)printQRCode{
    if (TARGET_IPHONE_SIMULATOR) {
        [SVProgressHUD showErrorWithStatus:@"模拟器没有蓝牙" Duration:1];
        return;
    }
    //可以打印
    if ([KMBluetoothManager canPrint]) {
    KMBluetoothManager *manager = [KMBluetoothManager sharedInstance];
    KMBluetoothPrinter *printer = [[KMBluetoothPrinter alloc]init];

        [printer appendImage:[_imageBG screenshot:0] alignment:KM_TextAlignmentCenter maxWidth:120];
//        NSString *info = NSStringFormat(@"http://weixin.paihao123.com/web/index/detailed.html?id=%@&groupNo=%@",_groupID,_groupNo);
//        [printer appendQRCodeWithInfo:info size:9];
        [printer appendNewLine];
        [printer appendText:NSStringFormat(@"%@  ID:%@",_groupName, _groupID) alignment:KM_TextAlignmentCenter];
        [printer appendNewLine];
        [printer appendNewLine];
        [printer appendNewLine];
        [printer appendNewLine];
        [printer appendNewLine];
    NSData *mainData = [printer finalPrinterData];
    for (int i = 0; i < [KMBluetoothManager printCount]; i ++) {
            [manager sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
                if (completion) {
                    [SVProgressHUD showSuccessWithStatus:@"打印成功" Duration:1];
                    KMLog(@"打印成功");
                }else{
                    [SVProgressHUD showErrorWithStatus:@"打印失败" Duration:1];
                    KMLog(@"写入错误---:%@",error);
                }
            }];
        }
    }else{
    //不能打印
        [self pushPrinterFindVC];
    }
}

//保存到相册的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    error == nil ? [SVProgressHUD showSuccessWithStatus:@"保存成功" Duration:1] : [SVProgressHUD showErrorWithStatus:@"保存失败" Duration:1];
}


#pragma mark - KMBaseViewControllerDataSource
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"队列二维码");
}

#pragma mark - BaseViewControllerInterface
-(void)km_addSubviews{
    [self createBackgroundView];
    [self createQRView];
}
@end
