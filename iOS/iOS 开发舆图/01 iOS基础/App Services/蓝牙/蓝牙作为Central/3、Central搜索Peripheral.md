- 搜索services参数介绍
- `@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]`
- 搜索options参数介绍
- `CBCentralManagerScanOptionAllowDuplicatesKey:true`表示允许扫到重名，false表示不扫描重名的。
- 指定`CBCentralManagerScanOptionAllowDuplicatesKey`扫描选项不利于电池的寿命及程序性能
- 如果不指定`CBCentralManagerScanOptionAllowDuplicatesKey`，即不设置option参数，扫描的默认行为是，合并同一个外设发出的多个广播包（外设可能每秒会发送大量的数据包），当成一个，然后触发代理方法`centralManager:didDiscoverPeripheral:advertisementData:RSSI:`
- 如果设置`CBCentralManagerScanOptionAllowDuplicatesKey`以后，每次收到广播，就会调用上面的回调（无论广播数据是否一样），耗性能
- 设置option选项的场景：根据 `peripheral` 的距离来初始化连接（距离可用信号强度 RSSI 来判断），因为距离一直在变化，而距离是通过广播来告知的，所以做成每次收到广播，就回调，可以比较快的与外设进行连接，比如在50米内进行连接。

```objectivec
// Swift写法
centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true)])
// OC写法+加option
[_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
// OC写法
[_centralManager scanForPeripheralsWithServices:nil options:nil];
// 搜索成功后调用代理centralManager:didDiscoverPeripheral:advertisementData:RSSI:
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    // 打印搜到的设备
    NSLog(@"Discovered %@", peripheral.name);
}
// 停止搜索
[_centralManager stopScan];
```