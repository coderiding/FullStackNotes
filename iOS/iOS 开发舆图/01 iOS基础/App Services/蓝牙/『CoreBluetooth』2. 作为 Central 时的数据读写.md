---
title: 『CoreBluetooth』2. 作为 Central 时的数据读写
tags: 蓝牙
categories: 蓝牙
abbrlink: 7557
date: 2016-06-12 12:01:03
---

当设备作为 central 的时候，需要做一系列常见的操作：搜索并连接周围 peripheral，处理 peripheral 提供的数据。其实在设备作为 peripheral 的时候，依然有一系列的操作，不过和作为 central 时不同（废话），例如它会去发起广播，会在读写数据时做出响应。

本章内容则是介绍设备在作为 central 时，怎么使用 Core Bluetooth framework 来操作了。大致包含以下几点：

- 使用`CBCentralManager`
- 搜索并连接可用的 peripheral
- 连接时候，进行数据接收
- 对 characteristic 进行数据读写
- 当 characteristic 状态更新时，进行回调

之后才会介绍在设备作为 Peripheral 时的相关操作。

设备作为 central 相关文章还有：

> [CoreBluetooth3 作为 Central 时的数据读写（补充）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html)
> [CoreBluetooth4 作为 Central 时的数据读写（最佳实践）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)
> [CoreBluetooth5 作为 Central 时的数据读写（OTA 固件升级与文件传输）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-ota.html)

## 初始化 CBCentralManager

第一步先进行初始化，可以使用`initWithDelegate:queue:options:`方法：

```
myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
```

上面的代码中，将`self`设置为代理，用于接收各种 central 事件。将`queue`设置为`nil`，则表示直接在主线程中运行。

