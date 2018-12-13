//
//  KM_NetworkApi.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KM_NetworkApi.h"



@implementation KM_NetworkApi
/** 请求基地址 */
+(NSString *)hostUrl{
//    if (DEBUG) {
//        return @"http://112.124.3.157:8100/WebAPI.ashx";
//    }else{
//    return @"http://112.124.3.157:8100/WebAPI.ashx";
    return @"http://api.paihao123.com/WebAPI.ashx";
//    }
}

/** 图片地址 */
+(NSString *)imagePrefixUrl{
//    if (DEBUG) {
//        return @"http://112.124.3.157:8100/Image/";
//    }else{
//        return @"http://112.124.3.157:8100/Image/";
    return @"http://api.paihao123.com//Image/";
//    }
}
/** 接口地址：http://112.124.3.157:8100/UploadImage.ashx
 Post上传 文件name为”fieldName”
 返回图片名称。其完整路径是：http://112.124.3.157:8100/Image/+ 系统返回路径
 */
+(NSString *)uploadImageUrl{
//    if (DEBUG) {
//        return @"http://112.124.3.157:8100/UploadImage.ashx";
//    }else{
        return @"http://112.124.3.157:8100/UploadImage.ashx";
//    }
}


#pragma mark - 首页与注册接口

/** 推荐队列 */
+(RACSignal *)requestRecommendGroup{

    NSDictionary *params                                                                                                                                                       = [KM_NetworkParams paramsWithActionName:KM_NetworkActionName.MobileGetShowGroup paramsSet:nil entrySet:nil];

    return [KM_NetworkClient requestParams:params Cache:YES];
}
/** 我的排号（先登录) */
+(RACSignal *)requestMineQueue{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetUserQueueInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 根据行业分类获取队列列表 */
+(RACSignal *)requestQueueListWithCategory:(NSString *)category
                                     Index:(NSInteger)index
                                    Status:(NSInteger)status
                                      City:(NSString *)city{
    NSString *locationCity                                                                                                                                                     = [NSUserDefaults stringForKey:kLocationCity];
    NSString *currentCity                                                                                                                                                      = [NSUserDefaults stringForKey:kCurrentCity];
    NSString *cityName                                                                                                                                                         = city.length ? city : currentCity ? currentCity : locationCity;
    CLLocation *location                                                                                                                                                       = [KMLocationManager shareInstance].myLocation;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kKeyword : @""},
                       @{kProv : @""},
                       @{kCity : cityName ? cityName : @""},
                       @{kDist : @""},
                       @{kCategory : category},
                       @{@"pageindex" : index == 0 ? @(1) : @(index)},
                       @{@"longitude":location?@(location.coordinate.longitude):@(0)},
                       @{@"latitude":location?@(location.coordinate.latitude):@(0)},
                       @{@"status":@(status)},
                       nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetSearchGroup]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 登录 */
+(RACSignal *)loginWithUserName:(NSString *)userName
                       Password:(NSString *)password
                      LoginType:(KM_LoginType)loginType{
    //转换成后台需要的格式
    NSArray *loginParams                                                                                                                                                       = [KMTool weirdDictWithDictionarys:@{kLoginName :userName}, @{kLoginPwd : password}, @{kMode : NSStringFormat(@"%ld",loginType)}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileLogin]
                                                             paramsSet:loginParams
                                                              entrySet:nil];

    return [[KM_NetworkClient requestParams:finalParams] map:^id _Nullable(RACTuple * value) {
        NSArray  * entrySet                                                                                                                                                        = value.first;
        NSArray  * paramsSet                                                                                                                                                   = value.second;
        NSNumber * status                                                                                                                                                          = value.fourth;
        //转成模型
        KMUserLoginModel *loginModel                                                                                                                                          = [[KMUserLoginModel alloc] initWithEntrySet:entrySet ParamsSet:paramsSet];
            return RACTuplePack(loginModel, status);
        
    }];

}
/** 获取验证码 */
+(RACSignal *)requestSecurityCodeWithTele:(NSString *)tele{
    //转换成后台需要的格式
    NSArray *codeParams                                                                                                                                                        = [KMTool weirdDictWithDictionarys:@{kMobile : tele}, @{kType : kTypeValue}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AHSMSEx]
                                                             paramsSet:codeParams
                                                              entrySet:nil];
    return [[KM_NetworkClient requestParams:finalParams] map:^id _Nullable(RACTuple * value) {
    NSArray  * entrySet                                                                                                                                                        = value.first;
    NSDictionary *dict                                                                                                                                                         = entrySet.firstObject;
//            NSString *mobile = [dict objectForKey:@"mobile"];
            /** 拿到验证码 */
    NSString *verification                                                                                                                                                     = [dict objectForKey:kVerification];
            //保存验证码
    KMUserDefault.verification                                                                                                                                                 = verification;
            KMLog(@"验证码  ===  %@",verification);
            return RACTuplePack(verification);
            }];
}
/**
 找回密码

 @param newPassword 新密码
 @param tele 电话号码
 @return RACSignal
 */
