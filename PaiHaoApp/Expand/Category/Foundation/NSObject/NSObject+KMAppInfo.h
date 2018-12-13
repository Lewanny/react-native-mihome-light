//
//  NSObject+KMAppInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KMAppInfo)

-(NSString *)km_version;

-(NSInteger)km_build;

-(NSString *)km_identifier;

-(NSString *)km_currentLanguage;

-(NSString *)km_deviceModel;

@end
