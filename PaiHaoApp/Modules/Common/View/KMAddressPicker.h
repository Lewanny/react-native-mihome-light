//
//  KMAddressPicker.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/22.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ActionSheetPicker_3_0/ActionSheetCustomPicker.h>

typedef void(^AddressCallBack)(NSString *province, NSString *city, NSString *area);

@interface KMAddressPicker : UIView

+(void)showWithCallBack:(AddressCallBack)callBack;

@end