+(RACSignal *)commitNewPassword:(NSString *)newPassword
                           Tele:(NSString *)tele{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kPhone : tele}, @{kloginPwd : newPassword}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileModifyPassWord]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 检查注册状态 没注册过的才继续注册 */
+(RACSignal *)checkAccountRegisterStatus:(NSString *)tele{

    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kPhone : tele}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileCheckAccount]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/**
 提交注册

 @param tele 电话号码
 @param password  输入密码
 @param userType  用户类型
 @return RACSignal
 */
+(RACSignal *)commitRegisterWithTele:(NSString *)tele
                            Password:(NSString *)password
                            UserType:(KM_UserType)userType{
    //转换成后台需要的格式
    NSArray *regParams                                                                                                                                                         = [KMTool weirdDictWithDictionarys:@{kLoginpwd : password}, @{kPhone : tele}, @{kAuditstatus : NSStringFormat(@"%ld",userType)}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileRegister]
                                                             paramsSet:regParams
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/**
 完善用户信息

 @param accountId 账户ID
 @param userName 用户名
 @param mail 邮箱
 @param location 定位
 @return RACSignal
 */
+(RACSignal *)completeUserInfoWithAccountId:(NSString *)accountId
                                   UserName:(NSString *)userName
                                       Mail:(NSString *)mail
                                   Location:(NSString *)location{
    //转换成后台需要的格式
    NSArray *infoParams                                                                                                                                                        = [KMTool weirdDictWithDictionarys:@{kAccountId : accountId}, @{kloginName : userName}, @{kMail : mail}, @{kAddress : location}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileImproveUserInfo]
                                                             paramsSet:infoParams
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/**
 完善商户信息

 @param accountId 账户ID
 @param merchanInfo 商户信息
 @return RACSignal
 */
+(RACSignal *)commpleteMerchantInfoWithAccountId:(NSString *)accountId
                                     MerchanInfo:(KMMerchantInfoModel *)merchanInfo{
    //原始参数
    NSDictionary *params                                                                                                                                                       = [merchanInfo modelToJSONObject];
    //转换成后台需要的格式
    NSArray *entrySet                                                                                                                                                          = @[params];
    NSArray *paramsSet                                                                                                                                                         = [KMTool weirdDictWithDictionarys:@{kAccountId : accountId}, nil];


    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileImproveUserInfo]
                                                             paramsSet:paramsSet
                                                              entrySet:entrySet];
    return [KM_NetworkClient requestParams:finalParams];
}

/**
 上传图片

 @param imageArr 图片数组
 @param fieldNameArr 文件名数组
 @return RACSignal
 */
