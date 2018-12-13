//
//  KMSystemShareTool.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/16.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMSystemShareTool : NSObject

+(void)shareWithURL:(NSURL *)url Text:(NSString *)text Image:(UIImage *)image;

@end
