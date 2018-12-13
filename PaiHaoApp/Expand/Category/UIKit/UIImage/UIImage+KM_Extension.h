//
//  UIImage+KM_Extension.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/6.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KM_Extension)
/**
 *  读取图片中二维码信息
 *
 *  @param image 图片
 *
 *  @return 二维码内容
 */
+(NSString *)readQRCodeFromImage:(UIImage *)image;

@end
