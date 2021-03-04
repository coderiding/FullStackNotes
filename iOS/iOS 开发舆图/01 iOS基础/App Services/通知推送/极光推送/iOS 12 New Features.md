### 推送分组
iOS 12 中同一类型的通知会被合成一个通知组，用户可以通过点击通知组展开组里的所有通知

通知分组使用两种分组方式：自动分组（Automatic grouping）和线程标识（Thread identifier）。开发者不需要对自动分组做额外的操作，系统会根据App的 bundleId 对推送进行分组。如果需要对通知做更细致的分组就需要用上 线程标识了。

![WGimBs](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/WGimBs.png)

![AsNnGl](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/AsNnGl.png)

用户可以对分组进行设置(自动、按应用、关闭)

线程标识（Thread identifier)这个属性在iOS10就已经存在，但是在iOS12才真正实现分组功能。

```
// The unique identifier for the thread or conversation related to this notification request. It will be used to visually group notifications together.
@property (NS_NONATOMIC_IOSONLY, copy) NSString *threadIdentifier __TVOS_PROHIBITED;
```

### 摘要格式设置
通知自动分组后，在最下边会有一个消息摘要。默认格式是: 还有n个通知。这个格式是可以定制的。 第一种:通过UNNotificationCategory进行格式定制
```
+ (instancetype)categoryWithIdentifier:(NSString *)identifier
                               actions:(NSArray<UNNotificationAction *> *)actions
                     intentIdentifiers:(NSArray<NSString *> *)intentIdentifiers
         hiddenPreviewsBodyPlaceholder:(nullable NSString *)hiddenPreviewsBodyPlaceholder
                 categorySummaryFormat:(nullable NSString *)categorySummaryFormat
                               options:(UNNotificationCategoryOptions)options __IOS_AVAILABLE(12.0) __WATCHOS_PROHIBITED;

```

#### 第二种:通过UNNotificationContent进行定制
```
/// The argument to be inserted in the summary for this notification.
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *summaryArgument __IOS_AVAILABLE(12.0) __WATCHOS_PROHIBITED __TVOS_PROHIBITED;

/// A number that indicates how many items in the summary are represented in the summary.
/// For example if a podcast app sends one notification for 3 new episodes in a show,
/// the argument should be the name of the show and the count should be 3.
/// Default is 1 and cannot be 0.
@property (NS_NONATOMIC_IOSONLY, readonly, assign) NSUInteger summaryArgumentCount __IOS_AVAILABLE(12.0) __WATCHOS_PROHIBITED __TVOS_PROHIBITED;

```

### 通知管理
苹果针对消息增加了一个"管理"的按钮，消息左滑即可出现。

![482cZv](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/482cZv.png)

### 临时授权

临时授权主要体现就是推送消息过来会有两个按钮，会主动让用户自己选择

![ZSw6zq](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/ZSw6zq.png)

### 警告通知

比如家庭安全、健康、公共安全等因素的时候。此消息需要用户必须采取行动。最简单的一个场景是家里安装了一个摄像头，我们去上班了，此时如果家中有人，则摄像头会推送消息给我们。这类通知需要申请特别的证书。

![OMaJGK](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/OMaJGK.png)