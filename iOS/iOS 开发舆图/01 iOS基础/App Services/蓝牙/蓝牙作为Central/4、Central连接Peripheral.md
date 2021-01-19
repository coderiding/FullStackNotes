- 连接peripheral参数介绍
- 这个连接的外设记得要全局引用
- 连接options参数介绍
- 以下设置针对的是只能在前台运行的app退到后台之后，如果设置了BLE的任意一种后台运行模式，下面的参数就会无效
- `CBConnectPeripheralOptionNotifyOnConnectionKey` app在后台时（挂起），此时蓝牙连接成功，给出系统提示（提示是系统自带的）。对应NSNumber对象，默认值为NO
- `CBConnectPeripheralOptionNotifyOnDisconnectionKey` app在后台时（挂起），此时蓝牙断开连接，给出系统提示（提示是系统自带的）。对应NSNumber对象，默认值为NO。效果图参考：[https://gitee.com/coderiding/picbed/raw/master/uPic/291604651719_.pic.jpg](https://gitee.com/coderiding/picbed/raw/master/uPic/291604651719_.pic.jpg)
- `CBConnectPeripheralOptionNotifyOnNotificationKey` app在后台时（挂起），此时app收到 peripheral 数据时，给出系统提示（提示是系统自带的）。
- CBConnectPeripheralOptionStartDelayKey
- CBConnectPeripheralOptionEnableTransportBridgingKey
- CBConnectPeripheralOptionRequiresANCS

```objectivec
[myCentralManager connectPeripheral:peripheral options:nil];
// 加参数连接
[myCenter connectPeripheral:peripheralInfo.peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES, CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES, CBConnectPeripheralOptionNotifyOnNotificationKey: @YES}];
myCenter.connect(peripheralInfo.peripheral, options: [
    CBConnectPeripheralOptionNotifyOnConnectionKey: NSNumber(value: true),
    CBConnectPeripheralOptionNotifyOnDisconnectionKey: NSNumber(value: true),
    CBConnectPeripheralOptionNotifyOnNotificationKey: NSNumber(value: true)
])
[centralManager connectPeripheral:peripheralDevice options:@{CBConnectPeripheralOptionNotifyOnConnectionKey: @YES, CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES}];//当蓝牙连接上或连接断开时，如果APP不在前台，系统将弹出一个对话框，提示用户打开APP，还可以设置当收到通知时打开
//连接成功后会调用代理centralManager:didConnectPeripheral:
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Peripheral connected");
}
//设置外设的代理
peripheral.delegate = self;
//<CBPeripheralDelegate>
```

### Peripheral方法

```objectivec
- (void)readRSSI;
- (void)discoverServices:(nullable NSArray<CBUUID *> *)serviceUUIDs;
- (void)discoverIncludedServices:(nullable NSArray<CBUUID *> *)includedServiceUUIDs forService:(CBService *)service;
- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service;
- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;
- (NSUInteger)maximumWriteValueLengthForType:(CBCharacteristicWriteType)type NS_AVAILABLE(10_12, 9_0);
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;
- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic;
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic;
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor;
- (void)openL2CAPChannel:(CBL2CAPPSM)PSM NS_AVAILABLE(10_14, 11_0);
```

### Peripheral代理

```objectivec
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(10_9, 6_0);
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices NS_AVAILABLE(10_9, 7_0);
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error NS_DEPRECATED(10_7, 10_13, 5_0, 8_0);
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error NS_AVAILABLE(10_13, 8_0);
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;
 - (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error;
- (void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral;
- (void)peripheral:(CBPeripheral *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error;
```