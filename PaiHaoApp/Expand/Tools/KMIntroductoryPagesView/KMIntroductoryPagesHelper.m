//
//  KMIntroductoryPagesHelper.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMIntroductoryPagesHelper.h"

@interface KMIntroductoryPagesHelper ()

@property (nonatomic) UIWindow *rootWindow;

@property(nonatomic,strong)KMIntroductoryPagesView * curIntroductoryPagesView;

@end

@implementation KMIntroductoryPagesHelper

+ (instancetype)shareInstance
{
    static KMIntroductoryPagesHelper *shareInstance                    = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    shareInstance                                                      = [[KMIntroductoryPagesHelper alloc] init];
    });

    return shareInstance;
}

-(instancetype)init
{
    self                                                               = [super init];
    if (self) {

    }
    return self;
}


+(void)showIntroductoryPageView:(NSArray *)imageArray
{
    if (![KMIntroductoryPagesHelper shareInstance].curIntroductoryPagesView) {

    KMIntroductoryPagesView *pasgesView                                = [[KMIntroductoryPagesView alloc]initPagesViewWithFrame:[UIScreen mainScreen].bounds Images:imageArray];
    pasgesView.pageControlHidden                                       = YES;
    [KMIntroductoryPagesHelper shareInstance].curIntroductoryPagesView = pasgesView;
    }

    [KMIntroductoryPagesHelper shareInstance].rootWindow               = [UIApplication sharedApplication].keyWindow;
    [[KMIntroductoryPagesHelper shareInstance].rootWindow addSubview:[KMIntroductoryPagesHelper shareInstance].curIntroductoryPagesView];
}


@end
