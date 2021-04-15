---
title: CoreBluetooth 蓝牙开发（后台模式、状态保存与恢复）
tags:
  - 蓝牙
  - 后台模式
categories: 蓝牙
abbrlink: 56111
date: 2016-06-15 12:11:03
---

最近新进一家公司，主要是做物联网这一块的的，项目需要用到蓝牙开发，讲真的，挑战还是挺大的，做了差不多四年的iOS开发，从没有接触过蓝牙开发这一领域，我是这样学习的。

从网上找各种博客（国内的，国外的），借鉴别人写过的Demo以及官方文档，花了整整的一周时间，对iOS的CoreBluetooth这个框架的使用稍微有一些的了解，请听我一一道来；

# iOS 蓝牙

> 简称：BLE（buletouch low energy），蓝牙 4.0 设备因为低耗电，所以也叫做 BLE，CoreBluetooth框架就是苹果公司为我们提供的一个库，我们可以使用这个库和其他支持蓝牙4.0的设备进行数据交互。值得注意的是在IOS10之后的APP中，我们需要在 info.plist文件中添加NSBluetoothPeripheralUsageDescription字段否则APP会崩溃

> 工作模式：蓝牙通信中，首先需要提到的就是 central 和 peripheral 两个概念。这是设备在通信过程中扮演的两种角色。直译过来就是 [中心] 和 [周边（可以理解为外设）]。iOS 设备既可以作为 central，也可以作为 peripheral，这主要取决于通信需求。

自己尝试的写了个[Demo](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2FDeanMr%2FMSBBlueTooth),实现的功能有：



```undefined
1、通过已知外围设备的服务UUID搜索（这个UUID是指被广播出来的服务UUID）；
2、连接指定的外围设备；
3、获取指定的服务，发现需要订阅的特征；
4、接收外围设备发送的数据；
5、向外围设备写数据；
6、实现蓝牙服务的后台模式；
7、实现蓝牙服务的状态保存与恢复（应用被系统杀死的时候，系统会自动保存 central manager 的状态）；
```

# 中心角色的实现：（central）

## （1）、初始化中央管理器对象

<!-- more -->

```cpp
/**
第一个参数：代理
第二个参数：队列（nil为不指定队列，默认为主队列）
第三个参数：实现状态保存的时候需要用到 eg:@{CBCentralManagerOptionRestoreIdentifierKey:@"centralManagerIdentifier"} 
*/  
centerManager = [[CBCentralManager alloc]initWithDelegate:self queue:queue options:options];
```

中央管理器会调用 centralManagerDidUpdateState:通知蓝牙的状态

## (2)、发现外围设备



```csharp
[centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options：nil];
```

每次中央管理器发现外围设备时，它都会调用centralManager:didDiscoverPeripheral:advertisementData:RSSI:其委托对象的方法。

## (3)、发现想要的外围设备进行连接



```objectivec
#pragma mark -- 扫描发现到任何一台设备都会通过这个代理方法回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //过滤掉无效的结果
    if (peripheral == nil||peripheral.identifier == nil/*||peripheral.name == nil*/)
    {
        return;
    }
    
    NSString *pername =[NSString stringWithFormat:@"%@",peripheral.name];
    NSLog(@"所有服务****：%@",peripheral.services);

    NSLog(@"蓝牙名字：%@  信号强弱：%@",pername,RSSI);
   //连接需要的外围设备
    [self connectPeripheral:peripheral];
    //将搜索到的设备添加到列表中
    [self.peripherals addObject:peripheral];
    
    if (_didDiscoverPeripheralBlock) {
        _didDiscoverPeripheralBlock(central,peripheral,advertisementData,RSSI);
    }
}
```

如果连接请求成功，则中央管理器调用centralManager:didConnectPeripheral:其委托对象的方法。

## （4）、发现所连接的外围设备的服务



```csharp
#pragma mark -- 连接成功、获取当前设备的服务和特征 并停止扫描
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@",peripheral);
    
    // 设置设备代理
    [peripheral setDelegate:self];
    // 大概获取服务和特征
    [peripheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];
    
    NSLog(@"Peripheral Connected");
    
    if (_centerManager.isScanning) {
        [_centerManager stopScan];
    }
    NSLog(@"Scanning stopped");
    
}
```

