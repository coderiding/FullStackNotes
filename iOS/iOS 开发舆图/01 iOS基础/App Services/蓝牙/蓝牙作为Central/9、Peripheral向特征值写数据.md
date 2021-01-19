- 关于写入数据的type，如下面这行代码，type就是CBCharacteristicWriteWithResponse，表示当写入成功时，要进行回调
- characteristic 也可能并不支持写操作，可以通过CBCharacteristic的properties属性来判断。

```objectivec
[peripheral writeValue:dataToWrite forCharacteristic:interestingCharacteristic type:CBCharacteristicWriteWithResponse];
//如果写入成功后要回调，那么回调方法是peripheral:didWriteValueForCharacteristic:error:。如果写入失败，那么会包含到 error 参数返回。
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@", [error localizedDescription]);
    }
}
```