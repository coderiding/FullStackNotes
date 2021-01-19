- **初始化delegate参数介绍**
- 遵守<CBCentralManagerDelegate>协议

```objectivec
// 必须实现的方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
// 可选实现的方法
// 汶：蓝牙BLE从后台恢复的时候，需要实现的代理方法，比如通过CBCentralManagerRestoredStatePeripheralsKey这个key获取ble设备列表
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict;
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;
- (void)centralManager:(CBCentralManager *)central connectionEventDidOccur:(CBConnectionEvent)event forPeripheral:(CBPeripheral *)peripheral NS_AVAILABLE_IOS(13_0);
- (void)centralManager:(CBCentralManager *)central didUpdateANCSAuthorizationForPeripheral:(CBPeripheral *)peripheral NS_AVAILABLE_IOS(13_0);
```

### **初始化queue参数介绍**

- 如果传nil，就是在main主线程，如果你使用蓝牙进行一些很轻的操作时选用
- dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0) 全局队列，会创建多个线程，会出现线程加锁的问题。
- 串行队列DispatchQueue(label: "CentralManager")，这个是最佳实践，如果使用这个队列，需要在刷新UI的时候，切换到主队列去执行，否则会报错，(由于太多的地方需要切换主线程刷新，所以)我现在一般用dispatch_get_main_queue()主队列创建这个central。
- 当我在创建centralManager时指定了一个通过dispatch_queue_create自建的queue，CentralManager的回调函数会不会在同一个线程返回呢？
    - 会在不同线程返回，这个问题会有线程同步和线程加锁的问题存在，因为不同线程操作同一个数据会有问题。

    ### **初始化options参数介绍**

    - `CBCentralManagerOptionRestoreIdentifierKey`通过这个key可以快速恢复之前保存的CBCentralManager的信息
        - 如果要支持存储和恢复，则需要在初始化 manager 的时候给一个 restoration identifier。restoration identifier 是 string 类型，并标识了 app 中的 central manager 或 peripheral manager。这个 string 很重要，它将会告诉 Core Bluetooth 需要存储状态。
        - 其实在 peripheral manager 中要设置 identifier 也是这样的。只是在初始化时，将 key 改成了`CBPeripheralManagerOptionRestoreIdentifierKey`。
        - 程序可以有多个 `CBCentralManager` 和 `CBPeripheralManager`，所以要确保每个 identifier 都是唯一的。
    - CBCentralManagerOptionShowPowerAlertKey
    - CBCentralManagerScanOptionSolicitedServiceUUIDsKey
    - CBCentralManagerRestoredStatePeripheralsKey // 恢复蓝牙BLE时使用
    - CBCentralManagerRestoredStateScanServicesKey // 恢复蓝牙BLE时使用
    - CBCentralManagerRestoredStateScanOptionsKey // 恢复蓝牙BLE时使用
    - 因为CBCentralManager 和 CBPeripheralManager可以有多个，在指定 option key 的时候需要确保 key 的唯一性

    ```objectivec
    // 初始化CBCentralManager
    /*
        1.将queue设置为nil，则表示直接在主线程中运行。
    */
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    // 或者
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    // 或者
    dispatch_queue_t  q = dispatch_queue_create("ble_queue",NULL);
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:q];
    // 或者
    _centralManager = CBCentralManager(delegate: self, queue: nil, options: 
                               [CBCentralManagerOptionRestoreIdentifierKey: "TTcentralManageRestoreIdentifier",
                                CBConnectPeripheralOptionNotifyOnDisconnectionKey: NSNumber(bool: true),
                                CBConnectPeripheralOptionNotifyOnConnectionKey: NSNumber(bool: true),
                                CBConnectPeripheralOptionNotifyOnNotificationKey: NSNumber(bool: true)])
    // 或者支持状态恢复
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{ CBCentralManagerOptionRestoreIdentifierKey: @"myCentralManagerIdentifier" }];
    ```

    ### Central的方法

    ```objectivec
    - (instancetype)init;
    - (void)stopScan;
    + (BOOL)supportsFeatures:(CBCentralManagerFeature)features NS_AVAILABLE_IOS(13_0) NS_SWIFT_NAME(supports(_:));
    - (instancetype)initWithDelegate:(nullable id<CBCentralManagerDelegate>)delegate
                               queue:(nullable dispatch_queue_t)queue;
    - (instancetype)initWithDelegate:(nullable id<CBCentralManagerDelegate>)delegate
                               queue:(nullable dispatch_queue_t)queue
                             options:(nullable NSDictionary<NSString *, id> *)options NS_AVAILABLE(10_9, 7_0) NS_DESIGNATED_INITIALIZER;
    // 扫描
    - (void)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)serviceUUIDs options:(nullable NSDictionary<NSString *, id> *)options;
    // 连接
    - (void)connectPeripheral:(CBPeripheral *)peripheral options:(nullable NSDictionary<NSString *, id> *)options;
    // 断开连接
    - (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;
    - (void)registerForConnectionEventsWithOptions:(nullable NSDictionary<CBConnectionEventMatchingOption, id> *)options NS_AVAILABLE_IOS(13_0);
    // 获取一个已知CBPeripheral的列表(过去曾经发现过或者连接过的peripheral),这个列表应该是手机系统的，不存在与app内
    - (NSArray<CBPeripheral *> *)retrievePeripheralsWithIdentifiers:(NSArray<NSUUID *> *)identifiers NS_AVAILABLE(10_9, 7_0);
    // 这个外设当前已经被手机连接，但是在另一个app中使用另一个服务，这时，你的app就要通过你自己用的那个服务来重新连接
    - (NSArray<CBPeripheral *> *)retrieveConnectedPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs NS_AVAILABLE(10_9, 7_0);
    ```

    ### Central代理centralManagerDidUpdateState

    - 初始化成功后会调用代理获取状态
    - 初始化 central manager 之后，设置的代理会调用centralManagerDidUpdateState:方法

    ```objectivec
    typedef NS_ENUM(NSInteger, CBCentralManagerState) {
        CBCentralManagerStateUnknown = 0,
        CBCentralManagerStateResetting,
        CBCentralManagerStateUnsupported,
        CBCentralManagerStateUnauthorized,
        CBCentralManagerStatePoweredOff,
        CBCentralManagerStatePoweredOn,
    };

    - (void)centralManagerDidUpdateState:(CBCentralManager *)central
    {
        NSLog(@"%@",central);
        switch (central.state) {
            case CBCentralManagerStatePoweredOn:
                NSLog(@"打开，可用");
                [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
                break;
            case CBCentralManagerStatePoweredOff:
                NSLog(@"可用，未打开");
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@"SDK不支持");
                break;
            case CBCentralManagerStateUnauthorized:
                NSLog(@"程序未授权");
                break;
            case CBCentralManagerStateResetting:
                NSLog(@"CBCentralManagerStateResetting");
                break;
            case CBCentralManagerStateUnknown:
                NSLog(@"CBCentralManagerStateUnknown");
                break;
        }
    }
    ```