//
//  KMBluetoothManager.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBluetoothManager.h"

// 发送数据时，需要分段的长度，部分打印机一次发送数据过长就会乱码，需要分段发送。这个长度值不同的打印机可能不一样，你需要调试设置一个合适的值（最好是偶数）
#define kLimitLength    146

#define kLastPeripheral @"BluetoothPeripheral_uuid"

#define kPrintCount @"PrintCount"


@interface KMBluetoothManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager            *centralManager;        /**< 中心管理器 */
@property (nonatomic, strong) CBPeripheral                *connectedPerpheral;    /**< 当前连接的外设 */

@property (nonatomic, assign) NSInteger         writeCount;   /**< 写入次数 */
@property (nonatomic, assign) NSInteger         responseCount; /**< 返回次数 */


@property (nonatomic, strong) NSMutableArray    *peripherals;             //  搜索到的蓝牙设备数组
@property (nonatomic, strong) NSMutableArray    *rssis;                   //  搜索到的蓝牙设备列表信号强度数组
@property (nonatomic, strong) NSMutableArray    *printeChatactersArray;   //  可以打印的的特性数组

@property (nonatomic, assign) BOOL              autoConnect;              // 是否自动连接


/** 扫描成功回调 */
@property (nonatomic, copy) KM_ScanPerpheralsSuccess  scanPerpheralsSuccess;
/** 扫描失败回调 */
@property (nonatomic, copy) KM_ScanPeripheralFailure  scanPeripheralFailure;
/** 连接完成的回调 */
@property (nonatomic, copy) KM_ConnectCompletionBlock  connectCompletion;
/** 打印结果的回调 */
@property (nonatomic, copy) KM_PrintResultBlock printResult;

@end

static KMBluetoothManager * instance  = nil;

@implementation KMBluetoothManager

#pragma mark - Singleton Medth

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
instance                              = [super init];
        //蓝牙没打开时alert提示框
        [self resetManager];
_limitLength                          = kLimitLength;
    });

    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
instance                              = [super allocWithZone:zone];
    });

    return instance;
}

-(void)resetManager{
_stopScanAfterConnected               = YES;
NSDictionary *options                 = @{CBCentralManagerOptionShowPowerAlertKey:@(YES)};
_centralManager                       = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
    [self.peripherals removeAllObjects];
    [self.rssis removeAllObjects];
    [self.printeChatactersArray removeAllObjects];
_connectedPerpheral                   = nil;
}

#pragma mark - Bluetooth Medthod -
/**
 开始扫描蓝牙外设，block方式返回结果
 @param success 扫描成功的回调
 @param failure 扫描失败的回调

 */
- (void)beginScanPerpheralSuccess:(KM_ScanPerpheralsSuccess)success failure:(KM_ScanPeripheralFailure)failure{
    //block 赋值
_scanPerpheralsSuccess                = success;
_scanPeripheralFailure                = failure;
    if (_centralManager.state == CBManagerStatePoweredOn) {
        //开启搜索
        KMLog(@"开启扫描");
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
        return;
    }
    [self resetManager];
}

#pragma mark - 连接外设 Medthod
- (void)connectPeripheral:(CBPeripheral *)peripheral completion:(KM_ConnectCompletionBlock)completion{
_connectCompletion                    = completion;
    if ([_connectedPerpheral isEqual:peripheral]) {
        return;
    }
    if ( _connectedPerpheral) {
        [self cancelPeripheralConnection:_connectedPerpheral];
    }
    [self connectPeripheral:peripheral];
}
//连接外设设置代理
- (void)connectPeripheral:(CBPeripheral *)peripheral{
    [_centralManager connectPeripheral:peripheral options:nil];
peripheral.delegate                   = self;
}
/**
 自动连接上次连接的蓝牙
 //因为使用自动连接的话同样也会扫描设备  所以如果单一只是想要连接外设，用此API就可以了

 @param completion 连接成功回调(有成功 跟失败判断error是否为空就可以了)
 */
