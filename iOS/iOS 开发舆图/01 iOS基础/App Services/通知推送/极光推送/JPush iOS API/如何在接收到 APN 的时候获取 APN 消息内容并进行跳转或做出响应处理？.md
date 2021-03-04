iOS 设备收到一条推送（APNs），用户点击推送通知打开应用时，应用程序根据状态不同进行处理需在 AppDelegate 中的以下两个方法中添加代码以获取 apn 内容

### app为启动

* 如果 App 状态为未运行，此函数将被调用，如果 launchOptions 包含 UIApplicationLaunchOptionsRemoteNotificationKey 表示用户点击 apn 通知导致 app 被启动运行；如果不含有对应键值则表示 App 不是因点击 apn 而被启动，可能为直接点击 icon 被启动或其他。

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; 
// apn 内容获取：
NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]
```

### iOS6及以下
* 基于 iOS 6 及以下的系统版本，如果 App 状态为正在前台或者点击通知栏的通知消息，那么此函数将被调用，并且可通过 AppDelegate 的 applicationState 是否为 UIApplicationStateActive 判断程序是否在前台运行。此种情况在此函数中处理：

```
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
```

### iOS7及以上
* 基于 iOS 7 及以上的系统版本，如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
```
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
```

### iOS 10 及以上

* 基于 iOS 10 及以上的系统版本，原 [application: didReceiveRemoteNotification:] 将会被系统废弃，
由新增 UserNotifications Framework中的[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:]
或者 [UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] 方法替代。
在 2.1.9 版本及以上可实现 SDK 封装的 JPUSHRegisterDelegate 协议方法，适配 iOS10 新增的 delegate 协议方法。
即以下两个方法：

```
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler; 
// NSDictionary * userInfo = notification.request.content.userInfo; 
// APNs 内容为 userInfo

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler; 
// NSDictionary * userInfo = response.notification.request.content.userInfo; 
// APNs 内容为 userInfo
```

### iOS12以上的版本

基于iOS12以上的版本，UserNotifications Framework新增回调方法[userNotificationCenter:openSettingsForNotification:],在3.1.1及以上版本JPUSHRegisterDelegate同样新增了对应的回调方法。当从应用外部通知界面或通知设置界面进入应用时，该方法将回调。

```
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
  if (notification) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
}
```