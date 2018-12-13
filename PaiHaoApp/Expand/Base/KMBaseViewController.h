//
//  KMBaseViewController.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KM_BaseViewControllerInterface.h"
@protocol  KMBaseViewControllerDataSource<NSObject>

@optional
-(NSMutableAttributedString*)setTitle;
-(UIButton*)set_leftButton;
-(UIButton*)set_rightButton;
-(UIColor*)set_colorBackground;
-(CGFloat)set_navigationHeight;
-(UIView*)set_bottomView;
-(UIImage*)navBackgroundImage;
-(UIImage*)set_leftBarButtonItemWithImage;
-(UIImage*)set_rightBarButtonItemWithImage;


@end


@protocol KMBaseViewControllerDelegate <NSObject>

@optional
-(void)left_button_event:(UIButton*)sender;
-(void)right_button_event:(UIButton*)sender;
-(void)title_click_event:(UIView*)sender;
@end

@interface KMBaseViewController : UIViewController <KMBaseViewControllerDataSource, KMBaseViewControllerDelegate , BaseViewControllerInterface>

-(void)changeNavigationBarTranslationY:(CGFloat)translationY;
-(void)set_Title:(NSMutableAttributedString *)title;
-(void)setNavigationBack:(UIImage*)image;


@end
