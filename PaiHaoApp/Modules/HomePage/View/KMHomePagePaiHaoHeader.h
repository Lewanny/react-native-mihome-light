//
//  KMHomePagePaiHaoHeader.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/19.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMHomePagePaiHaoHeader : KMBaseCollectionReusableView

/** 推荐队列 */
@property (strong, nonatomic) IBOutlet UIButton *recommendBtn;
/** 我的排号 */
@property (strong, nonatomic) IBOutlet UIButton *mineBtn;
/** 查看历史 */
@property (strong, nonatomic) IBOutlet UIButton *historyBtn;
/** 指示 */
@property (strong, nonatomic) IBOutlet UIView *lineView;


@property (nonatomic, strong) RACSubject * btnClickSubject;

-(void)btnClick:(UIButton *)sender;

+(CGFloat)viewHeight;

@end
