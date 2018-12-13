//
//  KMUploadImageTool.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/22.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUploadImageTool.h"

//相机 相册 相关
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"

@interface KMUploadImageTool ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, copy) UploadSuccess success;

@property (nonatomic, copy) UploadFailure failure;

@property (nonatomic, strong) RACCommand * uploadCommand;

@end


@implementation KMUploadImageTool
#pragma mark - 类方法 调起 -
+(void)uploadWithSuccess:(UploadSuccess)success
                 Failure:(UploadFailure)failure{
    KMUploadImageTool *tool                      = [KMUploadImageTool shareInstance];
    tool.success                                 = success;
    tool.failure                                 = failure;
    [tool showActionSheet];
}

#pragma mark - 初始化 -
+ (instancetype)shareInstance{
    static id tool                               = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    tool                                         = [[KMUploadImageTool alloc]  init];
    });
    return tool;
}

- (instancetype)init
{
    self                                         = [super init];
    if (self) {
        [self initUploadCommand];
    }
    return self;
}
/** 初始化上传指令 */
-(void)initUploadCommand{
    _uploadCommand                               = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    UIImage *image                               = input;
        return [KM_NetworkApi uploadImages:@[image] FieldNames:@[@"uploadImage"]];
    }];
}
/** 弹出 ActionSheet */
-(void)showActionSheet{
    @weakify(self)
    [LBXAlertAction showActionSheetWithTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitle:@[@"拍照", @"去相册选择"] chooseBlock:^(NSInteger buttonIdx) {
       @strongify(self)
        KMLog(@"%ld",buttonIdx);
        if (buttonIdx == 0) {
            //取消
        }else if (buttonIdx == 1) {
            //点击拍照
            [self takePhotoFromCamera];
        }else if (buttonIdx == 2) {
            //点击打开相册
            [self takePhotoFromPhotoAlbum];
        }
    }];
}

/** 选择了从相机获取图片 */
-(void)takePhotoFromCamera{
    AVAuthorizationStatus authStatus             = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // 去设置界面，开启相机访问权限
                if (iOS8Later) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else {
                    NSURL *privacyUrl;
    privacyUrl                                   = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                    if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                        [[UIApplication sharedApplication] openURL:privacyUrl];
                    } else {
    UIAlertView * alert                          = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                }
            }
        } title:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" cancelButtonName:@"取消" otherButtonTitles:@"设置", nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        //防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhotoFromCamera];
                    });
                }
            }];
        } else {
            [self takePhotoFromCamera];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) {
        // 已被拒绝，没有相册权限，将无法保存拍的照片
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // 去设置界面，开启相机访问权限
                if (iOS8Later) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else {
                    NSURL *privacyUrl;
    privacyUrl                                   = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                    if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                        [[UIApplication sharedApplication] openURL:privacyUrl];
                    } else {
    UIAlertView * alert                          = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                }
            }
        } title:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" cancelButtonName:@"取消" otherButtonTitles:@"设置", nil];
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhotoFromCamera];
        }];
    } else {
        //点击拍照
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
    self.imagePickerVc.sourceType                = sourceType;
            if(iOS8Later) {
    _imagePickerVc.modalPresentationStyle        = UIModalPresentationOverCurrentContext;
            }
            [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"模拟器中无法打开照相机,请在真机中使用" Duration:2];
        }
    }
}
/** 选择完成 回调 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //拿到编辑过后 正方形的图片
    UIImage *image                               = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadImage:image];
}

/** 选择了从相册获取图片 */
-(void)takePhotoFromPhotoAlbum{

    TZImagePickerController *imagePickerVc       = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowCrop                      = YES;
    imagePickerVc.cropRect = CGRectMake(0, KScreenHeight/2.0 - KScreenWidth/2.0, KScreenWidth, KScreenWidth);
    imagePickerVc.allowPickingVideo              = NO;
    imagePickerVc.naviBgColor                    = kMainThemeColor;
    @weakify(self)
    imagePickerVc.didFinishPickingPhotosHandle   = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self)
        [self uploadImage:photos.firstObject];
    };
    [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:imagePickerVc animated:YES completion:nil];
}
/** 上传图片 */
-(void)uploadImage:(UIImage *)image{
    @weakify(self, image)
    [[self.uploadCommand execute:image] subscribeNext:^(id  _Nullable x) {
        @strongify(self, image)
        [SVProgressHUD showSuccessWithStatus:@"上传成功" Duration:1];
        self.success ? self.success(image, x) : nil;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [SVProgressHUD showErrorWithStatus:@"上传失败" Duration:1];
        self.failure ? self.failure(error) : nil;
    }];
}


#pragma mark - Getter -

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
    _imagePickerVc                               = [[UIImagePickerController alloc] init];
    _imagePickerVc.allowsEditing                 = YES;
    _imagePickerVc.delegate                      = self;
        // set appearance / 改变相册选择页的导航栏外观
    UINavigationController *nav                  = [[[AppDelegate shareAppDelegate] getCurrentUIVC] navigationController];
    _imagePickerVc.navigationBar.barTintColor    = nav.navigationBar.barTintColor;
    _imagePickerVc.navigationBar.tintColor       = nav.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
    tzBarItem                                    = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
    BarItem                                      = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
    tzBarItem                                    = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
    BarItem                                      = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
    NSDictionary *titleTextAttributes            = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

@end
