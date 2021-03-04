### 功能说明
在iOS 8 之后引入了一个基于PushKit框架的Voip推送，可以使得用户的APP在杀死的情况下唤醒APP,并执行代码。
警告：在iOS 13 之后 Apple不再允许PushKit应用在非Voip电话的场景下，如果需要使用Pushkit则需要接入Callkit的接口。

### 支持版本
JPush 3.3.2 及其以后的版本，JCore 版本必须是2.2.4及其以后的版本

registerVoipToken:
向极光服务器提交Token

### 接口定义
```
+ (void)registerVoipToken:(NSData *)voipToken;
```

### 参数说明
voipToken 系统返回的Voiptoken
handleVoipNotification:
处理收到的Voip的消息，用于统计Voip下发情况

### 接口定义
```
+ (void)handleVoipNotification:(NSDictionary *)remoteInfo;
```
参数说明
remoteInfo 消息内容