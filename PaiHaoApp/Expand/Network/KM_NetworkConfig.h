//
//  KM_NetworkConfig.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KM_NetworkConfig : NSObject
/** 加载动画控制方式，yes表示由发起网络请求的控制，NO表示由KM_NetworkClient类控制 */
@property (nonatomic, assign) BOOL isCtrlHub;
/** HUD 停留时间 0不设置停留时间,请求完成取消 -1不显示HUD 只有 isCtrlHub == YES 时才有用 */
@property (nonatomic, assign) double HUDDuration;
/** 请求方式 */
@property (nonatomic, assign) KM_HTTPMethod HttpMethod;
/** 是否打开缓存 默认是关闭的 */
@property (nonatomic, assign) BOOL  cache;
/** 隐藏HUD */
+(instancetype)hideHUDCofig;
/** 显示HUD */
+(instancetype)showHUDConfig;
/** 外界修改时 用这个 */
+(instancetype)changeConfig;
@end
