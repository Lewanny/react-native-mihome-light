//
//  KMBluetoothManager.h
//  PaiHaoApp
//
//  Created by KM on 2017/9/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMBluetoothConst.h"
@interface KMBluetoothManager : NSObject

#pragma mark - Property -

/** 断开连接的回调 */
@property (nonatomic, copy) KM_DisconnectPeripheralBlock disconnectPeripheralBlock;

@property (nonatomic, readonly, strong) CBPeripheral     *connectedPerpheral;  /**< 当前连接的外设 */

@property (nonatomic, readonly, strong) CBCentralManager *centralManager;      /**< 中心管理器 */

/**
 * 每次发送的最大数据长度，因为部分型号的蓝牙打印机一次写入数据过长，会导致打印乱码。
 * iOS 9之后，会调用系统的API来获取特性能写入的最大数据长度。
 * 但是iOS 9之前需要自己测试然后设置一个合适的值。默认值是146，我使用佳博58MB-III的限度。
 * 所以，如果你打印乱码，你考虑将该值设置小一点再试试。
 */
@property (assign, nonatomic)   NSInteger               limitLength;

/** 是否连接成功后停止扫描蓝牙设备 */
@property (nonatomic, assign) BOOL                      stopScanAfterConnected;

/**
 需要判断KM_OptionStage来进行打印，如果只是连接 不需要关心，
 */
@property (nonatomic, assign) KM_OptionStage stage;

#pragma mark - Method -

/** 单例方法 */
+ (instancetype)sharedInstance;

/**
 开始扫描蓝牙外设，block方式返回结果
 @param success 扫描成功的回调
 @param failure 扫描失败的回调
 
 */
- (void)beginScanPerpheralSuccess:(KM_ScanPerpheralsSuccess)success failure:(KM_ScanPeripheralFailure)failure;

/**
 连接蓝牙外设，连接成功后会停止扫描蓝牙外设，block方式返回结果
 
 @param peripheral 要连接的蓝牙外设
 @param completion 连接成功回调(有成功 跟失败判断error是否为空就可以了)
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(KM_ConnectCompletionBlock)completion;

/**
 自动连接上次连接的蓝牙
 //因为使用自动连接的话同样也会扫描设备  所以如果单一只是想要连接外设，用此API就可以了
 
 @param completion 连接成功回调(有成功 跟失败判断error是否为空就可以了)
 */
- (void)autoConnectLastPeripheralCompletion:(KM_ConnectCompletionBlock)completion;

/**
 *  停止扫描设备
 */
- (void)stopScanPeripheral;

/**
 取消某个设备的连接
 
 @param peripheral 设备
 */
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

/**
 进行打印
 
 @param data 打印数据
 @param result 结果回调
 */
- (void)sendPrintData:(NSData *)data completion:(KM_PrintResultBlock)result;

/** 获取错误提示 */
+ (NSString *)bluetoothErrorInfo:(CBManagerState)status;
/** 获取设备连接状态提示 */
+ (NSString *)peripheralStateStringWith:(CBPeripheralState)state;
/** 判断是否可以打印 有连接设备 而且已到 搜索特性阶段 */
+ (BOOL)canPrint;
/** 设置打印份数 */
+ (void)setPrintCount:(NSInteger)count;
/** 获取打印份数 */
+(NSInteger)printCount;
@end