发现指定的服务时，外围设备（CBPeripheral你连接的对象）会调用peripheral:didDiscoverServices:其委托对象的方法。

## (5)、发现服务的特征



```objectivec
#pragma mark -- 获取当前设备服务services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"所有的servicesUUID%@",peripheral.services);   
    //遍历所有service
    for (CBService *service in peripheral.services)
    {
        NSLog(@"服务%@",service.UUID);
        //找到你需要的servicesuuid
        if ([[NSString stringWithFormat:@"%@",service.UUID] isEqualToString:SERVICE_UUID])
        {
            // 根据UUID寻找服务中的特征
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHARACTERISTIC_UUID]] forService:service];
        }
    }
}
```

peripheral:didDiscoverCharacteristicsForService:error:当发现指定服务的特征时，外围设备调用其委托对象的方法。

## (6)、检索特征价值

阅读特征的值 ()



```csharp
 [peripheral readValueForCharacteristic：interestingCharacteristic];
```

> 注意：  并非所有特征都是可读的。你可以通过检查其properties属性是否包含CBCharacteristicPropertyRead常量来确定特征是否可读。如果尝试读取不可读的特征值，则peripheral:didUpdateValueForCharacteristic:error:委托方法将返回合适的错误。

#### 订阅特征的值（）

虽然使用该readValueForCharacteristic:方法读取特征值对静态值有效，但它不是检索动态值的最有效方法。检索随时间变化的特征值 - 例如，你的心率 - 通过订阅它们。订阅特征值时，您会在值更改时收到外围设备的通知。



```csharp
[peripheral setNotifyValue：YES forCharacteristic：interestingCharacteristic];
```

> 注意：  并非所有特征都提供订阅。你可以通过检查特性是否properties包含其中一个CBCharacteristicPropertyNotify或多个CBCharacteristicPropertyIndicate常量来确定特征是否提供订阅。
>  当你订阅（或取消订阅）特征的值时，外围设备会调用peripheral:didUpdateNotificationStateForCharacteristic:error:其委托对象的方法。

#### 写一个特征的值 ()

有时写一个特征的值是有意义的。例如，如果你的应用程序与蓝牙低功耗数字恒温器交互，你可能需要为恒温器提供设置房间温度的值。如果特征值是可写的，则可以NSData通过调用外设writeValue:forCharacteristic:type:方法将数据值;



```objectivec
[self.discoveredPeripheral writeValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithResponse];
```

> 写入特征的值时，指定要执行的写入类型。在上面的示例中，写入类型CBCharacteristicWriteWithResponse指示外围设备通过调用peripheral:didWriteValueForCharacteristic:error:其委托对象的方法让您的应用程序知道写入是否成功。

# 外围角色的实现

## （1）、初始化外围设备管理器



```objectivec
peripheralManager = [[CBPeripheralManager alloc] initWithDelegate：self queue：nil options：nil];
```

创建外围设备管理器时，外围设备管理器会调用peripheralManagerDidUpdateState:其委托对象的方法。您必须实现此委托方法，以确保支持蓝牙低功耗并可在本地外围设备上使用。

## （2）、设置服务和特征

> 为自定义服务和特征创建自己的UUID
>  在终端使用 uuidgen 命令获取以ASCII字符串形式的128位值的UUID：71DA3FD1-7E10-41C1-B16F-4430B506CDE7

> 构建服务树和特征



```csharp
myCharacteristic =[[CBMutableCharacteristic alloc] initWithType：myCharacteristicUUID properties：CBCharacteristicPropertyRead value：myValue permissions：CBAttributePermissionsReadable];   //特征
 myService = [[CBMutableService alloc] initWithType：myServiceUUID primary：YES];    //与特征所关联的服务

myService.characteristics = @ [myCharacteristic];        //设置服务的特征数组,将特征与其关联
```

## （3）、发布服务和特征



```csharp
  [peripheralManager addService：myService];
```

> 当调用此方法发布服务时，外围管理器将调用peripheralManager:didAddService:error:其委托对象的方法。通过error可以知道是否发布成功;
>  将服务及其任何关联特性发布到外围设备的数据库后，该服务将被缓存，将无法再对其进行更改。

## （4）、广播服务



