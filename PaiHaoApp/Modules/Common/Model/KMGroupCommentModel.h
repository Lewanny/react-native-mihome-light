//
//  KMGroupCommentModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMCommentItem : NSObject
/** 评分 */
@property (nonatomic, assign) CGFloat score;
/** 评论内容 */
@property (nonatomic, copy) NSString * comment;
/** 评论人 */
@property (nonatomic, copy) NSString * raters;
/** 评分时间 */
@property (nonatomic, copy) NSString * scoreTime;
/** 头像 */
@property (nonatomic, copy) NSString * headPortrait;

@end

@interface KMGroupCommentModel : NSObject<YYModel>

/** 平均评分 */
@property (nonatomic, assign) CGFloat  averageScore;
/** 评分人数 */
@property (nonatomic, assign) NSInteger  total;
/** 好评率 */
@property (nonatomic, assign) NSInteger  favorableRate;

@property (nonatomic, copy) NSArray  * commentInfo;

@end
