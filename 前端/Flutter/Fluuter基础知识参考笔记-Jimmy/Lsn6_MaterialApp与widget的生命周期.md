# Lsn6.MaterialApp与widget的生命周期



[TOC]



## runApp
Flutter是Dart语言的移动应用框架，runApp函数就是Flutter框架的入口，如果不调用runApp函数，那你执行的就是一个Dart控制台应用。项目也可以正常执行，但是屏幕上什么都不会显示。



## MaterialApp--22个参数
| 字段                          | 类型                            | 作用                                                 |
| ----------------------------- | ------------------------------- | ---------------------------------------------------- |
| navigatorKey                  | Globalkey                       | 导航键                                               |
| home                          | widget                          | 主页                                                 |
| routes                        | Map<String,WidgetBuilder>       | 路由表                                               |
| initialRoute                  | String                          | 初始路由                                             |
| onGenerateRoute               | RouteFactory                    | 生成路由                                             |
| onUnknownRoute                | RouteFactory                    | 未知路由                                             |
| navigatorObservers            | List                            | 导航监听器                                           |
| builder                       | TransitionBuilder               | widget的构建者                                       |
| title                         | String                          | 任务管理器中应用程序标题                             |
| onGenerateTitle               | GenerateAppTitle                | 生成标题，每次在WidgetsApp构建时都会重新生成         |
| color                         | Color                           | 任务管理器中应用程序title颜色                        |
| theme                         | ThemeData                       | 主题                                                 |
| locale                        | Locale                          | app语言支持                                          |
| localizationsDelegates        | Iterable<LocalizationsDelegate> | 多语言代理                                           |
| localeResolutionCallback      | LocaleResolutionCallback        | 区域分辨回调                                         |
| supportedLocales              | Iterable                        | 支持的多语言                                         |
| debugShowMaterialGrid         | bool                            | 调试显示材质网格                                     |
| showPerformanceOverlay        | bool                            | 打开性能监控，覆盖在屏幕最上面                       |
| checkerboardRasterCacheImages | bool                            | 棋盘格光栅缓存图像                                   |
| checkerboardOffscreenLayers   | bool                            | 棋盘格层                                             |
| showSemanticsDebugger         | bool                            | 打开一个覆盖图，显示框架报告的可访问性信息，显示边框 |
| debugShowCheckedModeBanner    | bool                            | 右上角显示一个debug的图标                            |

### routes
1. 如果应用只有一个界面，则不用设置这个属性，使用 home 设置这个界面即可。
2. 当使用 Navigator.pushNamed 推送命名路由的时候，会在 routes 查找路由名字，然后使用对应的 WidgetBuilder 来构造一个带有页面切换动画的 MaterialPageRoute。
3. 如果所查找的路由在 routes 中不存在，则会通过 onGenerateRoute 来查找。
4. 如果home不为null，当routes中包含Navigator.defaultRouteName(或者'/')的时候会出错，两个冲突了。

### initialRoute
1. 指定默认显示的路由名字，当用户进入程序时，自动打开对应的路由。 (home还是位于一级) 
2. 默认值为 Window.defaultRouteName

### builder
跟home的作用一样，优先级最高，initialRoute的设置也无效

### title、onGenerateTitle
两个同时设置，onGenerateTitle生效



## 生命周期
flutter中的视图Widget像Android中的Activity一样存在生命周期，生命周期的回调函数体都在State中。
### Widget
Widget 的实际工作就是描述如何创建 Element
Widget本身没有可变状态（所有的字段必须是final）。
### Element
Element是Widget的实例体现,是负责状态和生命周期管理的对象.
StatefulWidget通过createElement()创建StatefulElement,StatefulElement 内部会负责创建和保存 State，这就是为什么 StatefulWidget 被重新创建了而内部的状态不会丢失的原因。
### RenderObject
负责视图渲染。所有的布局、绘制和事件响应全都由它负责

```
//创建的调用
initState--》didChangeDependencies--》build

//横竖屏
didUpdateWidget--》build

//销毁
deactivate--》dispose

//点击home键
AppLifecycleState.inactive--》paused
//回到程序
AppLifecycleState.inactive--》resumed

```



