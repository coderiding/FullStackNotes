## Flutter技术发展简介

* Flutter也是受React启发，很多思想也都是相通的
* Flutter 是 Google 推出并开源的移动应用开发框架，主打跨平台、高保真、高性能。开发者可以通过 Dart 语言开发 App ，一套代码同时运行在 iOS 和 Android 平台。 Flutter 提供了丰富的组件、接口，开发者可以很快地为 Flutter 添加 native 扩展。同时 Flutter 还使用 Native 引擎渲染视图，这无疑能为用户提供良好的体验。 

### Fluuter发展历史

* 2018年6月，Flutter发布了首个预览版本，这意味着 Flutter 进入了正式版（1.0）发布前的最后阶段。
* 2017 年 Google I/O 大会上， Google 首次推出了一款新的用于创建跨平台、高性能的移动应用框架 ——Flutter 。 
* 2018 年 2 月， Flutter 发布了第一个 Beta 版本，同年五月， 在 2018 年 Google I/O 大会上， Flutter 更新到了 beta 3 版本。 
* 2018 年 6 月， Flutter 发布了首个预览版本，这意味着 Flutter 进入了正式版（ 1.0 ）发布前的最后阶段。

#### 优点： 跨平台自绘引擎
* Flutter APP的Android安装包比iOS安装包小的主要原因
* Flutter 与用于构建移动应用程序的其它大多数框架不同，因为 Flutter 既不使用 WebView ，也不使用操作系统的原生控件。 相反， Flutter 使用自己的高性能渲染引擎来绘制 widget 。这样不仅可以保证在 Android 和 iOS 上 UI 的一致性，而且也可以避免对原生控件依赖而带来的限制及高昂的维护成本。 
* Flutter 使用 Skia 作为其 2D 渲染引擎， Skia 是 Google 的一个 2D 图形处理函数库，包含字型、坐标转换，以及点阵图都有高效能且简洁的表现， Skia 是跨平台的，并提供了非常友好的 API ，目前 Google Chrome 浏览器和 Android 均采用 Skia 作为其绘图引擎，值得一提的是，由于 Android 系统已经内置了 Skia ，所以 Flutter 在打包 APK(Android 应用安装包 ) 时，不需要再将 Skia 打入 APK 中，但 iOS 系统并未内置 Skia ，所以构建 iPA 时，也必须将 Skia 一起打包，这也是为什么 Flutter APP 的 Android 安装包比 iOS 安装包小的主要原因。 
* 由于 Android 系统已经内置了 Skia ，所以 Flutter 在打包 APK(Android 应用安装包 ) 时，不需要再将 Skia 打入 APK 中，但 iOS 系统并未内置 Skia ，所以构建 iPA 时，也必须将 Skia 一起打包 

#### 优点： 高性能
* Flutter 高性能主要靠两点来保证，首先， Flutter APP 采用 Dart 语言开发。 Dart 在 JIT （即时编译）模式下，速度与 JavaScript 基本持平。但是 Dart 支持 AOT ，当以 AOT 模式运行时， JavaScript 便远远追不上了。速度的提升对高帧率下的视图数据计算很有帮助。其次， Flutter 使用自己的渲染引擎来绘制 UI ，布局数据等由 Dart 语言直接控制，所以在布局过程中不需要像 RN 那样要在 JavaScript 和 Native 之间通信，这在一些滑动和拖动的场景下具有明显优势，因为在滑动和拖动过程往往都会引起布局发生变化，所以 JavaScript 需要和 Native 之间不停的同步布局信息，这和在浏览器中要 JavaScript 频繁操作 DOM 所带来的问题是相同的，都会带来比较可观的性能开销。 

#### 优点： 编译类型
* 静态编译的程序在执行前全部被翻译为机器码，通常将这种类型称为AOT （Ahead of time）即 “提前编译”
* AOT程序的典型代表是用C/C++开发的应用
* 也许有人会说，中间字节码并非机器码，在程序执行时仍然需要动态将字节码转为机器码，是的，这没有错，不过通常我们区分是否为 AOT 的标准就是看代码在执行之前是否需要编译，只要需要编译，无论其编译产物是字节码还是机器码，都属于 AOT 
* 解释执行的则是一句一句边翻译边运行，通常将这种类型称为JIT（Just-in-time）即“即时编译”。
    JIT的代表则非常多，如JavaScript、python等，事实上，所有脚本语言都支持JIT模式
* 即是AOT又是JIT：Java、Python
* 需要注意的是 JIT 和 AOT 指的是程序运行方式，和编程语言并非强关联的，有些语言既可以以 JIT 方式运行也可以以 AOT 方式运行，如 Java 、 Python ，它们可以在第一次执行时编译成中间字节码、然后在之后执行时可以直接执行字节码 Java 、 Python 

---

* Java、Python
* 它们可以在第一次执行时编译成中间字节码、然后在之后执行时可以直接执行字节码 
* 也许有人会说，中间字节码并非机器码，在程序执行时仍然需要动态将字节码转为机器码，是的，这没有错，不过通常我们区分是否为 AOT 的标准就是看代码在执行之前是否需要编译，只要需要编译，无论其编译产物是字节码还是机器码，都属于 AOT 


### Flutter框架结构

#### Flutter Framework
* 底下两层（Foundation和Animation、Painting、Gestures）在Google的一些视频中被合并为一个dart UI层，对应的是Flutter中的dart:ui包，它是Flutter引擎暴露的底层UI库，提供动画、手势及绘制能力。
* Rendering层，这一层是一个抽象的布局层，它依赖于dart UI层，Rendering层会构建一个UI树，当UI树有变化时，会计算出有变化的部分，然后更新UI树，最终将UI树绘制到屏幕上，这个过程类似于React中的虚拟DOM。Rendering层可以说是Flutter UI框架最核心的部分，它除了确定每个UI元素的位置、大小之外还要进行坐标变换、绘制(调用底层dart:ui)。
* Widgets层是Flutter提供的的一套基础组件库，在基础组件库之上，Flutter还提供了 Material 和Cupertino两种视觉风格的组件库。而我们Flutter开发的大多数场景，只是和这两层打交道。
      
#### Flutter Engine
* 这是一个纯 C++实现的 SDK，其中包括了 Skia引擎、Dart运行时、文字排版引擎等。在代码调用 dart:ui库时，调用最终会走到Engine层，然后实现真正的绘制逻辑。