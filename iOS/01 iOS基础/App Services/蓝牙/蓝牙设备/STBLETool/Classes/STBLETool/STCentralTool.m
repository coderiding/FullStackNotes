 //
//  STBLETool.m
//  STBLETool
//
//  Created by TangJR on 3/16/16.
//  Copyright © 2016 tangjr. All rights reserved.
//

#import "STCentralTool.h"

#define ST_ERROR(description) [NSError errorWithDomain:@"com.saitjr" code:0 userInfo:@{NSLocalizedDescriptionKey:description}]

@interface STCentralTool () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;

@property (strong, nonatomic) NSMutableArray *discoveredPeripherals; // 找到的所有的 Peripheral
@property (strong, nonatomic) CBPeripheral *connectedPeripheral; // 当前已经连接的 Peripheral
@property (strong, nonatomic) CBPeripheral *lastConnectedPeripheral; ///< 上一次连接上的 Peripheral，用来做自动连接时，保存强引用
@property (strong, nonatomic) NSMutableArray *readCharacteristics; ///< 连接的所有 characteristic，主要用于断开连接时，取消 notify 监听

@property (strong, nonatomic) NSTimer *timeoutTimer;

@property (copy, nonatomic) NSArray *serviceUUIDArray; ///< 将允许搜索的 service UUID 打包为数组 CBUUID 类型
@property (copy, nonatomic) NSArray *characteristicUUIDArray; ///< 将允许搜索的 characteristic UUID 打包为数组 CBUUID 类型

@property (assign, nonatomic) BOOL isOTA; ///< 记录当前的数据写入方式，用于判断写入成功应该走哪个代理的回调
@property (assign, nonatomic) NSInteger otaSubDataOffset; ///< 已经写入的数据长度
@property (copy, nonatomic) NSData *otaData; ///< 记录 ota 传输的 data，因为 ota 文件比较大，需要切割然后不停的传

@end

@implementation STCentralTool

static NSString * const ServiceUUIDString1 = @"XXXX";
static NSString * const ServiceUUIDString2 = @"XXXXXXXX-0000-1000-8000-XXXXXXXXXXXX";
static NSString * const CharacteristicReadUUIDString1 = @"003784CF-F7E3-55B4-6C4C-XXXXXXXXXXXX";
static NSString * const CharacteristicWriteUUIDString1 = @"D44BC439-ABFD-45A2-B575-XXXXXXXXXXXX";
static NSString * const CharacteristicWriteUUIDString2 = @"D44BC439-ABFD-45A2-B575-XXXXXXXXXXXX";

static NSString * const LastPeriphrealIdentifierConnectedKey = @"LastPeriphrealIdentifierConnectedKey";

static const NSTimeInterval STCentralToolTimeOut = 5.0; ///< 超时时长，如果 <= 0 则不做超时处理
static const BOOL STCentralToolAutoConnect = YES;
static const NSInteger STCentralToolOTADataSubLength = 20; ///< OTA 每次发送字节的长度

#pragma mark - Left Cycle

+ (instancetype)shareInstence {
    static STCentralTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [STCentralTool new];
    });
    return tool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        // 如果设置了自动连接
        if (STCentralToolAutoConnect) {
            // 这里需要延迟 0.1s 才能走连接成功的代理，具体原因未知
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self autoConnect];
            });
        }
    }
    return self;
}

#pragma mark - Public Methods

- (void)startScan {
    [self.discoveredPeripherals removeAllObjects];
    [self.centralManager scanForPeripheralsWithServices:self.serviceUUIDArray options:nil];
    [self startTimer];
}

- (void)stopScan {
    [self.centralManager stopScan];
}

- (void)selectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral options:nil];
    [self stopScan];
    [self startTimer];
}

- (void)sendData:(NSData *)data toCharacteristic:(CBCharacteristic *)toCharacteristic {
    if (!toCharacteristic || !self.isConnected) {
        return;
    }
    if (data == nil || data.length == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:writeFinishWithError:)]) {
            NSError *error = ST_ERROR(STCentralErrorWriteDataLength);
            [self.delegate centralTool:self writeFinishWithError:error];
        }
        return;
    }
    self.isOTA = NO;
    [self.connectedPeripheral writeValue:data forCharacteristic:toCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)otaUpdateData:(NSData *)data toCharacteristic:(CBCharacteristic *)toCharacteristic {
    if (!toCharacteristic || !self.isConnected) {
        return;
    }
    if (data == nil || data.length == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:otaWriteFinishWithError:)]) {
            NSError *error = ST_ERROR(STCentralErrorWriteDataLength);
            [self.delegate centralTool:self otaWriteFinishWithError:error];
        }
        return;
    }
    self.isOTA = YES;
    self.otaSubDataOffset = 0;
    self.otaData = data;
    [self sendOTAWriteToCharacteristic:toCharacteristic];
}

