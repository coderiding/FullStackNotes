---
title: iOS中的蓝牙开发
tags: 蓝牙
categories: 蓝牙
abbrlink: 36409
date: 2017-09-22 12:01:03
---

iOS蓝牙模块支持BLE4.0设备通讯。

在使用蓝牙的过程中，如果是iOS10及以上机型需要在info.plist文件中添加NSBluetoothPeripheralUsageDescription描述字段，向用户声明使用蓝牙的意图

**一、CBCentralManager**

**1. 初始化**

**CBCentralManager** 对象用于扫描、发现、连接远程的外围设备。系统提供了两个初始化该类的方法

```
- (instancetype)initWithDelegate:(id)delegate  queue:(dispatch_queue_t)queue;
- (instancetype)initWithDelegate:(id)delegate queue:(dispatch_queue_t)queue options:(NSDictionary *)options;复制代码
```

在第二个初始化方法中，初始化的选项情况如下：

- CBCentralManagerOptionShowPowerAlertKey 用于当中心管理类被初始化时若此时蓝牙系统为关闭状态，是否向用户显示警告对话框。该字段对应的是NSNumber类型的对象，默认值为NO
- CBCentralManagerOptionRestoreIdentifierKey 中心管理器的唯一标识符，系统根据这个标识识别特定的中心管理器，为了继续执行应用程序，标识符必须保持不变，才能还原中心管理类

**2.扫描设备**

当系统第一次发现外设时，会根据mac地址等生成一个特定的标识符，此时我们可以保存这个特定的标识符用于后续的重连操作 系统提供唯一的方法进行对周边设备的扫描

```
//扫描设备
- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs ptions:(NSDictionary *)options;
//停止扫描设备
- (void)stopScan;复制代码
```

- 初始化的options选项详情如下：

CBCentralManagerScanOptionAllowDuplicatesKey 是否允许重复扫描设备，默认为NO，官方建议此值为NO，当为YES时，可能对电池寿命产生影响，建议在必要时才使用

CBCentralManagerScanOptionSolicitedServiceUUIDsKey 想要扫描的服务的UUID，对应一个NSArray数值

- UUID 表示外设的服务标识，当serviceUUIDs参数为nil时，将返回所有发现的外设(苹果不推荐此种做法)；当填写改服务标识时，系统将返回对应该服务标识的外设
- 可以指定允许应用程序在后台扫描设备，前提必须满足两个条件：

必须允许在蓝牙的后台模式

必须指定一个或多个UUID服务标识

<!-- more -->

**3. 连接设备**

```
//连接外设
- (void)connectPeripheral:(CBPeripheral *)peripheral  options:(NSDictionary *)options;
//断开与外设的连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;复制代码
```

连接设备时选项情况如下：

- CBConnectPeripheralOptionNotifyOnConnectionKey 应用程序被挂起时，成功连接到外设，是否向用户显示警告对话框，对应NSNumber对象，默认值为NO
- CBConnectPeripheralOptionNotifyOnDisconnectionKey 应用程序被挂起时，与外设断开连接，是否向用户显示警告对话框，对应NSNumber对象，默认值为NO
- CBConnectPeripheralOptionNotifyOnNotificationKey 应用程序被挂起时，只要接收到给定peripheral的通知，是否就弹框显示

官方建议如果连接设备不成功且没有进行重连，要明确取消与外设的连接(即调用断开与外设连接的方法) 当调用断开方法，断开与设备连接时，官方明确表明取消本地连接不能保证物理链接立即断开。当设备连接时间超过8秒后，调用断开的API能立即断开；但是连接未超过8秒，就调用断开API需要几秒后系统才与设备断开连接

**4. 通过搜索系统获取periphera对象**

```
//获取与系统已经连接的外设对象，如果设备已经与系统连接，通过该方法获取到外设对象后可以直接对CBPeripheral对象发起连接
- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs;
//获取一个已知CBPeripheral的列表(过去曾经发现过或者连接过的peripheral)
- (NSArray *)retrievePeripheralsWithIdentifiers:(NSArray *)identifiers;复制代码
```

**5. CBCentralManagerDelegate**

启动搜索发现设备后调用此代理

```
/*
* advertisementData 广播中的信息
*
* CBAdvertisementDataLocalNameKey 对应设置NSString类型的广播名
* CBAdvertisementDataManufacturerDataKey 外设制造商的NSData数据
* CBAdvertisementDataServiceDataKey  外设制造商的CBUUID数据
* CBAdvertisementDataServiceUUIDsKey 服务的UUID与其对应的服务数据字典数组
* CBAdvertisementDataOverflowServiceUUIDsKey 附加服务的UUID数组
* CBAdvertisementDataTxPowerLevelKey 外设的发送功率 NSNumber类型
* CBAdvertisementDataIsConnectable 外设是否可以连接
* CBAdvertisementDataSolicitedServiceUUIDsKey 服务的UUID数组
*
* RSSI 收到当前信号的强度 单位为分贝
*
* 如果后续要使用peripheral对象，必须在引用该对象，否则后续操作无法进行
*/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;复制代码
```

当设备连接成功后调用此代理

```
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;复制代码
```

当设备断开连接后调用此代理方法

```
//当断开连接后，外设中所有的服务、特征、特征描述都将失效
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;复制代码
```

当连接失败后调用此代理方法

```
//在ios系统的蓝牙连接中，不存在超时的现象，因此连接通常表示为一个暂时性的问题，可在改方法中再次尝试连接
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;复制代码
```

