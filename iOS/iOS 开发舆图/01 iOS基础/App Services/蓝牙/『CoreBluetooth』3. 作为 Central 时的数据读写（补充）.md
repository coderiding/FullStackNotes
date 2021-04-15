---
title: 『CoreBluetooth』3. 作为 Central 时的数据读写（补充）
tags: 蓝牙
categories: 蓝牙
abbrlink: 18327
date: 2016-06-13 13:11:11
---

上一章谈到了当设备作为 central 时，搜索、连接、读写的一些基本操作。几乎就是翻译了官方 API，除此之外，API 中还提到了一些枚举，以及蓝牙通信方面的其他知识，本文将一一介绍（不断更新中…）。

## CBUUID

`CBUUID`对象是用于 BLE 通信中 128 位的唯一标示符。peripheral 的 service，characteristic，characteristic descriptor 都包含这个属性。这个类包含了一系列生成 UUID 的方法。

> UUID 有 16 位的，也有 128 位的。其中 SIG 组织提供了一部分 16 位的 UUID，这部分 UUID 主要用于公共设备，例如有个用蓝牙连接的心率监测仪，如果是用的公共的 UUID，那么无论谁做一个 app，都可以进行连接，因为它的 UUID 是 SIG 官方提供的，是公开的。如果公司是要做一个只能自己的 app 才能连接的设备，那么就需要硬件方面自定义 UUID。（关于这方面，包括通信的 GATT 协议、广播流程等详细介绍，可以看[GATT Profile 简介](http://www.race604.com/gatt-profile-intro/)这篇文章。讲得比较详细，能在很大程度上帮助我们理解 BLE 通信。）

`CBUUID`类提供了可以将 16 位 UUID 转为 128 位 UUID 的方法。下面的代码是 SIG 提供的 16 位的心率 service UUID 转为 128 位 UUID 的方法：

```
CBUUID *heartRateServiceUUID = [CBUUID UUIDWithString:@"180D"];
```

如果需要获取`NSString`形式的 UUID，可以访问`CBUUID`的`UUIDString`只读属性。



<!-- more -->

## 设备唯一标识符

在有些时候，需要获取 peripheral 的唯一标示符（比如要做自动连接或绑定用户等操作，实际上自动连接是不用的，具体情况会在下一章——[最佳实践](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)中介绍到），但是在搜索到 peripheral 之后，只能拿到 identifier，而且这个 identifier 根据连接的 central 不同而不同。也就是说，不同的手机连上之后，identifier 是不同的。虽然比较坑爹，但是这并不影响你做蓝牙自动连接，关于自动连接，[最佳实践](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)中也会介绍到。

唯一标示符（并且不会变的）是设备的 MAC 地址，对于 Android 来说，轻轻松松就能拿到，但对于 iOS，目前这一属性还是私有的。所以如果一定有这样的需求（即一定要使用 MAC 地址），可以和硬件工程师沟通，因为 peripheral 知道自己的 MAC 地址，在建立连接之后，让他们返回数据即可。当然，还有一种方式，不过我没有尝试过，peripheral 不是一直在广播吗，广播的数据中包含了自己的名字、identifier、sevice UUID 等数据。如果这个广播的数据能更改，那在这里包含 MAC 地址也是不错的。在不建立连接的情况下，就能拿到 MAC 地址。

## 检查设备是否能作为 central

初始化`CBCentralManager`的时候，传入的`self`代理会触发回调`centralManagerDidUpdateState:`。在该方法中可通过`central.state`来获得当前设备是否能作为 central。`state`为`CBCentralManagerState`枚举类型，具体定义如下：

```
typedef NS_ENUM(NSInteger, CBCentralManagerState) {
    CBCentralManagerStateUnknown = 0,
    CBCentralManagerStateResetting,
    CBCentralManagerStateUnsupported,
    CBCentralManagerStateUnauthorized,
    CBCentralManagerStatePoweredOff,
    CBCentralManagerStatePoweredOn,
};
```

只有当`state == CBCentralManagerStatePoweredOn`时，才代表正常。

## 检查 characteristic 访问权限

如果不检查也没事，因为无权访问会在回调中返回 error，但这毕竟是马后炮。如果有需要在读写之前检测，可以通过 characteristic 的`properties`属性来判断。该属性为`CBCharacteristicProperties`的`NS_OPIONS`。

```
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
```

多个权限可以通过`|`和`&`来判断是否支持，比如判断是否支持读或写：

```
BOOL isSupport = characteristic.properties &amp; (CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite)
```

## 写入后是否回调

在写入 characteristic 时，可以选择是否在写入后进行回调。调用方法和枚举常量如下：

```
[self.connectedPeripheral writeValue:data forCharacteristic:connectedCharacteristic type:CBCharacteristicWriteWithResponse];

typedef NS_ENUM(NSInteger, CBCharacteristicWriteType) {
    CBCharacteristicWriteWithResponse = 0,
    CBCharacteristicWriteWithoutResponse,
};
```

回调方法为：

```
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
```

所以即使没有判断写入权限，也可以通过回调的 error 来判断，但这样比起写入前判断更耗资源。

[下一章](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)会介绍最佳实践，包含了在实际项目中，能够优化的内容。