+(RACSignal *)uploadImages:(NSArray<UIImage *> *)imageArr
                FieldNames:(NSArray<NSString *> *)fieldNameArr{
   return [KM_NetworkClient uploadImages:imageArr FieldNames:fieldNameArr URL:[KM_NetworkApi uploadImageUrl] Progress:^(NSProgress *progress) {
       [SVProgressHUD showWithStatus:@"正在上传"];
//       [SVProgressHUD showProgress:progress.completedUnitCount / progress.totalUnitCount];
   }];
}
/** 获取行业类别 */
+(RACSignal *)requestMerchantType{
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetMerchantType]
                                                             paramsSet:nil
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}
#pragma mark - 会员中心
/** 获取个人信息 */
+(RACSignal *)requestUserInfo{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetUserInfoEx]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}
/** 获取普通用户详情 */
+(RACSignal *)requestUserDeatil{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //原始参数
    NSDictionary *params                                                                                                                                                       = @{
                             kUserId : userId,
                             };
    //转换成后台需要的格式
    NSArray *infoParams                                                                                                                                                        = [KMTool weirdDictWithNormalDict:params
                                             WithKeyOrder:@[kUserId]];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetAverageUserInfo]
                                                             paramsSet:infoParams
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}
/** 修改个人用户姓名 */
+(RACSignal *)editUserName:(NSString *)userName{
    NSString *userId                                                                                                                                                        = KMUserDefault.userID;
    //原始参数
    NSDictionary *params                                                                                                                                                       = @{
                             @"userId" : userId,
                             kUsername : userName
                             };
    //转换成后台需要的格式
    NSArray *infoParams                                                                                                                                                        = [KMTool weirdDictWithNormalDict:params
                                             WithKeyOrder:@[@"userId", kUsername]];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditUserNameEx]
                                                             paramsSet:infoParams
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 修改头像 */
+(RACSignal *)editHeadPortrait:(NSString *)url{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //原始参数
    NSDictionary *params                                                                                                                                                       = @{
                             kUserId : userId,
                             kHeadportrait : url
                             };
    //转换成后台需要的格式
    NSArray *infoParams                                                                                                                                                        = [KMTool weirdDictWithNormalDict:params
                                             WithKeyOrder:@[kUserId, kHeadportrait]];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditHeadPortrait]
                                                             paramsSet:infoParams
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 验证姓名是否已被占用 */
+(RACSignal *)checkNicknameStatus:(NSString *)nickname{

    //原始参数
    NSDictionary *params                                                                                                                                                       = @{
                             kLoginname : nickname,
                             };
    //转换成后台需要的格式
    NSArray *secParams                                                                                                                                                         = [KMTool weirdDictWithNormalDict:params
                                            WithKeyOrder:@[kLoginname]];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileCheckAccount]
                                                             paramsSet:secParams
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 修改手机号 */
+(RACSignal *)editPhone:(NSString *)phone{
    NSString *accountId                                                                                                                                                        = KMUserDefault.accountID;
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;

    //转换成后台需要的格式

    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:
                                                @{kAccountId : accountId},
                                                @{kUserId : userId},
                                                @{kPhone : phone}, nil];

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditPhone]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 修改邮箱 */
+(RACSignal *)editMail:(NSString *)mail{
    NSString *accountId                                                                                                                                                        = KMUserDefault.accountID;
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;

    //转换成后台需要的格式

    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:
                       @{kAccountId : accountId},
                       @{kUserId : userId},
                       @{kMail : mail}, nil];

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditMail]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 修改地址 */
+(RACSignal *)editAddr:(NSString *)addr{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式

    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:
                       @{kUserId : userId},
                       @{kUserAddress : addr}, nil];

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditAddr]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 修改区域 */
+(RACSignal *)editAreaWithProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{@"province" : province}, @{@"city" : city}, @{@"area" : area}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditArea]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 获取商户详情 */
+(RACSignal *)businessUserInfo{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:
                       @{kUserId : userId}, nil];

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetBusinessUserInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}
/** 修改商户图片 */
+ (RACSignal *)editPictrue:(NSString *)pictrue{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{kHeadportrait : pictrue}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileEditPictrue]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 修改商户名称 */
+ (RACSignal *)editBusinessName:(NSString *)businessName{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{kBusinessname : businessName}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditBusinessName]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 更改商家简介 */
+(RACSignal *)editSynopsis:(NSString *)synopsis{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{kSynopsis : synopsis}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditSynopsis]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];

}
/** 修改电话号码 */
+(RACSignal *)editTelephoneWithTel:(NSString *)telephone{
    NSString *userId = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{@"telephone" : telephone}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditTelephone]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 修改行业 */
