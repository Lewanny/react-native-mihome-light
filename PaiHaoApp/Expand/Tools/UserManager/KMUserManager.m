//
//  KMUserManager.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMUserManager.h"

#import "KMGroupQueueInfoVC.h"
#import "KMGroupQueueDetail.h"

#import "KMGroupDetailInfo.h"
#import "KMGroupBaseInfo.h"
#import "KMCollectionModel.h"
#import "KMHistoryQueueModel.h"

#import <JPush/JPUSHService.h>

@implementation KMUserManager
+ (id)shareInstance{
    static id manger                 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    manger                           = [[KMUserManager alloc]  init];
    });
    return manger;
}

/** 登录 */
-(void)loginWithUserName:(NSString *)userName
                Password:(NSString *)password
                 Success:(Block_Obj)success
                 Failure:(Block_Err)failure{
    RACSignal *sig                   = [KM_NetworkApi loginWithUserName:userName
                                             Password:password
                                            LoginType:KM_LoginTypeiOS];
    [sig subscribeNext:^(RACTuple * x) {
        NSInteger status                 = [x.second integerValue];
        if (status == 0) {
            KMUserLoginModel *userLogin      = (KMUserLoginModel *)x.first;
            /** 把登录模型存起来 */
            [KMUserManager loginSuccess:userLogin];
            success ? success(userLogin) : nil;
        }else{
            failure ? failure(nil) : nil;
        }
    } error:^(NSError * _Nullable error) {
        failure ? failure(error) : nil;
    }];
}

/** 获取验证码 */
-(void)requestSecurityCodeWithTele:(NSString *)tele
                           Success:(Block_Str)success
                           Failure:(Block_Err)failure{
    RACSignal *sig                   = [KM_NetworkApi requestSecurityCodeWithTele:tele];
    [sig subscribeNext:^(RACTuple * x) {
    NSString * verification          = x.first;
        success ? success(verification) : nil;
    } error:^(NSError * _Nullable error) {
        failure ? failure(error) : nil;
    }];
}
/** 检查是否已经注册 */
-(void)checkAccountRegisterStatus:(NSString *)tele
                         CallBack:(Block_Bool)callBack{
    [[KM_NetworkApi checkAccountRegisterStatus:tele] subscribeNext:^(RACTuple * x) {

    NSArray *paramsSet               = x.second;
    NSString *value                  = [KMTool valueForName:kResult InArr:paramsSet];
    BOOL ret                         = NO;
        if ([value isEqualToString:@"0"]) {
            //已经注册
    ret                              = NO;
        }else if ([value isEqualToString:@"1"]){
            //还没注册
    ret                              = YES;
        }
        callBack ? callBack(ret) : nil;
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"服务器异常" Duration:1];
    }];
}
/** 注册 */
-(void)registerWithTele:(NSString *)tele
                   Code:(NSString *)code
              Password1:(NSString *)password1
              Password2:(NSString *)password2
               UserType:(KM_UserType)userType
                Success:(Block_Str)success
                Failure:(Block_Err)failure{

    BOOL ret                         = YES;
    //判断验证码
    if (code.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" Duration:1];
    ret                              = NO;
    }
    //本地保存的验证码验证码
    NSString *netCode                = [NSUserDefaults stringForKey:kVerification];
    if (ret && netCode.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先获取验证码" Duration:1];
    ret                              = NO;
    }
    if (ret && ![netCode isEqualToString:code]) {
        [SVProgressHUD showErrorWithStatus:@"验证码有误" Duration:1];
    ret                              = NO;
    }
    //两次密码是否一致
    if (ret && ![password1 isEqualToString:password2]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致" Duration:1];
    ret                              = NO;
    }
    if (!ret) {
        failure ? failure(nil) :nil;
        return;
    }
    RACSignal *sig = [KM_NetworkApi commitRegisterWithTele:tele Password:password1 UserType:userType];
    [sig subscribeNext:^(RACTuple * x) {
    NSArray *paramsSet               = x.second;
    NSString *accountId              = [KMTool valueForName:kAccountId InArr:paramsSet];
        success ? success(accountId) : nil;
    } error:^(NSError * _Nullable error) {
        failure ? failure(error) : nil;
    }];
}
/** 找回密码 */
-(void)changePwdWithTele:(NSString *)tele
                    Code:(NSString *)code
               Password1:(NSString *)password1
               Password2:(NSString *)password2
                 Success:(Block_Bool)success
                 Failure:(Block_Err)failure{
    BOOL ret                         = YES;
    //判断验证码
    if (code.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码" Duration:1];
    ret                              = NO;
    }
    //本地保存的验证码验证码
    NSString *netCode                = [NSUserDefaults stringForKey:kVerification];
    if (ret && netCode.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先获取验证码" Duration:1];
    ret                              = NO;
    }
    if (ret && ![netCode isEqualToString:code]) {
        [SVProgressHUD showErrorWithStatus:@"验证码有误" Duration:1];
    ret                              = NO;
    }
    //两次密码是否一致
    if (ret && ![password1 isEqualToString:password2]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致" Duration:1];
    ret                              = NO;
    }
    if (!ret) {
        failure ? failure(nil) :nil;
        return;
    }
    RACSignal *sig                   = [KM_NetworkApi commitNewPassword:password1 Tele:tele];
    [sig subscribeNext:^(id  _Nullable x) {
        success ? success(YES) : nil;
    } error:^(NSError * _Nullable error) {
        failure ? failure(error) : nil;
    }];
}

/**
 是否登录

 @param needPresent 如果没登录是否跳转登录
 @return 是否登录
 */
