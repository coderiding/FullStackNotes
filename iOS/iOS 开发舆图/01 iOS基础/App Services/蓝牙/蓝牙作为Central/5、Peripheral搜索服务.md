- 最佳实践：在实际项目中，这个参数应该不是nil的，因为nil表示查找所有可用的Service，但实际上，你可能只需要其中的某几个。搜索全部的操作既耗时又耗电，所以应该提供一个要搜索的 service 的 UUID 数组。

```objectivec
// nil，查询所有服务
[peripheral discoverServices:nil];
// 或者
[peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];//查询指定服务
// 搜索成功后回调<CBPeripheralDelegate>的peripheral:didDiscoverServices:方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service);
    }
}
```