- (void)disconnectWithPeripheral:(CBPeripheral *)peripheral {
    for (CBCharacteristic *characteristic in self.readCharacteristics) {
        [self.connectedPeripheral setNotifyValue:NO forCharacteristic:characteristic];
    }
    [self.centralManager cancelPeripheralConnection:self.connectedPeripheral];
    self.connectedPeripheral = nil;
}

#pragma mark - Private Methods

// 自动连接
- (void)autoConnect {
    // 取出上次连接成功后，存的 peripheral identifier
    NSString *lastPeripheralIdentifierConnected = [[NSUserDefaults standardUserDefaults] objectForKey:LastPeriphrealIdentifierConnectedKey];
    // 如果没有，则不做任何操作，说明需要用户点击开始扫描的按钮，进行手动搜索
    if (lastPeripheralIdentifierConnected == nil || lastPeripheralIdentifierConnected.length == 0) {
        return;
    }
    // 查看上次存入的 identifier 还能否找到 peripheral
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:lastPeripheralIdentifierConnected];
    NSArray *peripherals = [self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
    // 如果不能成功找到或连接，可能是设备未开启等原因，返回连接错误
    if (peripherals == nil || [peripherals count] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
            NSError *error = ST_ERROR(STCentralErrorConnectAutoConnectFail);
            [self.delegate centralTool:self connectFailure:error];
        }
        return;
    }
    // 如果能找到则开始建立连接
    CBPeripheral *peripheral = [peripherals firstObject];
    [self.centralManager connectPeripheral:peripheral options:nil];
    // 注意保留 Peripheral 的引用
    self.lastConnectedPeripheral = peripheral;
    [self startTimer];
}

#pragma mark - Timer

- (void)startTimer {
    [self stopTimer];
    if (STCentralToolTimeOut <= 0) {
        return;
    }
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:STCentralToolTimeOut target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
}

- (void)stopTimer {
    if (STCentralToolTimeOut <= 0) {
        return;
    }
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

- (void)timeOut {
    if (STCentralToolTimeOut <= 0) {
        return;
    }
    [self stopScan];
    if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
        NSError *error = ST_ERROR(STCentralErrorConnectTimeOut);
        [self.delegate centralTool:self connectFailure:error];
    }
}

#pragma mark - CBCentralManagerDelegate

// 最新设备的 central 状态，一般用于检测是否支持 central
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // CBCentralManagerStatePoweredOn 是唯一正常的状态
    if (central.state == CBCentralManagerStatePoweredOn) {
        return;
    }
    // 其他状态都是错的
    if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
        // 如果蓝牙关闭了
        if (central.state == CBCentralManagerStatePoweredOff) {
            NSError *error = ST_ERROR(STCentralErrorConnectPowerOff);
            [self.delegate centralTool:self connectFailure:error];
            return;
        }
        // 还有当前设备不支持、未知错误等，统一为其它错误
        NSError *error = ST_ERROR(STCentralErrorConnectOthers);
        [self.delegate centralTool:self connectFailure:error];
    }
}

// 找到设备时调用，每找到一个就调用一次
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [self stopTimer];
    // 将找到的 peripheral 存入数组
    if (![self.discoveredPeripherals containsObject:peripheral]) {
        [self.discoveredPeripherals addObject:peripheral];
    }
    // 找到设备的回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:findPeripherals:)]) {
        [self.delegate centralTool:self findPeripherals:[self.discoveredPeripherals copy]];
    }
}

// 成功连接到某个设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self stopTimer];
    peripheral.delegate = self;
    self.connectedPeripheral = peripheral;
    [peripheral discoverServices:self.serviceUUIDArray];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectSuccess:)]) {
        [self.delegate centralTool:self connectSuccess:peripheral];
    }
}

// 连接失败（但不包含超时，系统没有超时处理）
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error && self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
        [self.delegate centralTool:self connectFailure:error];
    }
}

#pragma mark - CBPeripheralDelegate

// 搜索到 Service （或失败）
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
            [self.delegate centralTool:self connectFailure:error];
        }
        return;
    }
    for (CBService *service in peripheral.services) {
        // 对比是否是需要的 service
        if (![self.serviceUUIDArray containsObject:service.UUID]) {
            continue;
        }
        // 如果找到了，就继续找 characteristic
        [peripheral discoverCharacteristics:self.characteristicUUIDArray forService:service];
    }
}

// 搜索到 Characteristic （或失败）
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
            [self.delegate centralTool:self connectFailure:error];
        }
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        // 对比是否是需要的 characteristic
        if (![self.characteristicUUIDArray containsObject:characteristic.UUID]) {
            continue;
        }
        // 找到可读的 characteristic，就自动读取数据
        if (characteristic.properties & CBCharacteristicPropertyNotify) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [self.readCharacteristics addObject:characteristic];
        }
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
            if ([characteristic.UUID.UUIDString isEqual:CharacteristicWriteUUIDString1]) {
                _writeCharacteristic = characteristic;
            }
        }
    }
}