```csharp
  [peripheralManager startAdvertising：@ {CBAdvertisementDataServiceUUIDsKey：@[myFirstService.UUID，mySecondService.UUID]}];
```

当开始在本地外围设备上公布某些数据时，外围设备管理器会调用peripheralManagerDidStartAdvertising:error:其委托对象的方法。

## （5）、响应来自中央的读取和写入请求

当连接的中央请求读取某个特征的值时，外围管理器会调用peripheralManager:didReceiveReadRequest:其委托对象的方法。



```csharp
 [peripheralManager respondToRequest：request withResult：CBATTErrorInvalidOffset]; 
```

设置读取请求不要求从超出特征值的边界的索引位置读取



```csharp
  request.value = [myCharacteristic.value subdataWithRange：NSMakeRange（request.offset，myCharacteristic.value.length  -  request.offset）];  
```

将请求的特性属性（默认值为nil）的值设置为您在本地外围设备上创建的特征值，同时考虑读取请求的偏移量

> 设置值后，响应远程中央以指示请求已成功完成。通过调用类的respondToRequest:withResult:方法CBPeripheralManager，传回请求（其更新的值）和请求的结果

> 当连接的中心发送写入一个或多个特征值的请求时，外围管理器会调用peripheralManager:didReceiveWriteRequests:其委托对象的方法

## （6）、将更新的特征值发送到订阅的中心

> 当连接的中心订阅某个特征的值时，外围管理器会调用peripheralManager:central:didSubscribeToCharacteristic:其委托对象的方法
>  获取特征的更新值，并通过调用类的updateValue:forCharacteristic:onSubscribedCentrals:方法将其发送到中心CBPeripheralManager。

# 处理常驻后台任务

> 首先需要在Capabilities-->Background Modes申请中心角色的后台模式说明

如图：



