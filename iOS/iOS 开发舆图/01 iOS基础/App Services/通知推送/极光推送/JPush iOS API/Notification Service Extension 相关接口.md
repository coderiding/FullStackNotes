### 支持的版本
Notification Service Extension SDK v1.0.0（随 JPush iOS SDK 3.0.7 版本发布）及以后的版本

### 功能说明
使用 Notification Service Extension SDK 上报推送送达情况

### jpushSetAppkey:
设置 appkey 接口，必须提前调用

### 接口定义
```
+ (void)jpushSetAppkey:(NSString *)appkey
```
参数说明
appkey 需要和 main app 中的 JPush SDK 的 appkey 保持一致
jpushReceiveNotificationRequest:with:
消息送达统计接口，调用该接口上报 APNs 消息体中的 JPush 相关数据

### 接口定义
```
+ (void)jpushReceiveNotificationRequest:(UNNotificationRequest *)request with:(void (^)(void))completion
```
参数说明
request UNNotificationRequest
completion 消息送达上报回调，请在该回调中执行显示 APNs 等操作
setLogOff
关闭日志
默认为开启，建议发布时关闭以减少不必要的 IO

### 接口定义
+ (void)setLogOff