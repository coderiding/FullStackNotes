- 不是所有 characteristic 的值都是可读的，你可以通过CBCharacteristicPropertyReadoptions 来进行判断
- 蓝牙接收数据的方式？
    - 主动接收：在需要接收数据的时候，调用 readValueForCharacteristic:，这种是需要主动去接收的。
    - 订阅接收：用 setNotifyValue:forCharacteristic:方法订阅，当有数据发送时，可以直接在回调中接收。
    - 如果 characteristic 的数据经常变化，那么采用订阅的方式更好。

```objectivec
[peripheral readValueForCharacteristic:interestingCharacteristic];
//调用上面这方法后，会回调peripheral:didUpdateValueForCharacteristic:error:方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error 
{
    NSData *data = characteristic.value;
    // parse the data as needed
}
// 读取新值的结果
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"错误：%@",error);
        return;
    }
    
    NSData *data = characteristic.value;
    if (data.length <= 0) {
        return;
    }
    NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"info:%@",info);
}
```