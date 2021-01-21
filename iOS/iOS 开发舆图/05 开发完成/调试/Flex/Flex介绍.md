- [https://github.com/Flipboard/FLEX](https://github.com/Flipboard/FLEX)
- FLEX（Flipboard Explorer）是一套用于iOS开发的应用内调试和探索工具。
显示时，FLEX显示一个工具栏，该工具栏位于应用程序上方的窗口中。在此工具栏中，
您可以查看和修改正在运行的应用程序中的几乎所有状态。
当我们想要在地铁、路上、公交车上、公园等等地方对APP应用进行调试的时候，
FLEX便是利器。你不需要Xcode，不需要LLDB。一切都在手机里。

## FLEX主要功能：

- 检查并修改层次结构中的视图。
- 查看任何对象的属性和ivars。
- 动态修改许多属性和ivars。
- 动态调用实例和类方法。
- 通过计时，标题和完整响应观察详细的网络请求历史记录。
- 添加自己的模拟器键盘快捷键。
- 查看系统日志消息（例如，来自NSLog）。
- 通过扫描堆访问任何活动对象。
- 在应用程序的沙箱中查看文件系统。
- 浏览文件系统中的SQLite / Realm数据库。
- 使用控制键，移位键和命令键在模拟器中触发3D触摸。
- 浏览应用程序和链接系统框架（公共和私有）中的所有类。
- 快速访问有用的对象，例如[UIApplication sharedApplication]应用程序委托，关键窗口上的根视图控制器等。
- 动态查看和修改NSUserDefaults值。

## 在制定项目中添加Flex

```
接入FLEX
 pod 'FLEX', :configurations => ['Debug']
 
 
#if DEBUG
#import "FLEXManager.h"
#endif

#if DEBUG
[[FLEXManager sharedManager] showExplorer];
#endif

```

## Flex其他触发方法

- FLEX触发方法一
- 在模拟器中可以通过点击键盘的F键调出FLEX。
- 在真机中我设置通过摇一摇调出FLEX:

```
#import "UIWindow+TTFLEXSetting.h"

#if DEBUG
#import "FLEXManager.h"
#endif

@implementation UIWindow (TTFLEXSetting)
#if DEBUG
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionBegan:motion withEvent:event];
    
    if (motion == UIEventSubtypeMotionShake) {
        [[FLEXManager sharedManager] showExplorer];

    }
}
#endif

```