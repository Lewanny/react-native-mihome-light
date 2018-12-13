//
//  KMRegProtocolVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/6.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMRegProtocolVC.h"

#define kProtocolUrl @"http://www.paihao123.com/registrationprotocol.html"

//http://www.paihao123.com/registrationprotocol.html
@interface KMRegProtocolVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation KMRegProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - KMBaseViewControllerDataSource -
-(NSMutableAttributedString *)setTitle{
    return KMBaseNavTitle(@"用户注册协议");
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight)];
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kProtocolUrl]]];
    [self.view addSubview:_webView];
}

@end
