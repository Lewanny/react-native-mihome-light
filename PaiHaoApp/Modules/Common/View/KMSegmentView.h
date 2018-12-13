//
//  KMSegmentView.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMSegmentViewDelegate <NSObject>
/** 按钮点击回调 */
-(void)segmentViewDidClick:(NSInteger)index;

@end


@interface KMSegmentView : UIView
/** 按钮数组 */
@property (nonatomic, copy, readonly) NSMutableArray * btns;
/** 代理 */
@property (nonatomic, weak) id<KMSegmentViewDelegate>  delegate;
/** 初始化方法 */
-(instancetype)initWithFrame:(CGRect)frame
                      Titles:(NSArray<NSString *> *)titles
            VerticalLineShow:(BOOL)show;

/** 自行调用 初始化选择位置 */
-(void)setSelectedIndex:(NSInteger)index;

@end