+(RACSignal *)editMerchantWithID:(NSString *)merchantID{
    NSString *userId = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{@"merchantId" : merchantID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditMerchant]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}






/** 历史排号 */
+(RACSignal *)queueHistory{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetDataForQueueHistory]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}
/** 我的收藏列表 */
+(RACSignal *)collectionQueue{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetCollectionGroupByuserId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}
/** 删除历史排队 */
+(RACSignal *)delHistoryQueue:(NSString *)queueID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"id" : queueID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelQueueInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 删除收藏 */
+(RACSignal *)delCollectionQueue:(NSString *)queueID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"id" : queueID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelCollectionInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 服务窗口列表 */
+(RACSignal *)serviceWindowList{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kuserid : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetWindowInfoByUserId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 删除窗口 */
+(RACSignal *)deleWindowWithID:(NSString *)winID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"id" : winID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelWindowInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 添加窗口 */
+(RACSignal *)addWindowWithName:(NSString *)winName
                           Info:(NSString *)winInfo{
    //转换成后台需要的格式
    NSDictionary *params                                                                                                                                                       = @{
                             @"userId" : KMUserDefault.userID,
                             @"creater" : KMUserDefault.userName,
                             @"windowName" : winName,
                             @"reserve" : winInfo
                        };
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddWindowInfo]
                                                             paramsSet:@[]
                                                              entrySet:@[params]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 呼叫员列表 */
+(RACSignal *)callerList{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kuserid : KMUserDefault.userID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetCallOfficer]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 删除呼叫员 */
+(RACSignal *)deleCallerWithAccountId:(NSString *)accountId
                               UserId:(NSString *)userId{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kAccountId : accountId}, @{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelCallOfficer]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 添加呼叫员 */
+(RACSignal *)addCallerUserName:(NSString *)userName
                      LoginName:(NSString *)loginName
                       LoginPwd:(NSString *)loginPwd{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kuserid : KMUserDefault.userID}, @{@"userName" : userName}, nil];

    NSDictionary *entry                                                                                                                                                        = @{@"loginName" : loginName, @"loginPwd" : loginPwd};

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddCallOfficer]
                                                             paramsSet:params
                                                              entrySet:@[entry]];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 普通用户升级商户 */
+(RACSignal *)applyMerchantWithData:(RACTuple *)data{
    RACTupleUnpack(NSString * fullname, NSString * province, NSString * city, NSString * area, NSString * address, NSString * telephone, NSString * mail, NSString * synopsis) = data;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : KMUserDefault.userID}, @{@"fullname" : fullname}, @{@"province" : province}, @{@"city" : city}, @{@"area" : area}, @{@"address" : address}, @{@"telephone" : telephone}, @{@"mail" : mail}, @{@"synopsis" : synopsis}, nil];

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileApplyMerchant]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 普通商户升级认证商户 */
+(RACSignal *)updateMerchantWithData:(RACTuple *)data{
    RACTupleUnpack(NSString * fullname, NSString * certificates, NSString * certificatespicture, NSString * contacts, NSString * phone)                                        = data;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : KMUserDefault.userID}, @{@"fullname" : fullname}, @{@"certificates" : certificates}, @{@"certificatespicture" : certificatespicture}, @{@"contacts" : contacts}, @{@"phone" : phone}, nil];

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileUpgradeSeniorMerchant]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 语音提醒设置 */
+(RACSignal *)editReminderSettings:(BOOL)setting{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"userId" : KMUserDefault.userID}, @{@"isVoice" : setting ? @"1":@"0"}, nil];
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditReminderSettings]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

