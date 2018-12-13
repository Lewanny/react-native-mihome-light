//
//  KMGroupQueueDetailUIService.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMGroupQueueDetailVM.h"
@interface KMGroupQueueDetailUIService : NSObject

-(instancetype)initWithTableView:(UITableView *)tableView
                       ViewModel:(KMGroupQueueDetailVM *)viewModel;

//跳转 写评论
@property (nonatomic, strong) RACSubject * pushEvaluateCommitVC;
//跳转 评论列表
@property (nonatomic, strong) RACSubject * pushCommentListVC;
//跳转 套餐选择
@property (nonatomic, strong) RACSubject * pushPackageSeleVC;
@end
