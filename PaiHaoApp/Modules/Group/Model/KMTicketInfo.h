//
//  KMTicketInfo.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/4.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMTicketInfo : NSObject
/** 窗口号 */
@property (nonatomic, copy) NSString *windows;
/** 队列名称 业务名称 */
@property (nonatomic, copy) NSString *groupname;
/** 商户名称 */
@property (nonatomic, copy) NSString *businessname;
/** 等待数量 */
@property (nonatomic, copy) NSString *waitcount;
/** 票号 */
@property (nonatomic, copy) NSString *shanxi;
/** 等待时间 */
@property (nonatomic, copy) NSString *waittime;

@end