**6. 状态的监控**

当蓝牙状态发现变化时回调

```
/*
* CBCentralManagerStateUnknown 状态未知
* CBCentralManagerStateResetting 连接断开 即将重置
* CBCentralManagerStateUnsupported 该平台不支持蓝牙
* CBCentralManagerStateUnauthorized 未授权蓝牙使用
* CBCentralManagerStatePoweredOff 蓝牙关闭
* CBCentralManagerStatePoweredOn 蓝牙正常开启
*
* 该方法必须实现，否则系统报错
*/
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;复制代码
```

当系统恢复时先调用此方法

```
/*
*app状态的保存或者恢复，这是第一个被调用的方法当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法同步app状态通过蓝牙系统
*
* dic中的信息
* CBCentralManagerRestoredStatePeripheralsKey 在系统终止程序时，包含的已经连接或者正在连接的外设的集合
* CBCentralManagerRestoredStateScanServicesKey 系统终止应用程序时中心管理器连接的服务UUID数组
* CBCentralManagerRestoredStateScanOptionsKey  系统终止应用程序时中心管理器正在使用的外设选项
*/
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict;复制代码
```

**二、CBPeripheral**

**1. 属性**

- name 外设的名称
- services 外设中所有的服务(必须先使用查找服务的方法先找到服务，该属性才有对应的值)
- state 当前连接的状态

1. CBPeripheralStateDisconnected 当前没有连接
2. CBPeripheralStateConnecting 正在连接
3. CBPeripheralStateConnected 已连接
4. CBPeripheralStateDisconnecting 正在断开连接

**2. 发现服务**

发现外设指定的服务

```
/*
* 当设置serviceUUIDs参数时，只返回指定的服务(官方推荐做法)
* 当为指定serviceUUIDs参数时，将返回外设中所有可用的服务
*/
- (void)discoverServices:(NSArray *)serviceUUIDs;复制代码
```

从服务中发现服务

```
- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service;复制代码
```

**3. 发现特征**

```
/*
* 参数characteristicUUIDs不为空时，返回对应的特征值，当参数为nil时，返回该服务中的所有特征值
*/
- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service;
//发现特征值描述
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic;复制代码
```

**4. 读取数据**

```
/* 读取特征值
 * 并非所有特征都有特征值，需通过CBCharacteristicProperties枚举判断该特征是否可读
 */
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;
//读取特征值描述
- (void)readValueForDescriptor:(CBDescriptor *)descriptor;复制代码
```

**5. 写入数据**

```
/*
 * 写入数据，只允许对其特定的类型进行写入操作
 * 通过characteristic的properties的判断，判别支持那种类型的写入
 * CBCharacteristicWriteWithResponse 如果写入不成功，将以详细错误说明进行响应
 * CBCharacteristicWriteWithoutResponse 如果写入失败，则不会收到通知
 */
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;
//写入特征值的描述，一般为字符串对characteristic的描述
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor;复制代码
```

**6. 设置特征值的通知**

```
//如果设置为YES，当特征值发现变化时则会发起通知
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic;复制代码
```

**7. 读取RSSI**

```
//当调用此方法时，外设会调用peripheral:didReadRSSI:error:代理方法
- (void)readRSSI;复制代码
```

**8. 获取最大的写入长度**

```
/* 根据写入类型获取最大的写入长度
 * CBCharacteristicWriteWithResponse、CBCharacteristicWriteWithoutResponse
 */
- (NSUInteger)maximumWriteValueLengthForType:(CBCharacteristicWriteType)type;复制代码
```

**9. CBPeripheralDelegate**

发现服务的回调

```
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;复制代码
```

发现服务中的服务的回调

```
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error;复制代码
```

发现特征的回调

```
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;复制代码
```

发现特征描述的回调

```
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;复制代码
```

当特征值发现变化时回调

```
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;复制代码
```

当特征值描述发生变化时回调

```
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error;复制代码
```

写入特征值时回调

```
//只有指定写入类型有回应时才回到此方法
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;复制代码
```

写入特征值描述时回调

```
//当调用写入特征值描述时回调该方法
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error;复制代码
```

当外设启动或者停止指定特征值的通知时回调

```
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;复制代码
```

当连接外设成功后获取信号强度的方法后回调

```
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error;复制代码
```

当外设名称发生变化时回调

```
//由于外设可以改变其设备名称，因此若要显示该设备的当前名称可在该方法中处理
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral;复制代码
```

当外设服务发生变化时回调

```
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices;复制代码
```

**三. CBCharacteristic**

拥有的属性

- service 该特征所属的服务
- value 该特征的值
- descriptors 该特征的描述列表
- properties 性质特点

1. CBCharacteristicPropertyBroadcast 该属性为广播类型
2. CBCharacteristicPropertyRead 可读
3. CBCharacteristicPropertyWriteWithoutResponse 写-没有响应
4. CBCharacteristicPropertyWrite 可写
5. CBCharacteristicPropertyNotify 通知
6. CBCharacteristicPropertyIndicate 声明
7. CBCharacteristicPropertyAuthenticatedSignedWrites 通过验证的
8. CBCharacteristicPropertyExtendedProperties 拓展
9. CBCharacteristicPropertyNotifyEncryptionRequired 需要加密的通知
10. CBCharacteristicPropertyIndicateEncryptionRequired 需要加密的申明

- isNotifying 是否订阅特征值