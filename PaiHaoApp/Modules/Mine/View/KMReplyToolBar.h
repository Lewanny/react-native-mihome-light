//
//  KMReplyToolBar.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/15.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kReplyToolBarH 50

#define kReplyBtnW 60

@interface KMReplyToolBar : UIToolbar

@property (nonatomic, strong, readonly) UITextField * textF;

@property (nonatomic, strong) RACSubject * sendSubject;

+(instancetype)toolBar;

@end
