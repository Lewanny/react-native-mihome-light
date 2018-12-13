//
//  KMQueueDetail.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/10.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMQueueDetail.h"

@implementation KMQueueItem

@end

@implementation KMQueueDetail
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"QueueDetailed" : [KMQueueItem class]};
}
@end