+(BOOL)checkLoginWithPresent:(BOOL)needPresent{
    if (!KMUserDefault.isLogin && needPresent) {
    UIViewController *login          = ViewControllFromStoryboard(KMRegisterAndLonginStoryboardName, KMLoginViewControllerIdentifier);
    UINavigationController *loginNav = BaseNavigationWithRootVC(login);
        [[AppDelegate shareAppDelegate].getCurrentUIVC presentViewController:loginNav animated:YES completion:nil];
    }
    return KMUserDefault.isLogin;
}
/** 保存登录数据 */
+(void)loginSuccess:(KMUserLoginModel *)userLoginModel{
    [NSUserDefaults setArcObject:userLoginModel forKey:kUserLoginModel];
    KMUserDefault.isLogin            = YES;
    KMUserDefault.userName           = userLoginModel.loginName;
    KMUserDefault.userID             = userLoginModel.info.userId;
    KMUserDefault.accountID          = userLoginModel.ID;
    KMUserDefault.telephone          = userLoginModel.info.telephone;
    KMUserDefault.isVoice = userLoginModel.info.isVoice;
    KMUserDefault.isSms = userLoginModel.info.isSms;
    KPostNotification(kLoginNotiName, nil);
    //极光推送设置Tag
    [JPUSHService setTags:[NSSet setWithObject:userLoginModel.info.userId] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        KMLog(@"tag注册成功 iResCode = %ld, iTags = %@ seq = %ld ",iResCode,iTags,seq);
    } seq:0];
}
/** 退出登录 */
+(void)logout{
    //极光推送删除tag
    [JPUSHService deleteTags:[NSSet setWithObject:KMUserDefault.userID] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        KMLog(@"tag删除成功 iResCode = %ld, iTags = %@ seq = %ld ",iResCode,iTags,seq);
    } seq:0];
    
   [NSUserDefaults setArcObject:nil forKey:kUserLoginModel];
    KMUserDefault.isLogin            = NO;
    KMUserDefault.userName           = nil;
    KMUserDefault.userID             = nil;
    KMUserDefault.accountID          = nil;
    KMUserDefault.telephone          = nil;
    KPostNotification(kLogoutNotiName, nil);
}
/** 获取之前保存在本地登录返回的模型 */
+(KMUserLoginModel *)getLoginModel{
    return [NSUserDefaults arcObjectForKey:kUserLoginModel];
}

+(void)pushDetailWithGroupID:(NSString *)groupID{
    KMGroupQueueDetail *vc           = [[KMGroupQueueDetail alloc]init];
    vc.groupID                       = groupID;
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
}


+(void)pushQRCodeVCWithData:(id)data{
    if ([data isKindOfClass:[KMGroupBriefModel class]]) {
    KMGroupBriefModel *brief         = data;
    KMQRCodeVC *vc                   = [[KMQRCodeVC alloc]init];
    vc.groupIcon                     = brief.groupphoto;
    vc.groupName                     = brief.groupname;
    vc.groupID                       = brief.groupno;
    vc.groupQRIcon                   = brief.qrcode;
    vc.groupNo                       = brief.groupno;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
    }else if ([data isKindOfClass:[KMGroupDetailInfo class]]){
    KMGroupDetailInfo *info          = data;
    KMQRCodeVC *vc                   = [[KMQRCodeVC alloc]init];
    vc.groupIcon                     = info.photo;
    vc.groupName                     = info.groupname;
    vc.groupID                       = info.groupno;
    vc.groupQRIcon                   = info.qrcode;
    vc.groupNo                       = info.groupno;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
    }else if ([data isKindOfClass:[KMGroupBaseInfo class]]){
    KMGroupBaseInfo *info            = data;
    KMQRCodeVC *vc                   = [[KMQRCodeVC alloc]init];
    vc.groupIcon                     = info.groupphoto;
    vc.groupName                     = info.groupname;
    vc.groupID                       = info.groupno;
    vc.groupQRIcon                   = info.qrcode;
    vc.groupNo                       = info.groupno;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
    }else if ([data isKindOfClass:[KMGroupInfo class]]){
    KMGroupInfo *info                = data;
    KMQRCodeVC *vc                   = [[KMQRCodeVC alloc]init];
    vc.groupIcon                     = info.photo;
    vc.groupName                     = info.groupname;
    vc.groupID                       = info.groupno;
    vc.groupQRIcon                   = info.qrcode;
    vc.groupNo                       = info.groupno;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
    }else if ([data isKindOfClass:[KMQueueInfo class]]){
    KMQueueInfo *info                = data;
    KMQRCodeVC *vc                   = [[KMQRCodeVC alloc]init];
    vc.groupIcon                     = info.groupphoto;
    vc.groupName                     = info.groupname;
    vc.groupID                       = info.groupno;
    vc.groupQRIcon                   = info.qrcode;
    vc.groupNo                       = info.groupno;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
    }else if ([data isKindOfClass:[KMCollectionModel class]]){
    KMCollectionModel *cData         = data;
    KMQRCodeVC *vc                   = [[KMQRCodeVC alloc]init];
    vc.groupIcon                     = cData.groupphoto;
    vc.groupName                     = cData.groupname;
    vc.groupID                       = cData.groupno;
    vc.groupQRIcon                   = cData.qrcode;
    vc.groupNo                       = cData.groupno;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
    }else if ([data isKindOfClass:[KMHistoryQueueModel class]]){
    KMHistoryQueueModel *hData       = data;
    KMQRCodeVC *vc                   = [[KMQRCodeVC alloc]init];
    vc.groupIcon                     = hData.groupImg;
    vc.groupName                     = hData.groupName;
    vc.groupID                       = hData.groupNo;
    vc.groupQRIcon                   = hData.qrcode;
    vc.groupNo                       = hData.groupNo;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController cyl_pushViewController:vc animated:YES];
    }
}

@end
