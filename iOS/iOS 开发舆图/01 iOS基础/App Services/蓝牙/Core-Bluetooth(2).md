---
title: Core-Bluetooth(2)
tags:
  - 蓝牙
categories: 蓝牙
abbrlink: 1667
date: 2016-06-15 12:11:03
---



这一节讲讲`外接设备(Peripheral)`，主要是关于`CBPeripheralManager`这个类的使用。

## 0x00 - Starting Up a Peripheral Manager

首先，初始化一个`CBPeripheralManager`实例。

```
myPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
```

同样的，这里的queue参数设置为`nil`表示默认使用主队列。

但你创建完一个 myPeripheralManager 实例的时候，peripheral manager 就会调用它的代理函数`peripheralManagerDidUpdateState:`，这边必须实现该函数以确保本地外设支持该蓝牙。

## 0x01 - Setting up Your Services and Characteristics

[Core Bluetooth](https://melodyofnight.github.io/2019/06/27/Core-Bluetooth/)这一节说过，`Peripheral`是由`CBService`,`CBCharacteristic`组成的，所以我们这边得先创建CBService和CBCharacteristic。

services 和 characteristics 都是由128-bit的UUIDs唯一指定的。例如`0000180D-0000-1000-8000-00805F9B34FB` ，在开发的过程中`CBUUID`提供了一个`UUIDWithString`方法，可以使用简短的字符串生成128-bit的UUIDs。

```
CBUUID *heartRateServiceUUID = [CBUUID UUIDWithString: @"180D"];
```

对于一些没有预设UUIDs的services和Characteristics，你也可以通过命令行`uuidgen`生成，然后用这个UUID实例化一个CBUUID

<!-- more -->

```
$ uuidgen
71DA3FD1-7E10-41C1-B16F-4430B506CDE7
CBUUID *myCustomServiceUUID = [CBUUID UUIDWithString:@"71DA3FD1-7E10-41C1-B16F-4430B506CDE7"];
```

然后，通过 UUID 创建 services 和 characteristics

```
myService = [[CBMutableService alloc] initWithType:myServiceUUID primary:YES];
myCharacteristic =
        [[CBMutableCharacteristic alloc] initWithType:myCharacteristicUUID
         properties:CBCharacteristicPropertyRead
         value:myValue permissions:CBAttributePermissionsReadable];
```

接着把characteristics设置给services

```
myService.characteristics = @[myCharacteristic];
```

## 0x02 - Publishing Your Services and Characteristics

最后add到peripheral上

```
[myPeripheralManager addService:myService];
```

当你把service加进来的时候，peripheral 就相当于发布了服务了，这时候会调用delegate的`peripheralManager:didAddService:error:`方法，如果发布不成功的话在这里就可以获取到相关的错误原因了。

```
- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
 
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
    ...
```

**Note:** 一旦你发布了服务的时候，services就会被cache起来并且不可再修改！

## 0x03 - Advertising Your Services

当你发布了服务的时候接下来就需要向Central进行广播了，开始广播可以调用`startAdvertising:`这个方法

```
[myPeripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey :
        @[myFirstService.UUID, mySecondService.UUID] }];
```

这里的UUIDsKey指定你要对外广播的servers。目前，这里只提供了2种key可以填写，`CBAdvertisementDataLocalNameKey` 和 `CBAdvertisementDataServiceUUIDsKey`。

当开始对外广播的时候，peripheral 就会调用delegate的`peripheralManagerDidStartAdvertising:error:`这个方法，一旦广播出错便可以在这里捕获到。

```
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
 
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
    ...
```

开启对外广播的时候，周边的centrals就可以发现并和你建立连接

## 0x04 - Responding to Read and Write Request form a Central

建立起连接之后，

### Read

```
- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {
 
    if ([request.characteristic.UUID isEqual:myCharacteristic.UUID]) {
        ...
```

接收到请求的第一步便是验证请求的characteristic UUID 是否在外设的数据库里面。

检查通过以后再对请求读取的数据字段做越界检查。

```
if (request.offset > myCharacteristic.value.length) {
        [myPeripheralManager respondToRequest:request
            withResult:CBATTErrorInvalidOffset];
        return;
    }
```

假设都验证通过的情况下，这直接给请求的request赋值

```
request.value = [myCharacteristic.value
        subdataWithRange:NSMakeRange(request.offset,
        myCharacteristic.value.length - request.offset)];
```

赋值成功后再响应请求是否成功，同时把请求的request传递回去

```
[myPeripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    ...
```

**Note:** `peripheralManager:didReceiveReadRequest:`和`respondToRequest:withResult:`是成对出现的。

在接收的request请求的时候，如果本地数据库里面找不到 characteristic 的 UUID 的话需要调用`respondToRequest:withResult:`响应请求，告诉请求失败，失败原因可以查看[CBATTError Constants](https://developer.apple.com/documentation/corebluetooth/cbatterror)这里列举的错误选项。

### Write

处理写请求也很容易，当central发起写请求的时候，peripheral manager 会调用`peripheralManager:didReceiveWriteRequests:`这个方法响应写请求，之后再把 request里面的value赋给characteristic就好了。当然，同样要检查UUID和越界的情况。

```
myCharacteristic.value = request.value;
```

最后返回响应写请求的结果

```
[myPeripheralManager respondToRequest:[requests objectAtIndex:0]
        withResult:CBATTErrorSuccess];
```

**Note:** 同样的，`peripheralManager:didReceiveWriteRequests:`和`respondToRequest:withResult:`是成对出现的。

## 0x05 - Sending Updated Characteristic Values to Subscribed Centrals

通常，已经连接了的centrals会订阅一个或者多个characteristic的值，当有订阅的时候会调用这个回调函数

```
- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
 
    NSLog(@"Central subscribed to characteristic %@", characteristic);
    ...
```

之后通过调用`updateValue:forCharacteristic:onSubscribedCentrals:`这个方法向订阅者通知值的更新

```
NSData *updatedValue = // fetch the characteristic's new value
    BOOL didSendValue = [myPeripheralManager updateValue:updatedValue
        forCharacteristic:characteristic onSubscribedCentrals:nil];
```

这里的最后一个参数置为`nil`表示有链接到或者订阅的central就可以收到消息，其他的则被忽略。

另外，更新完成之后想要知道消息是否已经正确发送到订阅者那里了，可以通过`updateValue:forCharacteristic:onSubscribedCentrals:`来确定，如果传送队列没有空间进行发送消息了，则会返回NO，此时可以调用`peripheralManagerIsReadyToUpdateSubscribers:`这个方法做延时发送，当队列有空余空间的时候则会继续开始发送

拓展链接：

[ios蓝牙开发（二）ios连接外设的代码实现](http://liuyanwei.jumppo.com/2015/08/14/ios-BLE-2.html)

[ios蓝牙开发（三）app作为外设被连接的实现](http://liuyanwei.jumppo.com/2015/09/07/ios-BLE-3.html)