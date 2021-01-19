- 如果是搜索当前 service 的 characteristic，那还应该传入相应的CBService对象。
- 如果搜索全部 characteristic，那调用CBPeripheral的discoverCharacteristics:forService:方法即可。
- 最佳实践：出于节能的考虑，第一个参数在实际项目中应该是 characteristic 的 UUID 数组。

```objectivec
[peripheral discoverCharacteristics:nil forService:interestingService];
// 或者
if ([service.UUID isEqual:[CBUUID UUIDWithString: kServiceUUID]]) {
    [peripheral discoverCharacteristics:[NSArray arrayWithObject:[CBUUID UUIDWithString:kCharacteristicUUID]] forService:service];
}
// 或者
for (CBService *service in peripheral.services) {
    [peripheral discoverCharacteristics:nil forService:service];
}
// 或者
for (CBService *service in peripheral.services) {
    if ([service.UUID isEqual:[CBUUID UUIDWithString: kServiceUUID]]) {
        [peripheral discoverCharacteristics:[NSArray arrayWithObject:[CBUUID UUIDWithString:kCharacteristicUUID]] forService:service];
    }
}
//搜索到 characteristic 之后，回调peripheral:didDiscoverCharacteristicsForService:error:方法
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
    }
}
- (void)peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error {
    // 拿到服务中所有的特诊
    NSArray*characteristics = service.characteristics;
    // 遍历特征,拿到需要的特征处理
    for(CBCharacteristic* characteristicincharacteristics) {
        if([characteristic.UUID.UUIDStringisEqualToString:@"FFE1"]) {
            [peripheralsetNotifyValue:YESforCharacteristic:characteristic];
            self.characteristic= characteristic;
            [CommonToolbleSenderData:kObtainIDbluetoothPeripheral:self.bluetoothPeripheralcharacteristic:characteristic];
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    if (error) {
        NSLog(@"出错");
        return;
    }
    
    for (CBCharacteristic *character in service.characteristics) {
        // 这是一个枚举类型的属性
        CBCharacteristicProperties properties = character.properties;
        if (properties & CBCharacteristicPropertyBroadcast) {
            //如果是广播特性
        }
        
        if (properties & CBCharacteristicPropertyRead) {
            //如果具备读特性，即可以读取特性的value
            [peripheral readValueForCharacteristic:character];
        }
        
        if (properties & CBCharacteristicPropertyWriteWithoutResponse) {
            //如果具备写入值不需要响应的特性
            //这里保存这个可以写的特性，便于后面往这个特性中写数据
            _chatacter = character;
        }
        
        if (properties & CBCharacteristicPropertyWrite) {
            //如果具备写入值的特性，这个应该会有一些响应
        }
        
        if (properties & CBCharacteristicPropertyNotify) {
            //如果具备通知的特性，无响应
            [peripheral setNotifyValue:YES forCharacteristic:character];
        }
    }
}
```

### 特征值访问权限

```objectivec
typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
    CBCharacteristicPropertyBroadcast                                               = 0x01,
    CBCharacteristicPropertyRead                                                    = 0x02,
    CBCharacteristicPropertyWriteWithoutResponse                                    = 0x04,
    CBCharacteristicPropertyWrite                                                   = 0x08,
    CBCharacteristicPropertyNotify                                                  = 0x10,
    CBCharacteristicPropertyIndicate                                                = 0x20,
    CBCharacteristicPropertyAuthenticatedSignedWrites                               = 0x40,
    CBCharacteristicPropertyExtendedProperties                                      = 0x80,
    CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)     = 0x100,
    CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)   = 0x200
};
//多个权限可以通过|和&来判断是否支持，比如判断是否支持读或写：
BOOL isSupport = characteristic.properties &amp; (CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite)
```