![img](https:////upload-images.jianshu.io/upload_images/1206879-bf1c287cdb8f1952.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/835/format/webp)

中心角色后台模式.jpg

## （1）、状态保存与恢复

因为状态的保存和恢复 Core Bluetooth 都为我们封装好了，所以我们只需要选择是否需要这个特性即可。系统会保存当前 central manager 或 peripheral manager，并且继续执行蓝牙相关事件（即使程序已经不再运行）。一旦事件执行完毕，系统会在后台重启 app，这时你有机会去存储当前状态，并且处理一些事物。在之前提到的 “门锁” 的例子中，系统会监视连接请求，并在 centralManager:didConnectPeripheral: 回调时，重启 app，在用户回家后，连接操作结束。

> Core Bluetooth 的状态保存与恢复在设备作为 central、peripheral 或者这两种角色时，都可用。在设备作为 central 并添加了状态保存与恢复支持后，如果 app 被强行关闭进程，系统会自动保存 central manager 的状态（如果 app 有多个 central manager，你可以选择哪一个需要系统保存）。

对于 CBCentralManager，系统会保存以下信息：

> central 准备连接或已经连接的 peripheral
>  central 需要扫描的 service（包括扫描时，配置的 options）
>  central 订阅的 characteristic
>  对于 peripheral 来说，情况也差不多。系统对 CBPeripheralManager 的处理方式如下：
>  peripheral 在广播的数据
>  peripheral 存入的 service 和 characteristic 的树形结构
>  已经被 central 订阅了的 characteristic 的值
>  当系统在后台重新加载程序后（可能是因为找到了要找的 peripheral），你可以重新实例化 central manager 或 peripheral 并恢复他们的状态。

## （2）、选择支持存储和恢复

> 如果要支持存储和恢复，则需要在初始化 manager 的时候给一个 restoration identifier。restoration identifier 是 string 类型，并标识了 app 中的 central manager 或 peripheral manager。这个 string 很重要，它将会告诉 Core Bluetooth 需要存储状态，毕竟 Core Bluetooth 恢复有 identifier 的对象。

例如，在 central 端，要想支持该特性，可以在调用 CBCentralManager 的初始化方法时，配置 CBCentralManagerOptionRestoreIdentifierKey：



```objectivec
centralManager = [[CBCentralManager alloc] initWithDelegate:self 
queue:nil
options:@{CBCentralManagerOptionRestoreIdentifierKey:@"centralManagerIdentifier"}];
```

虽然以上代码没有展示出来，其实在 peripheral manager 中要设置 identifier 也是这样的。只是在初始化时，将 key 改成了 CBPeripheralManagerOptionRestoreIdentifierKey。
 因为程序可以有多个 CBCentralManager 和 CBPeripheralManager，所以要确保每个 identifier 都是唯一的。

## （3）、重新初始化 central manager 和 peripheral manager

> 当系统重新在后台加载程序时，首先需要做的即根据存储的 identifier，重新初始化 central manager 或 peripheral manager。如果你只有一个 manager，并且 manager 存在于 app 生命周期中，那这个步骤就不需要做什么了。
>  .
>  如果 app 中包含多个 manager，或者 manager 不是在整个 app 生命周期中都存在的，那 app 就必须要区分你要重新初始化哪个 manager 了。你可以通过从 app delegate 中的 application:didFinishLaunchingWithOptions: 中取出 key（UIApplicationLaunchOptionsBluetoothCentralsKey 或 UIApplicationLaunchOptionsBluetoothPeripheralsKey）中的 value（数组类型）来得到程序退出之前存储的 manager identifier 列表：



```objectivec
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

NSArray *centralManagerIdentifiers =
    launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
    if (centralManagerIdentifiers.count) {
        //重新初始化所有的 manager 
        for (NSString *identifier in centralManagerIdentifiers) {
            NSLog(@"系统启动项目");
            //在这里创建的蓝牙实例一定要被当前类持有，不然出了这个函数就被销毁了，蓝牙检测会出现“XPC connection invalid”
            self.bluetooth = [[MSBBlueTooth alloc]initWithQueue:nil options:@{CBCentralManagerOptionRestoreIdentifierKey : identifier}];
            NSLog(@"");
        }
    }

return YES;
}
```

## （4）、实现恢复状态的代理方法

> 在重新初始化 manager 之后，接下来需要同步 Core Bluetooth 存储的他们的状态。要想弄清楚在程序被退出时都在做些什么，就需要正确的实现代理方法。对于 central manager 来说，需要实现 centralManager:willRestoreState:；对于 peripheral manager 来说，需要实现 peripheralManager:willRestoreState:。
>  .
>  注意：如果选择存储和恢复状态，当系统在后台重新加载程序时，首先调用的方法是 centralManager:willRestoreState: 或 peripheralManager:willRestoreState:。如果没有选择存储的恢复状态（或者唤醒时没有什么内容需要恢复），那么首先调用的方法是 centralManagerDidUpdateState: 或 peripheralManagerDidUpdateState:。
>  .
>  无论是以上哪种代理方法，最后一个参数都是一个包含程序退出前状态的字典。字典中，可用的 key ，



```objectivec
central 端有：
NSString *const CBCentralManagerRestoredStatePeripheralsKey;
NSString *const CBCentralManagerRestoredStateScanServicesKey;
NSString *const CBCentralManagerRestoredStateScanOptionsKey;

peripheral 端有：
NSString *const CBPeripheralManagerRestoredStateServicesKey;
NSString *const CBPeripheralManagerRestoredStateAdvertisementDataKey;
```

要恢复 central manager 的状态，可以用 centralManager:willRestoreState: 返回字典中的 key 来得到。假如说 central manager 有想要或者已经连接的 peripheral，那么可以通过 CBCentralManagerRestoredStatePeripheralsKey 对应得到的 peripheral（CBPeripheral 对象）数组来得到。



```objectivec
- (void)centralManager:(CBCentralManager *)central
willRestoreState:(NSDictionary *)state {
NSArray *peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey];
    //讲状态保存的设备加入列表，在蓝牙检测状态的回调里实现重连
    self.peripherals = [NSMutableArray arrayWithArray:peripherals];

}
```

> 具体要对拿到的 peripheral 数组做什么就要根据需求来了。如果这是个 central manager 搜索到的 peripheral 数组，那就可以存储这个数组的引用，并且开始建立连接了（注意给这些 peripheral 设置代理，否则连接后不会走 peripheral 的代理方法）。
>  .
>  恢复 peripheral manager 的状态和 central manager 的方式类似，就只是把代理方法换成了 peripheralManager:willRestoreState:，并且使用对应的 key 即可

写的不是很好，也算是东拼西凑了，但也是花了时间去整理的，如果看不懂，可以下载我的Demo自己跑一遍；