- (void)autoConnectLastPeripheralCompletion:(KM_ConnectCompletionBlock)completion{
_connectCompletion                    = completion;
_autoConnect                          = YES;

    if (_centralManager.state == CBManagerStatePoweredOn) {
        //开启搜索
        KMLog(@"开启扫描");
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

/**
 *  停止扫描设备
 */
- (void)stopScanPeripheral{
    [_centralManager stopScan];
}

/**
 取消某个设备的连接

 @param peripheral 设备
 */
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral{
    if (!peripheral) {
        return;
    }
    //去除次自动连接
    RemoveLastConnectionPeripheral_UUID();

    [_centralManager cancelPeripheralConnection:peripheral];
_connectedPerpheral                   = nil;
    //取消连接 清楚可打印输入
    [_printeChatactersArray removeAllObjects];
}

#pragma mark - CBCentralManagerDelegate
//权限改变重新搜索设备
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state != CBManagerStatePoweredOn) {
        if (_scanPeripheralFailure) {
            _scanPeripheralFailure(central.state);
        }
    }else{
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    KMLog(@"扫描中....");
    if (peripheral.name.length <= 0) {
        return ;
    }

    if (_peripherals.count == 0) {
        [_peripherals addObject:peripheral];
        [_rssis addObject:RSSI];
    } else {
__block BOOL isExist                  = NO;
        //去除相同设备  UUIDString  是每个外设的唯一标识
        [_peripherals enumerateObjectsUsingBlock:^(CBPeripheral *   _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
CBPeripheral *per                     = [_peripherals objectAtIndex:idx];
            if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
isExist                               = YES;
                [_peripherals replaceObjectAtIndex:idx withObject:peripheral];
                [_rssis replaceObjectAtIndex:idx withObject:RSSI];
            }
        }];
        if (!isExist) {
            [_peripherals addObject:peripheral];
            [_rssis addObject:RSSI];
        }
    }
    if (_scanPerpheralsSuccess) {
        _scanPerpheralsSuccess(_peripherals,_rssis);
    }

    if (_autoConnect) {
NSString * uuid                       = GetLastConnectionPeripheral_UUID();
        if ([peripheral.identifier.UUIDString isEqualToString:uuid]) {
peripheral.delegate                   = self;
            [_centralManager connectPeripheral:peripheral options:nil];
        }
    }
}

#pragma mark ---------------- 连接外设成功和失败的代理 ---------------
#pragma mark - 连接外设代理 Medthod
//成功连接
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    //当前设备赋值
_connectedPerpheral                   = peripheral;
    //存入标识符  下次自动
    SetLastConnectionPeripheral_UUID(peripheral.identifier.UUIDString);
    //链接成功 停止扫描
    if (_stopScanAfterConnected) {
        [_centralManager stopScan];
    }
    if (_connectCompletion) {
        _connectCompletion(peripheral,nil);
    }
    //蓝牙连接阶段
_stage                                = KM_OptionStageConnection;
peripheral.delegate                   = self;
    //发现服务 扫描服务
    [peripheral discoverServices:nil];
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if (_connectCompletion) {
        _connectCompletion(peripheral,error);
    }
    //蓝牙连接阶段
_stage                                = KM_OptionStageConnection;
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
_connectedPerpheral                   = nil;
    [_printeChatactersArray removeAllObjects];

    if (_disconnectPeripheralBlock) {
        _disconnectPeripheralBlock(peripheral,error);
    }
_stage                                = KM_OptionStageConnection;
}

#pragma mark ---------------- 发现服务的代理 -----------------
#pragma mark 蓝牙服务代理
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    if (error) {
        KMLog(@"发现服务出错 错误原因-%@",error.domain);
    }else{
        for (CBService *service in peripheral.services) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
_stage                                = KM_OptionStageSeekServices;
}

#pragma mark ---------------- 服务特性的代理 --------------------
#pragma mark 蓝牙服务特性代理
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    if (error) {
        KMLog(@"发现特性出错 错误原因-%@",error.domain);
    }else{
        for (CBCharacteristic *character in service.characteristics) {
CBCharacteristicProperties properties = character.properties;
            if (properties & CBCharacteristicPropertyWrite) {
NSDictionary *dict                    = @{@"character":character,@"type":@(CBCharacteristicWriteWithResponse)};
                [_printeChatactersArray addObject:dict];
            }
        }
    }
    if (_printeChatactersArray.count > 0) {
_stage                                = KM_OptionStageSeekCharacteristics;
    }
}

#pragma mark ---------------- 写入数据的回调 --------------------
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (!_printResult) {
        return;
    }
    _responseCount ++;
    if (_writeCount != _responseCount) {
        return;
    }
    if (error) {
        _printResult(NO,_connectedPerpheral,@"发送失败");
    } else {
        _printResult(YES,_connectedPerpheral,@"已成功发送至蓝牙设备");
    }
}


/**
 进行打印

 @param data 打印数据
 @param result 结果回调
 */