#pragma mark - 动态消息
/** 我的消息 动态消息 */
+(RACSignal *)messageDT{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kuserid : KMUserDefault.userID}, nil];

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetMessageReminder]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 添加浏览记录  0浏览内容，1浏览评论,2浏览反馈信息  */
+(RACSignal *)addBrowsingHistoryWithMsgID:(NSString *)msgID Mode:(NSNumber *)mode{
    //转换成后台需要的格式
    NSDictionary *params  = @{@"messageId" : msgID,
                              kuserid : KMUserDefault.userID,
                              @"mode" : mode ? mode : @(0)
                              };                                                                                                                                                         
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddReadingInfo]
                                                                                                                                                                                                              paramsSet:nil
                                                                                                                                                                                                               entrySet:@[params]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 提交反馈 */
+(RACSignal *)feedbackWithMessage:(NSString *)message{
    NSDictionary *entrySet = @{@"message" : message ? message : @"", @"fromUserId" : KMUserDefault.userID, @"messageType":@"3"};
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddMessageInfo]
                                                                                                                                                                                                              paramsSet:nil
                                                                                                                                                                                                               entrySet:@[entrySet]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 获取排号提醒未读消息数量 */
+(RACSignal *)queueMessageNumber{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kuserid : KMUserDefault.userID}, nil];
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetRemindNumber]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 获取回馈的详细内容 */
+(RACSignal *)feedbackInfoWithMsgID:(NSString *)msgID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"messageId" : msgID}, nil];
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetFeedbackInfoById]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 获取通知信息接口 */
+(RACSignal *)remindInfoWithPage:(NSInteger)page{
    
    page = page == 0 ? 1 : page;
    
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : KMUserDefault.userID}, @{@"pageindex" : @(page)}, nil];
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetRemindInfo]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 动态消息未读数量 */
+(RACSignal *)dynamicNumber{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kuserid : KMUserDefault.userID}, nil];
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetMessageReminderNumber]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 未读消息 */
+(RACSignal *)messageNumber{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kuserid : KMUserDefault.userID}, nil];
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetMessageNumber]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 删除消息 */
+(RACSignal *)deleMessageWithMsgID:(NSString *)msgID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"id" : msgID}, nil];
    
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileDeleteRemind]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

#pragma mark - 队列
/** 我的队列列表 */
+(RACSignal *)userGroupInfo{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetUserGroupInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 判断队列是否被当前用户收藏 */
+(RACSignal *)checkCollectionStatusWithGroupId:(NSString *)groupID{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetCollectionInfoByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 收藏队列 */
+(RACSignal *)addCollectionWithGroupID:(NSString *)groupID{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    NSDictionary *params                                                                                                                                                       = @{kUserId : userId, kGroupId : groupID};
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddCollectionInfo]
                                                             paramsSet:@[]
                                                              entrySet:@[params]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 取消收藏 */
+(RACSignal *)cancelCollectionWithColID:(NSString *)colID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"id" : colID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelCollectionInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 加载队列详细信息 */
+(RACSignal *)groupDetailInfoWithID:(NSString *)groupID{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetGroupDetailedInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}

/** 加载队列排队信息 */
+(RACSignal *)queueDataByGroupID:(NSString *)groupID WinID:(NSString *)winID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{kSingleNumber : @"0"}, @{kWindowId : winID ? winID :@""}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetQueueDataByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    //GetQueueDataByGroupIds   GetQueueDataByGroupId
    return [KM_NetworkClient requestParams:finalParams];
}


/**
 首页--景区等--进入排号详情

 @param groupID <#groupID description#>
 @param winID <#winID description#>
 @return <#return value description#>
 */
+ (RACSignal *)screenqueueDetailByGroundId:(NSString *)groupID WinID:(NSString *)winID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{kSingleNumber : @"0"}, @{kWindowId : winID ? winID :@""}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetScreenDataDetailByGroupId]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 窗口分配--加载当前用户名下未分配的窗口 */
+(RACSignal *)unabsorbedWindow{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetWindowInfoByUserIdEx]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 获取当前队列已经绑定的窗口列表 窗口解绑列表 */ //GetWindowInfoByGroupIdEx
+(RACSignal *)windowWithGroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetWindowInfoByGroupIdEx]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 呼叫选择窗口列表 */
+(RACSignal *)bindedWindowWithGroupID:(NSString *)groupID{
    
    //获取唯一标识
    NSString *UUID = [KMTool UUID];
    
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{@"identification" : UUID ? UUID : @""}, nil]; 
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetWindowInfoByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 队列绑定窗口 */
+(RACSignal *)bindWindow:(NSString *)windowID Group:(NSString *)groupID{
    NSArray *entrySet                                                                                                                                                          = @[@{kGroupId : groupID, kWindowId : windowID}];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddWindowGroupEx]
                                                             paramsSet:nil
                                                              entrySet:entrySet];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}

