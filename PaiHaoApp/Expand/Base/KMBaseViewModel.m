//
//  KMBaseViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@implementation KMBaseViewModel
- (instancetype)init
{
    self           = [super init];
    if (self) {
        [self km_bindNetWorkRequest];
        [self km_bindOtherEvent];
    }
    return self;
}

-(void)km_bindNetWorkRequest{}
-(void)km_bindOtherEvent{}
-(void)km_canelRequest{}

#pragma mark - Lazy
-(RACSubject *)reloadSubject{
    if (!_reloadSubject) {
    _reloadSubject = [RACSubject subject];
    }
    return _reloadSubject;
}

@end
