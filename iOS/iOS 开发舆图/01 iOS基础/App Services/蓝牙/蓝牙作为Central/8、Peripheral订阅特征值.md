- 其实使用readValueForCharacteristic:方法并不是实时的。考虑到很多实时的数据，比如心率这种，那就需要订阅 characteristic 了。
- 当然也不是所有 characteristic 都允许订阅，依然可以通过CBCharacteristicPropertyNoifyoptions 来进行判断。

```objectivec
[peripheral setNotifyValue:YES forCharacteristic:interestingCharacteristic];
//如果是订阅，成功与否的回调是peripheral:didUpdateNotificationStateForCharacteristic:error:，
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
}
```