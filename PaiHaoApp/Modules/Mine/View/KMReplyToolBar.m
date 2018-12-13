//
//  KMReplyToolBar.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMReplyToolBar.h"

@interface KMReplyToolBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textF;

@property (nonatomic, strong) UIButton * replyBtn;

@end

@implementation KMReplyToolBar

+(instancetype)toolBar{
    KMReplyToolBar *toolBar = [[KMReplyToolBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kReplyToolBarH)];
    [toolBar km_addSubviews];
    return toolBar;
}

-(void)km_addSubviews{
    _textF                  = [[UITextField alloc]initWithFrame:CGRectMake(AdaptedWidth(24), 8, KScreenWidth - AdaptedWidth(24) - kReplyBtnW, kReplyToolBarH - 16)];
    [_textF setPlaceholder:@"写回复"];
    [_textF setTextColor:kFontColorDark];
    [_textF setFont:kFont26];
    [_textF setTextAlignment:NSTextAlignmentCenter];
    [_textF setBackgroundColor:kBackgroundColor];
    [_textF cornerRadius:_textF.height/2.0 strokeSize:0.5 color:kFontColorLightGray];
    [_textF setReturnKeyType:UIReturnKeySend];
    _textF.delegate         = self;
    [self addSubview:_textF];

    _replyBtn               = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyBtn setFrame:CGRectMake(_textF.right, 0, kReplyBtnW, kReplyToolBarH)];
    [_replyBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_replyBtn setTitleColor:kFontColorGray forState:UIControlStateNormal];
    [_replyBtn.titleLabel setFont:kFont32];
    @weakify(self)
    [[[_replyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.sendSubject sendNext:self.textF.text];
    }];
    [self addSubview:_replyBtn];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.sendSubject sendNext:textField.text];
    return YES;
}

-(RACSubject *)sendSubject{
    if (!_sendSubject) {
    _sendSubject            = [RACSubject subject];
    }
    return _sendSubject;
}

@end