- (void)sendPrintData:(NSData *)data completion:(KM_PrintResultBlock)result{
    if (!self.connectedPerpheral) {
        if (result) {
            result(NO,_connectedPerpheral,@"未连接蓝牙设备");
        }
        return;
    }
    if (self.printeChatactersArray.count == 0) {
        if (result) {
            result(NO,_connectedPerpheral,@"该蓝牙设备不支持写入数据");
        }
        return;
    }
NSDictionary *dict                    = [_printeChatactersArray lastObject];
_writeCount                           = 0;
_responseCount                        = 0;

    // 如果kLimitLength 小于等于0，则表示不用分段发送
    if (kLimitLength <= 0) {
_printResult                          = result;
        [_connectedPerpheral writeValue:data forCharacteristic:dict[@"character"] type:[dict[@"type"] integerValue]];
        _writeCount ++;
        return;
    }

    if (data.length <= kLimitLength) {
_printResult                          = result;
        [_connectedPerpheral writeValue:data forCharacteristic:dict[@"character"] type:[dict[@"type"] integerValue]];
        _writeCount ++;
    } else {
        //分段打印
NSInteger index                       = 0;
for (index                            = 0; index < data.length - kLimitLength; index += kLimitLength) {
NSData *subData                       = [data subdataWithRange:NSMakeRange(index, kLimitLength)];
            [_connectedPerpheral writeValue:subData forCharacteristic:dict[@"character"] type:[dict[@"type"] integerValue]];
            _writeCount++;
        }
_printResult                          = result;
NSData *leftData                      = [data subdataWithRange:NSMakeRange(index, data.length - index)];
        if (leftData) {
            [_connectedPerpheral writeValue:leftData forCharacteristic:dict[@"character"] type:[dict[@"type"] integerValue]];
            _writeCount++;
        }
    }
}

#pragma mark - Error
+ (NSString *)bluetoothErrorInfo:(CBManagerState)status{
NSString * tempStr                    = @"未知错误";
    switch (status) {
        case CBManagerStateUnknown:
tempStr                               = @"未知错误";
            break;
        case CBManagerStateResetting:
tempStr                               = @"正在重置";
            break;
        case CBManagerStateUnsupported:
tempStr                               = @"设备不支持蓝牙";
            break;
        case CBManagerStateUnauthorized:
tempStr                               = @"蓝牙未被授权";
            break;
        case CBManagerStatePoweredOff:
tempStr                               = @"蓝牙关闭";
            break;
        default:
            break;
    }
    return tempStr;
}
/** 获取设备连接状态提示 */
+ (NSString *)peripheralStateStringWith:(CBPeripheralState)state{
NSString * tempStr                    = @"未知状态";
    switch (state) {
        case CBPeripheralStateDisconnected:
tempStr                               = @"已断开";
            break;
        case CBPeripheralStateConnecting:
tempStr                               = @"正在连接";
            break;
        case CBPeripheralStateConnected:
tempStr                               = @"已连接";
            break;
        case CBPeripheralStateDisconnecting:
tempStr                               = @"正在断开";
            break;
        default:
            break;
    }
    return tempStr;
}

#pragma mark - 是否可以打印
/** 判断是否可以打印 有连接设备 而且已到 搜索特性阶段 */
+ (BOOL)canPrint{
KMBluetoothManager *manager           = [KMBluetoothManager sharedInstance];
    if (manager.stage == KM_OptionStageSeekCharacteristics && manager.connectedPerpheral) {
        return YES;
    }
    return NO;
}

/** 设置打印份数 */
+ (void)setPrintCount:(NSInteger)count{
    if (count != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:kPrintCount];
    }
}
/** 获取打印份数 */
+(NSInteger)printCount{
NSInteger count                       = [NSUserDefaults integerForKey:kPrintCount];
    if (count < 1) {
count                                 = 1;
    }
    return count;
}

#pragma mark - Lazy -

- (NSMutableArray *)peripherals{
    if (!_peripherals) {
_peripherals                          = @[].mutableCopy;
    }
    return _peripherals;
}
- (NSMutableArray *)rssis{
    if (!_rssis) {
_rssis                                = @[].mutableCopy;
    }
    return _rssis;
}
-(NSMutableArray *)printeChatactersArray{
    if (!_printeChatactersArray) {
_printeChatactersArray                = @[].mutableCopy;
    }
    return _printeChatactersArray;
}


NSString * GetLastConnectionPeripheral_UUID(){
NSUserDefaults *userDefaults          = [NSUserDefaults standardUserDefaults];
NSString *uuid                        = [userDefaults objectForKey:kLastPeripheral];
    return uuid;
}

void SetLastConnectionPeripheral_UUID(NSString * uuid){
NSUserDefaults *userDefaults          = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:uuid forKey:kLastPeripheral];
    [userDefaults synchronize];
}
void RemoveLastConnectionPeripheral_UUID(){
NSUserDefaults *userDefaults          = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kLastPeripheral];
    [userDefaults synchronize];
}

@end