/** 设置当前呼叫窗口（设置当前叫号窗口的窗口号，进行呼叫） */
+(RACSignal *)bindCallWindowWithWindowID:(NSString *)windowID{

    //获取唯一标识
    NSString *UUID = [KMTool UUID];
    
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"windowId" : windowID}, @{@"identification" : UUID ? UUID : @""}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditWindowStatus]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 队列解绑窗口 窗口ID串，多个以3个“#”分割 */
+(RACSignal *)unbindWindow:(NSString *)windowID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kWindowId : windowID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelWindowGroupEx]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams Cache:YES];
}
/** 搜索队列 */
+(RACSignal *)searchGroupWithKeyword:(NSString *)keyword Index:(NSInteger)index{

    NSString *locationCity                                                                                                                                                     = [NSUserDefaults stringForKey:kLocationCity];
    NSString *currentCity                                                                                                                                                      = [NSUserDefaults stringForKey:kCurrentCity];
    NSString *city                                                                                                                                                             = currentCity ? currentCity : locationCity;
    CLLocation *location                                                                                                                                                       = [KMLocationManager shareInstance].myLocation;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys: @{kKeyword : keyword},
                                                        @{kProv : @""},
                                                        @{kCity : city ? city : @""},
                                                        @{kDist : @""},
                                                        @{kCategory : @""},
                       @{@"pageindex" : index == 0 ? @(1) : @(index)},
                       @{@"longitude":location?@(location.coordinate.longitude):@(0)},
                       @{@"latitude":location?@(location.coordinate.latitude):@(0)},
                       @{@"status":@(-1)},
                                                        nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetSearchGroup]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 过号 */
+(RACSignal *)singleExpireWithQueueID:(NSString *)queueID
                              GroupID:(NSString *)groupID{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kCurrentqueueid : queueID}, @{kGroupId : groupID}, @{kWorkerId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName SingleExpireNo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 呼叫当前 */
+(RACSignal *)callCurrentWithQueueID:(NSString *)queueID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"queueid" : queueID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName CallCurrent]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 下一位 */
+(RACSignal *)callNextWithQueueID:(NSString *)queueID
                          GroupID:(NSString *)groupID{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kCurrentqueueid : queueID}, @{kGroupId : groupID}, @{kWorkerId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName SingleCallNext]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 暂停 */
+(RACSignal *)suspendWithQueueID:(NSString *)queueID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kQueueId : queueID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName Suspend]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 解散 */
+(RACSignal *)disbandWithGroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName Disband]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 现场排号 */
+(RACSignal *)sceneQueueWithGrouoID:(NSString *)groupID UserID:(NSString *)userID{
    NSDictionary *params                                                                                                                                                       = @{@"tickets" : @"1"};
    NSDictionary *entry                                                                                                                                                        = @{kUserId : userID, kGroupId : groupID};
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName SceneQueue]
                                                             paramsSet:@[params]
                                                              entrySet:@[entry]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 获取票据信息 */
+(RACSignal *)billInfoWithGroupID:(NSString *)groupID BespeakSort:(NSString *)bespeakSort{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{@"bespeakSort" : bespeakSort}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetBillInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 删除队列 */
+(RACSignal *)deleGroupWithID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelGroupInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}


