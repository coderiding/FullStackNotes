Design patterns for broadcasting information and for subscribing to broadcasts.

广播信息和订阅广播的设计模式。

```Objective-C
[[NSNotificationCenter defaultCenter] 
addObserver:self selector:@selector(getNotificationAction) name:@"ThisIsANoticafication" object:nil];


[[NSNotificationCenter defaultCenter] 
postNotificationName:@"ThisIsANoticafication" object:nil];


//在发送通知时设置object参数
[[NSNotificationCenter defaultCenter] 
postNotificationName:@"ThisIsANoticafication" object:@{@"parameter1":@"1",@"parameter2":@"2"}];


[[NSNotificationCenter defaultCenter] 
addObserver:self selector:@selector(getNotificationAction:) name:@"ThisIsANoticafication" object:nil];


//通知接收参数
- (void)getNotificationAction:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    // 这样就得到了我们在发送通知时候传入的字典了
}
```