// 读到 Characteristic 的数据的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
            [self.delegate centralTool:self connectFailure:error];
        }
        return;
    }
    NSData *value = characteristic.value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:recievedData:)]) {
        [self.delegate centralTool:self recievedData:value];
    }
}

// 设置数据订阅成功（或失败）
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:connectFailure:)]) {
            [self.delegate centralTool:self connectFailure:error];
        }
        return;
    }
}

// 接收到数据写入结果的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    // 如果是 OTA，则判断错误，无错就继续截取发送
    if (self.isOTA) {
        [self otaDataWriteValueWithError:error characteristic:characteristic];
        return;
    }
    // 如果不是 OTA，并且设置了代理
    if (!self.isOTA && self.delegate && [self.delegate respondsToSelector:@selector(centralTool:writeFinishWithError:)]) {
        [self.delegate centralTool:self writeFinishWithError:error];
        return;
    }
}

#pragma mark - Send Data Loop

// 处理 ota 的写入回调，错误则直接回调返回，正确则继续截取数据并发送
- (void)otaDataWriteValueWithError:(NSError *)error characteristic:(CBCharacteristic *)characteristic {
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:otaWriteFinishWithError:)]) {
            [self.delegate centralTool:self otaWriteFinishWithError:error];
        }
        return;
    }
    // 将已发送的数据长度回调回去
    if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:otaWriteLength:)]) {
        [self.delegate centralTool:self otaWriteLength:self.otaSubDataOffset];
    }
    [self sendOTAWriteToCharacteristic:characteristic];
}

// 将截取的数据发送出去
- (void)sendOTAWriteToCharacteristic:(CBCharacteristic *)characteristic {
    NSData *data = [self subOTAData];
    self.otaSubDataOffset += data.length;
    if (data == nil || data.length == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(centralTool:otaWriteFinishWithError:)]) {
            [self.delegate centralTool:self otaWriteFinishWithError:nil];
        }
        return;
    }
    [self.connectedPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

// 截取数据，因为蓝牙传输的数据单次有大小限制
- (NSData *)subOTAData {
    NSInteger totalLength = self.otaData.length;
    NSInteger remainLength = totalLength - self.otaSubDataOffset;
    NSInteger rangLength = remainLength > STCentralToolOTADataSubLength ? STCentralToolOTADataSubLength : remainLength;
    return [self.otaData subdataWithRange:NSMakeRange(self.otaSubDataOffset, rangLength)];
}

#pragma mark - Getter / Setter

- (NSMutableArray *)discoveredPeripherals {
    if (!_discoveredPeripherals) {
        _discoveredPeripherals = [NSMutableArray new];
    }
    return _discoveredPeripherals;
}

- (NSMutableArray *)readCharacteristics {
    if (!_readCharacteristics) {
        _readCharacteristics = [NSMutableArray new];
    }
    return _readCharacteristics;
}

- (NSArray *)serviceUUIDArray {
    if (!_serviceUUIDArray) {
        CBUUID *serviceUUID1 = [CBUUID UUIDWithString:ServiceUUIDString1];
        CBUUID *serviceUUID2 = [CBUUID UUIDWithString:ServiceUUIDString2];
        _serviceUUIDArray = @[serviceUUID1, serviceUUID2];
    }
    return _serviceUUIDArray;
}

- (NSArray *)characteristicUUIDArray {
    if (!_characteristicUUIDArray) {
        CBUUID *characteristicUUID1 = [CBUUID UUIDWithString:CharacteristicReadUUIDString1];
        CBUUID *characteristicUUID2 = [CBUUID UUIDWithString:CharacteristicWriteUUIDString1];
        CBUUID *characteristicUUID3 = [CBUUID UUIDWithString:CharacteristicWriteUUIDString2];
        
        _characteristicUUIDArray = @[characteristicUUID1, characteristicUUID2, characteristicUUID3];
    }
    return _characteristicUUIDArray;
}

- (void)setConnectedPeripheral:(CBPeripheral *)connectedPeripheral {
    _connectedPeripheral = connectedPeripheral;
    // 如果当前的 peripheral 不为空 并且 设置了自动连接，则记录 identifier，为自动连接做准备
    if (connectedPeripheral != nil && STCentralToolAutoConnect) {
        [[NSUserDefaults standardUserDefaults] setObject:connectedPeripheral.identifier.UUIDString forKey:LastPeriphrealIdentifierConnectedKey];
    }
}

- (BOOL)isConnected {
    if (self.connectedPeripheral == nil) {
        return NO;
    }
    return self.connectedPeripheral.state == CBPeripheralStateConnected;
}

@end