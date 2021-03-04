
### 支持的版本
v1.7.4 及后续版本

### 功能说明
badge 是 iOS 用来标记应用程序状态的一个数字，出现在程序图标右上角。 JPush 封装 badge 功能，允许应用上传 badge 值至 JPush 服务器，由 JPush 后台帮助管理每个用户所对应的推送 badge 值，简化了设置推送 badge 的操作。

实际应用中，开发者可以直接对 badge 值做增减操作，无需自己维护用户与 badge 值之间的对应关系。 推送消息时，只需设置角标 +1，极光会在服务器中存储的每个用户的 badge 值上自动 +1 后下发给用户。

### API setBadge
设置 JPush 服务器中存储的 badge 值

接口定义
```
+ (BOOL)setBadge:(int)value
```

参数说明
```
value 取值范围：[0,99999]
```
本地仍须调用 UIApplication:setApplicationIconBadgeNumber 函数设置图标上显示的 badge 值



返回值
在 value 的取值区间内返回 TRUE，否则返回 FALSE

### API resetBadge
清空 JPush 服务器中存储的 badge 值，即 [setBadge:0]

接口定义
+ (void)resetBadge