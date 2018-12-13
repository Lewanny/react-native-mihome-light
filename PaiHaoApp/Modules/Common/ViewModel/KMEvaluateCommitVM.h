//
//  KMEvaluateCommitVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/8.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMEvaluateCommitVM : KMBaseViewModel
/** 星星数量 */
@property (nonatomic, assign) CGFloat starNum;
/** 内容 */
@property (nonatomic, copy) NSString * comment;
/** 提交评论 */
@property (nonatomic, strong) RACCommand * commitCommand;
/** 评论按钮可点击 */
@property (nonatomic, strong) RACSignal * commitEnableSig;

@end
