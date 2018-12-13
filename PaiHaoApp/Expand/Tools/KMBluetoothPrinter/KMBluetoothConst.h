//
//  KMBluetoothConst.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#pragma mark ------------------- 枚举的定义 --------------------------
// 打印流程:   搜索蓝牙外设 -->连接蓝牙  -->搜索服务 -->搜索特性 -->写入数据 -->打印成功
// 连接上打印机，需要判断扫描的阶段，如果直接进行打印会有可能导致 没有搜索到特性阶段，调用打印API是打印不成功的，所以等待特性回调之后打印 万无一失
typedef NS_ENUM(NSInteger, KM_OptionStage) {
    KM_OptionStageConnection,            //蓝牙连接阶段
    KM_OptionStageSeekServices,          //搜索服务阶段
    KM_OptionStageSeekCharacteristics,   //搜索特性阶段 //注意  只有到达特性阶段才能进行打印
};

#pragma mark ------------------- block的定义 --------------------------
/**
 连接完成的block
 @param peripheral 要连接的蓝牙外设
 */
typedef void(^KM_ConnectCompletionBlock)(CBPeripheral *peripheral, NSError *error);

/** 扫描成功回调 */
typedef void(^KM_ScanPerpheralsSuccess)(NSArray<CBPeripheral *> *peripherals,NSArray<NSNumber *> *rssis);
/** 扫描失败回调 */
typedef void(^KM_ScanPeripheralFailure)(CBManagerState status);

/** 蓝牙断开连接 */
typedef void(^KM_DisconnectPeripheralBlock)(CBPeripheral *perpheral, NSError *error);

/**
 打印之后回调
 
 @param completion 是否完成打印
 @param peripheral 外设
 @param errorString 出错的原因
 */
typedef void(^KM_PrintResultBlock)(BOOL completion, CBPeripheral *peripheral,NSString * errorString);