/** 加载续建信息 */
+(RACSignal *)groupTimeInfoWithGroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetTimeIntervalByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 也是加载续建信息 */
+(RACSignal *)groupAutoTimeInfoWithGroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetAutomaticInfoByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 手动续建 */
+(RACSignal *)editGroupWaitTimeWithData:(RACTuple *)data{
    RACTupleUnpack(NSString *groupID, NSString *start, NSString *end)                                                                                                          = data;

    NSDictionary *parmas                                                                                                                                                       = @{@"id" : groupID,
                             kStartWaitTime : start,
                             kEndWaitTime : end
                             };
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditGroupInfoTime]
                                                             paramsSet:@[]
                                                              entrySet:@[parmas]];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 提交 自动续建 */
+(RACSignal *)editAutoGroupTimeWithData:(NSDictionary *)data{
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AutomaticSetting]
                                                             paramsSet:@[]
                                                              entrySet:@[data]];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 加载原来的队列信息 */
+(RACSignal *)originalGroupInfoWithID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetGroupInfoByID]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 新建队列 */
+(RACSignal *)addNewGroupWithData:(NSDictionary *)data{
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddGroupInfo]
                                                             paramsSet:@[]
                                                              entrySet:@[data]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 编辑队列 */
+(RACSignal *)editGroupInfoWithData:(NSDictionary *)data{
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditGroupInfoEx]
                                                             paramsSet:@[]
                                                              entrySet:@[data]];
    NSString *params                                                                                                                                                           = [finalParams objectForKey:@"json"];
//    AFURLSessionManager
//    params = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [KM_NetworkClient requestWithNetworkConfig:^KM_NetworkConfig *(KM_NetworkConfig *config) {
    config.HttpMethod                                                                                                                                                          = KM_POST;
        return config;
    } AFManagerSetting:^AFHTTPSessionManager *(AFHTTPSessionManager *manager) {
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI                                                                                                               = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
        return manager;
    } URLString:nil Params:params];
//    return [KM_NetworkClient requestWithNetworkConfig:^KM_NetworkConfig *(KM_NetworkConfig *config) {
//        config.HttpMethod = KM_POST;
//        return config;
//    } URLString:nil Params:[params modelToJSONData]];
}

#pragma mark - 批量叫号
/** 批量叫号 排队列表信息 */ //GetQueueDataByGroupIds
+(RACSignal *)batchQueueDataWithGroupID:(NSString *)groupID
                                 Number:(NSInteger)number
                               WindowID:(NSString *)windowID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{@"singleNumber" : @(number)}, @{@"windowId" : windowID ? windowID : @""}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetQueueDataByGroupIds]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 批量叫号 结束上一批 */
+(RACSignal *)batchEndLastWithQueueIDs:(NSString *)queueIDs GroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"currentqueueid" : queueIDs}, @{@"groupid" : groupID}, @{@"workerId" : KMUserDefault.userID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MultipleCallNext]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 批量暂停 */
+(RACSignal *)batchSuspendWithQueueIDs:(NSString *)queueIDs{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"queueId" : queueIDs}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MultipleSuspend]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 加载数据成功后修改列表中数据状态为办理中 */
+(RACSignal *)editQueueStateWithQueueIDs:(NSString *)queueIDs WinID:(NSString *)winID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"queueId" : queueIDs}, @{@"CurrentWinVal" : winID ? winID : @""}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditBatchState]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
#pragma mark - 排号
/** 查看是否已经排队 */
+ (RACSignal *)checkQueueInfo:(NSString *)groupID{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{kUserId : userId}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName CheckQueueInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 队列信息 */
+(RACSignal *)groupInfoWithGroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetGroupInfoByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 获取队列评论信息 */
+(RACSignal *)commentListWithGroupId:(NSString *)groupID{

    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetGroupCommentByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 参加排号 */
+(RACSignal *)joinQueueWithGroupID:(NSString *)groupID
                           isVoice:(BOOL)isVoice
                             isSms:(BOOL)isSms
                           minutes:(NSNumber *)minutes{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;

    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kTickets : @"1"}, nil];

    NSDictionary *entry                                                                                                                                                        = @{
                            kUserId : userId,
                            kGroupId : groupID,
                            @"isVoice" : isVoice ? @1 : @0,
                            @"isSms" : isSms ? @1 : @0,
                            @"minutes" : minutes ? minutes : @0
                            };

    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddQueueInfo]
                                                             paramsSet:params
                                                              entrySet:@[entry]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 套餐参加排号 */
