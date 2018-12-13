//
//  KMUserFeedbackViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMUserFeedbackViewModel : KMBaseViewModel
/** 反馈 */
@property (nonatomic, copy) NSString * feedBackText;
/** 最多字数 */
@property (nonatomic, assign) NSInteger  maxTextCount;
/** 允许提交 */
@property (nonatomic, strong) RACSignal * commitEnableSig;

/** 提交反馈 */
@property (nonatomic, strong) RACCommand * feedbackCommand;
- (NSString *)textViwePlaceholder;
//- (NSString *)textFieldPlaceholder;

@end
