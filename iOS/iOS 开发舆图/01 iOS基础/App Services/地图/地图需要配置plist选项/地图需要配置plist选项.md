### iOS 8 - iOS 10 版本：
```
NSLocationAlwaysUsageDescription
申请Always权限，以便应用在前台和后台（suspend 或 terminated）都可以获取到更新的位置数据。

NSLocationWhenInUseUsageDescription
表示应用在前台的时候可以搜到更新的位置信息。
```

### iOS 11 版本：
```
NSLocationAlwaysAndWhenInUseUsageDescription
申请Always权限，以便应用在前台和后台（suspend 或 terminated）
都可以获取到更新的位置数据（NSLocationWhenInUseUsageDescription 也必须有）。
```

### iOS14
```
NSLocationTemporaryUsageDescriptionDictionary
申请临时精确定位权限

```

高德地图定位SDK适配iOS14介绍
https://app.yinxiang.com/shard/s35/nl/9757212/915f19db-7925-4f81-b711-7720df4685cc

### 注意：
如果需要同时支持在iOS8-iOS10和iOS11系统上后台定位，建议在plist文件中同时添加NSLocationWhenInUseUsageDescription、NSLocationAlwaysUsageDescription和NSLocationAlwaysAndWhenInUseUsageDescription权限申请。