//
//  KMGroupCommentModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/9.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupCommentModel.h"

@implementation KMCommentItem

@end

@implementation KMGroupCommentModel

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"commentInfo" : KMCommentItem.class};
}

@end
