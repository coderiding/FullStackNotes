说明
iOS 10新增了Service Extension
官方给出的说明图如下

![b62uVP](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/b62uVP.png)

这意味着在APNs到达我们的设备之前，还会经过一层允许用户自主设置的Extension服务进行处理，为APNs增加了多样性。

### 使用方法
Service Extension使用起来很容易上手，首先我们需要创建一个Service Extension服务,如下图

![INARjx](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/INARjx.png)

然后这里需要注意几个点

Service Extension的Bundle Identifier不能和Main Target（也就是你自己的App Target）的Bundle Identifier相同，否则会报BundeID重复的错误。

Service Extension的Bundle Identifier需要在Main Target的命名空间下，比如说
Main Target的BundleID为io.jpush.xxx，那么Service Extension的BundleID应该类似与io.jpush.xxx.yyy这样的格式。如果不这么做，你可能会遇到一个错误。

那么现在你的Service Extension服务已经创建成功了，此时你已经成功的使用了Service Extension，但是好像我们还没有对它做什么操作，看看你的项目，你得到了一个类，这个类中包含两个方法。

didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent *contentToDeliver))contentHandler

serviceExtensionTimeWillExpire

我们来看一下第一个方法的官方解释：Call contentHandler with the modified notification content to deliver. If the handler is not called before the service's time expires then the unmodified notification will be delivered。 简单解释一下，APNs到来的时候会调用这个方法，此时你可以对推送过来的内容进行处理，然后使用contentHandler完成这次处理。但是如果时间太长了，APNs就会原样显示出来。 也就是说，我们可以在这个方法中处理我们的通知，个性化展示给用户。 而第二个方法，是对第一个方法的补救。第二个方法会在过期之前进行回调，此时你可以对你的APNs消息进行一下紧急处理。
