---
title: 『CoreBluetooth』5. 作为 Central 时的数据读写（OTA 固件升级与文件传输）
tags: 蓝牙
categories: 蓝牙
abbrlink: 21474
date: 2016-06-16 10:24:30
---

之前几篇都详细的介绍了当 iOS 设备作为 central 时的读写操作，这一章将会介绍下在 iOS 设备作为 peripheral 时的相关处理。即使你只需要 central 的部分，我也建议你看一下本章内容，它对你了解整个蓝牙通信有帮助。

本文将会介绍以下内容：

- 学习 `CBPeripheralManager`。
- 配置 service 和 characteristic。
- 将构建的 service 和 characteristic 树形结构加入 peripheral。
- 广播拥有的 service。
- 在 central 写入数据时，做出相关响应。
- 在 characteristic 数据更新时，告诉订阅的 central。

本章会举一些例子，但这些例子都是抽象化的，具体应该怎么去解决，还需要和需求结合。当然，下一章[《最佳实践》](http://www.saitjr.com/ios/core-bluetooth-response-as-peripheral-best-practices.html)也会提供一些想法。

## `CBPeripheralManager`

将设备作为 peripheral，第一步就是初始化 `CBPeripheralManager` 对象。可以通过调用 `CBPeripheralManager` 的 `initWithDelegate:queue:options:` 方法来进行初始化：

```
myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
```

上面的几个参数中，将 `self` 设为代理来接收相关回调，`queue` 为 `nil` 表示在主线程。

当你调用上面这方法后，便会回调 `peripheralManagerDidUpdateState:` 。所以在此之前，你需要先遵循 `CBPeripheralManagerDelegate`。这个代理方法能获取当前 iOS 设备能否作为 peripheral。



<!-- more -->

## 配置 service 和 characteristic

就像之前讲到的一样，peripheral 数据库是一个树形结构。

![Xnip2020-11-06_13-48-11](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-06_13-48-11.jpg)

所以在创建 peripheral 的时候，也要像这种树形结构一样，将 service 和 characteristic 装进去。在此之前，我们需要做的是学会如何标识 service 和 characteristic。

#### 使用 UUID 来标识 service 和 characteristic

service 和 characteristic 都通过 128 位的 UUID 来进行标识，Core Bluetooth 将 UUID 封装为了 `CBUUID` 。关于详细 UUID 的介绍，请参考 [CoreBluetooth3 作为 central 时的数据读写（补充）](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role-supplement.html) 。

#### 为自定义的 service 和 characteristic 创建 UUID

你的 service 或者 characteristic 的 UUID 并没有公共的 UUID，这时你需要创建自己的 UUID。

使用命令行的 `uuidgen` 能很容易的生成 UUID。首先打开终端，为你的每一个 service 和 characteristic 创建 UUID。在终端输入 `uuidgen` 然后回车，具体如下：

```
$ uuidgen
71DA3FD1-7E10-41C1-B16F-4430B506CDE7
```

可以通过 `UUIDWithString` 方法，将 UUID 生成 `CBUUID` 对象。

```
CBUUID *myCustomServiceUUID = [CBUUID UUIDWithString:@"71DA3FD1-7E10-41C1-B16F-4430B506CDE7"];
```

#### 构建 service 和 characteristic 树形结构

在将 UUID 打包为 `CBUUID` 之后，就可以创建 `CBMutableService` 和 `CBMutableCharacteristic` 并把他们组成一个树形结构了。创建 `CBMutableCharacteristic` 对象可以通过该类的 `initWithType:properties:value:permissions:` 方法：

```
myCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:myCharacteristicUUID
         properties:CBCharacteristicPropertyRead
         value:myValue permissions:CBAttributePermissionsReadable];
```

创建 characteristic 的时候，就为他设置了 `properties` 和 `permissions`。这两个属性分别定义了 characteristic 的可读写状态和 central 连接后是否能订阅。上面这种初始化方式，代表着 characteristic 可读。更多的选项，可以去看看 [CBMutableCharacteristic Class Reference](https://developer.apple.com/library/ios/documentation/CoreBluetooth/Reference/CBMutableCharacteristic_Class/index.html#//apple_ref/doc/uid/TP40013045)。

如果给 characteristic 设置了 `value` 参数，那么这个 `value` 会被缓存，并且 `properties` 和 `permissions` 会自动设置为可读。如果想要 characteristic 可写，或者在其生命周期会改变它的值，那需要将 `value` 设置为 `nil`。这样的话，就会动态的来处理 `value` 。

现在已经成功的创建了 characteristic，下一步就是创建一个 service，并将它们构成树形结构。

调用 `CBMutableService` 的 `initWithType:primary:` 方法来初始化 service：

```
myService = [[CBMutableService alloc] initWithType:myServiceUUID primary:YES];
```

第二个参数 `primary` 设置为 `YES` 表示该 service 为 primary service（主服务），与 secondary service（次服务）相对。primary service 描述了设备的主要功能，并且能包含其他 service。secondary service 描述的是引用它的那个 service 的相关信息。比如，一个心率监测器，primary service 描述的是当前心率数据，secondary service 描述描述的是当前电量。

创建了 service 之后，就可以包含 characteristic 了：

```
myService.characteristics = @[myCharacteristic];
```

## 发布 service 和 characteristic

构建好树形结构之后，接下来便需要将这结构加入设备的数据库。这一操作 Core Bluetooth 已经封装好了，调用 `CBPeripheralManager` 的 `addService:` 方法即可：

```
[myPeripheralManager addService:myService];
```

当调用以上方法时，便会回调 `CBPeripheralDelegate` 的 `peripheralManager:didAddService:error:` 回调。当有错误，或者当前 service 不能发布的时候，可以在这个代理中来进行检测：

```
- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
}
```

当你发布 service 之后，service 就会缓存下来，并且无法再修改。

## 广播 service

搞定发布 service 和 characteristic 之后，就可以开始给正在监听的 central 发广播了。可以通过调用 `CBPeripheralManager` 的 `startAdvertising:` 方法并传入字典作为参数来进行广播：

```
[myPeripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[myFirstService.UUID, mySecondService.UUID]}];
```

上面的代码中，key 只用到了 `CBAdvertisementDataServiceUUIDsKey`，对应的 value 是包含需要广播的 service 的 `CBUUID` 类型数组。除此之外，还有以下 key：

```
NSString *const CBAdvertisementDataLocalNameKey;
NSString *const CBAdvertisementDataManufacturerDataKey;
NSString *const CBAdvertisementDataServiceDataKey;
NSString *const CBAdvertisementDataServiceUUIDsKey;
NSString *const CBAdvertisementDataOverflowServiceUUIDsKey;
NSString *const CBAdvertisementDataTxPowerLevelKey;
NSString *const CBAdvertisementDataIsConnectable;
NSString *const CBAdvertisementDataSolicitedServiceUUIDsKey;
```

但是只有 `CBAdvertisementDataLocalNameKey` 和 `CBAdvertisementDataServiceUUIDsKey` 才是 peripheral Manager 支持的。

当开始广播时，peripheral Manager 会回调 `peripheralManagerDidStartAdvertising:error:` 方法。如果有错或者 service 无法进行广播，则可以在该该方法中检测：

```
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}
```

因为空间的限制，并且还可能有多个 app 在同时发起广播，所以数据广播基于 `best effort`（即在接口发生拥塞时，立即丢包，知道业务量减小）。关于数据大小的限制，会在下一章[《最佳实践》](http://www.saitjr.com/ios/core-bluetooth-response-as-peripheral-best-practices.html)中谈到。

广播服务在程序挂起时依然可用，详细会在之后讲到。

## 响应 central 的读写操作

在连接到一个或多个 central 之后，peripheral 有可能会收到读写请求。此时，你应该根据请求作出相应的响应，接下来便会提到这方面的处理。

#### 读取请求

当收到读请求时，会回调 `peripheralManager:didReceiveReadRequest:` 方法。该回调将请求封装为了 `[CBATTRequest](https://developer.apple.com/library/ios/documentation/CoreBluetooth/Reference/CBATTRequest_class/index.html#//apple_ref/occ/cl/CBATTRequest)` 对象，在该对象中，包含很多可用的属性。

其中一种用法是在收到读请求时，可以通过 `CBATTRequest` 的 `characteristic` 属性来判断当前被读的 characteristic 是哪一个 characteristic：

```
- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {

    if ([request.characteristic.UUID isEqual:myCharacteristic.UUID]) {
    }
}
```

匹配上 UUID 之后，接下来需要确保读取数据的 `offset`（偏移量）不会超过 characteristic 数据的总长度：

```
if (request.offset > myCharacteristic.value.length) {
    [myPeripheralManager respondToRequest:request withResult:CBATTErrorInvalidOffset];
    return;
}
```

假设偏移量验证通过，下面需要截取 characteristic 中的数据，并赋值给 `request.value`。注意，`offset` 也要参与计算：

```
request.value = [myCharacteristic.value subdataWithRange:NSMakeRange(request.offset, myCharacteristic.value.length - request.offset)];
```

读取完成后，记着调用 `CBPeripheralManager` 的 `respondToRequest:withResult:` 方法，告诉 central 已经读取成功了：

```
[myPeripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
```

如果 UUID 匹配不上，或者是因为其他原因导致读取失败，那么也应该调用 `respondToRequest:withResult:` 方法，并返回失败原因。官方提供了一个[失败原因枚举](https://developer.apple.com/library/ios/documentation/CoreBluetooth/Reference/CoreBluetooth_Constants/index.html#//apple_ref/c/tdef/CBATTError)，可能有你需要的。

#### 写入请求

写入请求和读取请求一样简单。当 central 想要写入一个或多个 characteristic 时，`CBPeripheralManager` 回调 `peripheralManager:didReceiveWriteRequests:`。该方法会获得一个 `CBATTRequest` 数组，包含所有写入请求。当确保一切验证没问题后（与读取操作验证类似：UUID 与 `offset`），便可以进行写入：

```
myCharacteristic.value = request.value;
```

成功后，同样去调用 `respondToRequest:withResult:`。但是和读取操作不同的是，读取只有一个 `CBATTRequest`，但是写入是一个 `CBATTRequest` 数组，所以这里直接传入第一个 request 就行：

```
[myPeripheralManager respondToRequest:[requests objectAtIndex:0] withResult:CBATTErrorSuccess];
```

因为收到的是一个请求数组，所以，当他们其中有任何一个不满足条件，那就不必再处理下去了，直接调用 `respondToRequest:withResult:` 方法返回相应的错误。

## 发送更新数据给订阅了的 central

central 可能会订阅了一个或多个 characteristic，当数据更新时，需要给他们发送通知。下面就来详细介绍下：

当 central 订阅 characteristic 的时候，会回调 `CBPeripheralManager` 的 `peripheralManager:central:didSubscribeToCharacteristic:` 方法：

```
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {

    NSLog(@"Central subscribed to characteristic %@", characteristic);
}
```

通过上面这个代理，可以用个数组来保存被订阅的 characteristic，并在它们的数据更新时，调用 `CBPeripheralManager` 的 `updateValue:forCharacteristic:onSubscribedCentrals:` 方法来告诉 central 有新的数据：

```
NSData *updatedValue = // fetch the characteristic's new value
BOOL didSendValue = [myPeripheralManager updateValue:updatedValue forCharacteristic:characteristic onSubscribedCentrals:nil];
```

这个方法的最后一个参数能指定要通知的 central。如果参数为 `nil`，则表示想所有订阅了的 central 发送通知。

同时，`updateValue:forCharacteristic:onSubscribedCentrals:` 方法会返回一个 `BOOL` 标识是否发送成功。如果发送队列任务是满的，则会返回 `NO`。当有可用的空间时，会回调 `peripheralManagerIsReadyToUpdateSubscribers:` 方法。所以你可以在这个回调用调用 `updateValue:forCharacteristic:onSubscribedCentrals:` 重新发送数据。

发送数据使用到的是通知，当你更新订阅的 central 时，应该调用一次 `updateValue:forCharacteristic:onSubscribedCentrals:`。

因为 characteristic 数据大小的关系，不是所有的更新都能发送成功，这种问题应该由 central 端来处理。调用 `CBPeripheral` 的 `readValueForCharacteristic:` 方法，来主动获取数据（关于 central 读取数据，可以参考 [《设备作为 central 时的数据读写》](http://www.saitjr.com/ios/core-bluetooth-read-write-as-central-role.html)）。