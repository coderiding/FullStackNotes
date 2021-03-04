### 支持版本
v1.8.0 版本开始。

本次iOS 8在推送方面最大的变化就是修改了推送的注册接口，在原本的推送type的基础上，增加了一个categories参数，这个参数的目的是用来注册一组和通知关联起来的button的事件。
这个categories由一系列的 UIUserNotificationCategory组成。每个UIUserNotificationCategory对象包含你的app用来响应本地或者远程通知的信息。每一个对象的title作为通知上每一个button的title展示给用户。当用户点击了某一个button，系统将会调用应用内的回调函数application:handleActionWithIdentifier:forRemoteNotification:completionHandler:或者application:handleActionWithIdentifier:forLocalNotification:completionHandler:。

### 客户端设置
使用UIUserNotificationCategory

```
if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

 NSMutableSet *categories = [NSMutableSet set];

 UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];

 category.identifier = @"identifier";

 UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];

 action.identifier = @"test2";

 action.title = @"test";

 action.activationMode = UIUserNotificationActivationModeBackground;

 action.authenticationRequired = YES;

 //YES显示为红色，NO显示为蓝色
 action.destructive = NO;

 NSArray *actions = @[ action ];

 [category setActions:actions forContext:UIUserNotificationActionContextMinimal];

 [categories addObject:category];
}
```

### 使用UIUserNotificationType

```
if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)                      categories:categories];
}else{
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)                      categories:nil];
}
```

### 使用回调函数
```
// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
```

### 服务端设置

服务端payload格式:aps增加category字段，当该字段与客户端UIMutableUserNotificationCategory的identifier匹配时，触发设定的action和button显示。

```
payload example:
{"aps":{"alert":"example", "sound":"default", "badge": 1, "category":"identifier"}}

```