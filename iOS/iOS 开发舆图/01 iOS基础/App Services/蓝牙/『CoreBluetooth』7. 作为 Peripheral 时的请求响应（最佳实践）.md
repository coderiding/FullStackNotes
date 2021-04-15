---
title: 『CoreBluetooth』5. 作为 Central 时的数据读写（OTA 固件升级与文件传输）
tags: 蓝牙
categories: 蓝牙
abbrlink: 21475
date: 2016-06-17 10:24:30
---

上一章谈到了 iOS 设备作为 peripheral 端的通信，在这之中还有很多细节和可以优化的地方，本章《最佳实践》将会一一提到。

## 关于广播的思考

广播是 peripheral 的一个重要操作，接下来会讲到广播的正确姿势。

#### 注意广播对数据大小的限制

正如前文提到过的那样，广播是通过调用 `CBPeripheralManager` 的 `startAdvertising:` 方法发起的。当你将要发送的数据打包成字典后，千万要记住数据大小是有限制的。

即使广播可以包含 peripheral 的很多信息，但是其实只需要广播 peripheral 的名称和 service 的 UUID 就足够了。也就是构建字典时，填写 `CBAdvertisementDataLocalNameKey` 和 `CBAdvertisementDataServiceUUIDsKey` 对应的 value 即可，如果使用其他 key，将会导致错误。

当 app 运行在前台时，有 28 bytes 的空间可用于广播。如果这 28 bytes 用完了，则会在扫描响应时额外分配 10 bytes 的空间，但这空间只能用于被 `CBAdvertisementDataLocalNameKey` 修饰的 local name（即在 `startAdvertising:` 时传入的数据）。以上提到的空间，均不包含 2 bytes 的报文头。被 `CBAdvertisementDataServiceUUIDsKey` 修饰的 service 的 UUID 数组数据，均不会添加到特殊的 overflow 区域。并且这些 service 只能被 iOS 设备发现。当程序挂起后，local name 和 UUID 都会被加入到 overflow 区。

为了保证在有限的空间中，正确的标识设备和 service UUID，请正确构建广播的数据。



<!-- more -->

#### 只广播必要的数据

当 peripheral 想要被发现时，它会向外界发送广播，此时会用到设备的无线电（当然还有电池）。一旦连接成功，central 便能直接从 peripheral 中读取数据了，那么此时广播的数据将不再有用。所以，为了减少无线电的使用、提高手机性能、保护设备电池，应该在被连接后，及时关闭广播。停止广播调用 `CBPeripheralManager` 的 `stopAdvertising` 方法即可。

```
[myPeripheralManager stopAdvertising];
```

#### 手动开启广播

其实什么时候应该广播，多数情况下，用户比我们更清楚。比如，他们知道周围没有开着的 BLE 设备，那他就不会把 peripheral 的广播打开。所以提供给用户一个手动开启广播的 UI 更为合适。

## 配置 characteristic

在创建 characteristic 的时候，就为它设定了相应的 `properties`、`value` 和 `promissions`。这些属性决定了 central 如何和 characteristic 通信。`properties` 和 `promissions` 可能需要根据 app 的需求来设置，下来就来谈谈如何配置 characteristic：

- 允许 central 订阅 characteristic。
- 防止未配对的 central 访问 characteristic 的敏感信息。

#### 让 characteristic 支持通知

之前在 central 的时候提到过，如果要读取经常变化的 characteristic 的数据，更推荐使用订阅。所以，如果可以，最好 characteristic 允许订阅。

如果像下面这样初始化 characteristic 就是允许读和订阅：

```
myCharacteristic = [[CBMutableCharacteristic alloc]
        initWithType:myCharacteristicUUID
        properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify
        value:nil permissions:CBAttributePermissionsReadable];
```

#### 限制只能配对的 central 才能访问敏感信息

有些时候，可能有这样的需求：需要 service 的一个或多个 characteristic 的数据安全性。假如有一个社交媒体的 service，那么它的 characteristic 可能包含了用户的姓名、邮箱等私人信息，所以只让信任的 central 才能访问这些数据是很有必要的。

这可以通过设置相应的 `properties` 和 `promissions` 来达到效果：

```
emailCharacteristic = [[CBMutableCharacteristic alloc]
        initWithType:emailCharacteristicUUID
        properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired
        value:nil permissions:CBAttributePermissionsReadEncryptionRequired];
```

向上面这样设置，便能只让配对的 central 才能进行订阅。并且在连接过程中，Core Bluetooth 还会自动建立安全连接。

在尝试配对时，两端都会弹出警告框，central 端会提供 code，peripheral 端必须要输入该 code 才能配对成功。成功之后，peripheral 才会信任该 central，并允许读写数据。