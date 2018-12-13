//
//  KM_NotificationMacors.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#ifndef KM_NotificationMacors_h
#define KM_NotificationMacors_h

#define kNotificationCenter [NSNotificationCenter defaultCenter]

//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];


#endif /* KM_NotificationMacors_h */