初始化 central manager 之后，设置的代理会调用`centralManagerDidUpdateState:`方法，所以需要去遵循`<CBCentralManagerDelegate>`协议。这个 did update state 的方法，能获得当前设备是否能作为 central。关于这个协议的实现和其他方法，接下来会讲到，也可以先看看[官方API](https://developer.apple.com/library/ios/documentation/CoreBluetooth/Reference/CBCentralManagerDelegate_Protocol/index.html#//apple_ref/doc/uid/TP40011285)。



<!-- more -->

## 搜索当前可用的 peripheral

可以使用`CBCentralManager`的`scanForPeripheralsWithServices:options:`方法来扫描周围正在发出广播的 Peripheral 设备。

```
[myCentralManager scanForPeripheralsWithServices:nil options:nil];
```

第一个参数为`nil`，表示所有周围全部可用的设备。在实际应用中，你可以传入一个`CBUUID`的数组（注意，这个 UUID 是 service 的 UUID 数组，如有不明白可以参考 [最佳实践](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)），表示只搜索当前数组包含的设备（每个 peripheral 的 service 都有唯一标识——UUID）。所以，如果你传入了这样一个数组，那么 central manager 则只会去包含这些 service UUID 的 Peripheral。

`CBUUID`会在下一章中讲到，因为这是 peripheral 相关的，和 central 本身关系不大，如果你是做的硬件对接，那么可以向硬件同事询问。当然，下一节的内容也能帮助你理解这个属性。

在调用`scanForPeripheralsWithServices:options:`方法之后，找到可用设备，系统会回调（每找到一个都会回调）`centralManager:didDiscoverPeripheral:advertisementData:RSSI:`。该方法会以`CBPeripheral`返回找到的 peripheral，所以你可以使用数组将找到的 peripheral 存起来。

```
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {

    NSLog(@"Discovered %@", peripheral.name);
}
```

当你找到你需要的那个 peripheral 时，可以调用`stop`方法来停止搜索。

```
[myCentralManager stopScan];
NSLog(@"Scanning stopped");
```

## 连接 peripheral

找到你需要的 peripheral 之后，下一步就是调用`connectPeripheral:options:`方法来连接。

```
[myCentralManager connectPeripheral:peripheral options:nil];
```

当连接成功后，会回调方法`centralManager:didConnectPeripheral:`。在这个方法中，你可以去记录当前的连接状态等数据。

```
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {

    NSLog(@"Peripheral connected");
}
```

不过在进行其他操作之前，你应该给已连接的这个 peripheral 设置代理，这样才能收到 peripheral 的回调（可以就写在上面这个方法中）。

```
peripheral.delegate = self;
```

注意去遵循`<CBPeripheralDelegate>`协议。

## 搜索 peripheral 的 service

当与 peripheral 成功建立连接以后，就可以通信了。第一步是先找到当前 peripheral 提供的 service，因为 service 广播的数据有大小限制（貌似是 31 bytes），所以你实际找到的 service 的数量可能要比它广播时候说的数量要多。调用`CBPeripheral`的 `discoverServices:`方法可以找到当前 peripheral 的所有 service。

```
[peripheral discoverServices:nil];
```

在实际项目中，这个参数应该不是`nil`的，因为`nil`表示查找所有可用的`Service`，但实际上，你可能只需要其中的某几个。搜索全部的操作既耗时又耗电，所以应该提供一个要搜索的 service 的 UUID 数组。更加详细的内容会在[最佳实践](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)中讲到。

当找到特定的 Service 以后，会回调`<CBPeripheralDelegate>`的`peripheral:didDiscoverServices:`方法。Core Bluetooth 提供了`CBService`类来表示 service，找到以后，它们以数组的形式存入了当前 peripheral 的`services`属性中，你可以在当前回调中遍历这个属性。

```
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {

    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service);
    }
}
```

如果是搜索的全部 service 的话，你可以选择在遍历的过程中，去对比 UUID 是不是你要找的那个。

## 搜索 service 的 characteristic

找到需要的 service 之后，下一步是找它所提供的 characteristic。如果搜索全部 characteristic，那调用`CBPeripheral`的`discoverCharacteristics:forService:`方法即可。如果是搜索当前 service 的 characteristic，那还应该传入相应的`CBService`对象。

```
NSLog(@"Discovering characteristics for service %@", interestingService);[peripheral discoverCharacteristics:nil forService:interestingService];
```

同样是出于节能的考虑，第一个参数在实际项目中应该是 characteristic 的 UUID 数组。也同样能在[最佳实践](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-best-practices.html)中介绍。

找到所有 characteristic 之后，回调`peripheral:didDiscoverCharacteristicsForService:error:`方法，此时 Core Bluetooth 提供了`CBCharacteristic`类来表示 characteristic。可以通过以下代码来遍历找到的 characteristic ：

```
- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {

    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
    }
}
```

同样也可以通过添加 UUID 的判断来找到需要的 characteristic。

## 读取 characteristic 数据

characteristic 包含了 service 要传输的数据。例如温度设备中表达温度的 characteristic，就可能包含着当前温度值。这时我们就可以通过读取 characteristic，来得到里面的数据。

#### 读取 characteristic 数据

当找到 characteristic 之后，可以通过调用`CBPeripheral`的`readValueForCharacteristic:`方法来进行读取。

```
NSLog(@"Reading value for characteristic %@", interestingCharacteristic);
[peripheral readValueForCharacteristic:interestingCharacteristic];
```

当你调用上面这方法后，会回调`peripheral:didUpdateValueForCharacteristic:error:`方法，其中包含了要读取的数据。如果读取正确，可以用以下方式来获得值：

```
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {

    NSData *data = characteristic.value;
    // parse the data as needed
}
```

注意，不是所有 characteristic 的值都是可读的，你可以通过`CBCharacteristicPropertyRead`options 来进行判断（这个枚举会在[下一章](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html)中介绍到）。如果你尝试读取不可读的数据，那上面的代理方法会返回相应的 error。

#### 订阅 Characteristic 数据

其实使用`readValueForCharacteristic:`方法并不是实时的。考虑到很多实时的数据，比如心率这种，那就需要订阅 characteristic 了。

可以通过调用`CBPeripheral`的`setNotifyValue:forCharacteristic:`方法来实现订阅，注意第一个参数是`YES`。

```
[peripheral setNotifyValue:YES forCharacteristic:interestingCharacteristic];
```

如果是订阅，成功与否的回调是`peripheral:didUpdateNotificationStateForCharacteristic:error:`，读取中的错误会以 error 形式传回：

```
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {

    if (error) {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
}
```

当然也不是所有 characteristic 都允许订阅，依然可以通过`CBCharacteristicPropertyNoify`options 来进行判断。这个枚举会在[下一章](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html)中介绍到。

当订阅成功以后，那数据便会实时的传回了，数据的回调依然和之前读取 characteristic 的回调相同（注意，不是订阅的那个回调）`peripheral:didUpdateValueForCharacteristic:error:`。

## 向 characteristic 写数据

写数据其实是一个很常见的需求，如果 characteristic 可写，你可以通过`CBPeripheral`类的`writeValue:forCharacteristic:type:`方法来向设备写入`NSData`数据。

```
NSLog(@"Writing value for characteristic %@", interestingCharacteristic);
[peripheral writeValue:dataToWrite forCharacteristic:interestingCharacteristic type:CBCharacteristicWriteWithResponse];
```

关于写入数据的`type`，如上面这行代码，`type`就是`CBCharacteristicWriteWithResponse`，表示当写入成功时，要进行回调。更多的类型可以参考`CBCharacteristicWriteType`枚举。这个枚举会在[下一章](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html)中介绍到。

如果写入成功后要回调，那么回调方法是`peripheral:didWriteValueForCharacteristic:error:`。如果写入失败，那么会包含到 error 参数返回。

```
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {

    if (error) {
        NSLog(@"Error writing characteristic value: %@", [error localizedDescription]);
    }
}
```

注意：characteristic 也可能并不支持写操作，可以通过`CBCharacteristic`的`properties`属性来判断。这个 option 会在[下一章](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html)中介绍到。

基本的介绍就到此结束，下一章会对本文没有详细讲解的内容进行补充，如会用到的枚举、类等。