+(RACSignal *)joinQueueWithPackageID:(NSString *)packageID{
    NSString *userId                                                                                                                                                           = KMUserDefault.userID;

    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{kPackageID : packageID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName PackageQueue]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 为他人进行套餐排队 */
+(RACSignal *)joinQueueWithPackageID:(NSString *)packageID
                              UserID:(NSString *)userID {
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userID}, @{kPackageID : packageID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName PackageQueue]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 退出排号 参数 userID groupID */
+(RACSignal *)exitQueueWithGroupID:(NSString *)groupID{

    NSString *userId                                                                                                                                                           = KMUserDefault.userID;
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : userId}, @{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName ExitQueue]
                                                             paramsSet:params
                                                                entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 退出排号 参数 queueID */
+(RACSignal *)exitQueueWithQueueID:(NSString *)queueID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kQueueId : queueID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName ExitQueueEx]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

/** 我的排队详情 */
+(RACSignal *)queueDetailWithQueueID:(NSString *)queueID
                             GroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{kQueueId : queueID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetScreenDataByGroupId]
                                                             paramsSet:params
                                                              entrySet:nil];
    //GetScreenDataByGroupId
    return [KM_NetworkClient requestParams:finalParams];
}
/** 我的排队详情---获取当前排队号，需等候时间 */
+ (RACSignal *)queueDetailInfoWithQueueID:(NSString *)queueID
                              GroupID:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, @{kQueueId : queueID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetQueueDetailed]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    //GetScreenDataByGroupId
    return [KM_NetworkClient requestParams:finalParams];
}


/** 提交评论 */
+(RACSignal *)addCommentWithQueueID:(NSString *)queueID
                              Score:(NSNumber *)score
                            Comment:(NSString *)comment{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kQueueId : queueID}, @{kScore : NSStringFormat(@"%@",score)}, @{kComment : comment}, @{@"isAnonymous" : @"0"}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddComment]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}

#pragma mark - 套餐
/** 通过队列ID获取套餐信息 */
+(RACSignal *)packageLists:(NSString *)groupID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kGroupId : groupID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetPackageLists]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 获取用户套餐信息 */
+(RACSignal *)userPackageList{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : KMUserDefault.userID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName GetGroupPackageByUserId]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 新增套餐 */
+(RACSignal *)addGroupPackage:(NSDictionary *)param{
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName AddGroupPackage]
                                                             paramsSet:@[]
                                                              entrySet:@[param]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 删除套餐 */
+(RACSignal *)delePackageWithPackageID:(NSString *)packageID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{@"packageid" : packageID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName DelGroupPackage]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 编辑套餐页面数据 */
+(RACSignal *)waitEditPackageInfo:(NSNumber *)packageID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : KMUserDefault.userID}, @{kPackageID : packageID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetEditPackageInfo]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 提交修改套餐数据 */
+(RACSignal *)editPackageWith:(NSDictionary *)param{
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName EditGroupPackage]
                                                             paramsSet:@[]
                                                              entrySet:@[param]];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 套餐进度 */
+(RACSignal *)packageSchedule:(NSString *)packageID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : KMUserDefault.userID}, @{@"packageId" : packageID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName MobileGetPackageSchedule]
                                                             paramsSet:params
                                                              entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
/** 判断套餐中队列是否有的已经排队 */
+(RACSignal *)checkPackageWithID:(NSString *)packageID{
    //转换成后台需要的格式
    NSArray *params                                                                                                                                                            = [KMTool weirdDictWithDictionarys:@{kUserId : KMUserDefault.userID}, @{@"packageId" : packageID}, nil];
    //再加上其他网络请求参数
    NSDictionary *finalParams                                                                                                                                                  = [KM_NetworkParams paramsWithActionName:[KM_NetworkActionName CheckPackage]
                                                                                                                                                                                                              paramsSet:params
                                                                                                                                                                                                               entrySet:nil];
    return [KM_NetworkClient requestParams:finalParams];
}
@end
