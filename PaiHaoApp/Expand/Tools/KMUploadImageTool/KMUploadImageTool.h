//
//  KMUploadImageTool.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/22.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UploadSuccess)(UIImage *uploadImage, NSString *imageUrl);
typedef void(^UploadFailure)(NSError *error);

@interface KMUploadImageTool : NSObject

/**
 单例
 
 @return shareInstance
 */
+ (instancetype)shareInstance;

+(void)uploadWithSuccess:(UploadSuccess)success
                 Failure:(UploadFailure)failure;
@end
