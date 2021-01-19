- 注意：cancelPeripheralConnection:是非阻塞性的，如果在 peripheral 挂起的状态去尝试断开连接，那么这个断开操作可能执行，也可能不会。因为可能还有其他的 central 连着它，所以取消连接并不代表底层连接也断开。从 app 的层面来讲，在 peripheral 决定断开的时候，会调用 CBCentralManagerDelegate 的 centralManager:didDisconnectPeripheral:error:方法。
- 当 characteristic 不再发送数据时。（可以通过 isNotifying属性来判断）
- 你已经接收到了你所需要的所有数据时。
- 以上两种情况，都需要先结束订阅，然后断开连接。
- 当调用断开方法，断开与设备连接时，官方明确表明取消本地连接不能保证物理链接立即断开。当设备连接时间超过8秒后，调用断开的API能立即断开；但是连接未超过8秒，就调用断开API需要几秒后系统才与设备断开连接

```objectivec
[peripheral setNotifyValue:NO forCharacteristic:characteristic];

[myCentralManager cancelPeripheralConnection:peripheral];
```