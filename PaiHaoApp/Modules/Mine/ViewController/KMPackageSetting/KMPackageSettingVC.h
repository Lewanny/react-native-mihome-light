//
//  KMPackageSettingVC.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewController.h"
#import "KMPackageVM.h"

typedef NS_ENUM(NSUInteger, PackageSettingStyle) {
    PackageSettingStyleNew = 0, //新建
    PackageSettingStyleEdit     //修改
};

@interface KMPackageSettingVC : KMBaseViewController

@property (nonatomic, strong) KMPackageVM * viewModel;

@property (nonatomic, assign) PackageSettingStyle  style;

@property (nonatomic, assign) NSInteger  packageID;

@end
