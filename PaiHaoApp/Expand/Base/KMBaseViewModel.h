//
//  KMBaseViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KM_BaseViewModelInterface.h"
@interface KMBaseViewModel : NSObject <BaseViewModelInterface>
/** 默认的刷新界面 */
@property (nonatomic, strong) RACSubject * reloadSubject;
@end
