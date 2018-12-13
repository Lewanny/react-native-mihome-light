//
//  KMMessageDetailVC.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/14.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMessageDetailVC.h"
#import "KMSystemShareTool.h"
@interface KMMessageDetailVC ()

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation KMMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - KMBaseViewControllerDataSource

-(UIButton *)set_rightButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setImage:IMAGE_NAMED(@"fxiang") forState:UIControlStateNormal];
    return btn;
}
-(void)right_button_event:(UIButton *)sender{
    NSString *textToShare = _messageUrl;
    NSURL *urlToShare = [NSURL URLWithString:_messageUrl];
    [KMSystemShareTool shareWithURL:urlToShare Text:textToShare Image:nil];
}

#pragma mark - BaseViewControllerInterface -
-(void)km_addSubviews{
    _webView                 = [[UIWebView alloc]initWithFrame:CGRectMake(0, kNavHeight, KScreenWidth, KScreenHeight - kNavHeight)];
    _webView.scalesPageToFit = YES;
    _messageUrl.length ? [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.messageUrl]]] : nil;
    [self.view addSubview:_webView];
}

#pragma mark - Lazy -

@end
