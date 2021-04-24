![rUaNju](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/rUaNju.png)

Flutter的架构主要分成三层:Framework，Engine和Embedder。

Framework使用dart实现，包括Material Design风格的Widget,Cupertino(针对iOS)风格的Widgets，文本/图片/按钮等基础Widgets，渲染，动画，手势等。此部分的核心代码是:flutter仓库下的flutter package，以及sky_engine仓库下的io,async,ui(dart:ui库提供了Flutter框架和引擎之间的接口)等package。

Engine使用C++实现，主要包括:Skia,Dart和Text。Skia是开源的二维图形库，提供了适用于多种软硬件平台的通用API。其已作为Google Chrome，Chrome OS，Android, Mozilla Firefox, Firefox OS等其他众多产品的图形引擎，支持平台还包括Windows7+,macOS 10.10.5+,iOS8+,Android4.1+,Ubuntu14.04+等。Dart部分主要包括:Dart Runtime，Garbage Collection(GC)，如果是Debug模式的话，还包括JIT(Just In Time)支持。Release和Profile模式下，是AOT(Ahead Of Time)编译成了原生的arm代码，并不存在JIT部分。Text即文本渲染，其渲染层次如下:衍生自minikin的libtxt库(用于字体选择，分隔行)。HartBuzz用于字形选择和成型。Skia作为渲染/GPU后端，在Android和Fuchsia上使用FreeType渲染，在iOS上使用CoreGraphics来渲染字体。

Embedder是一个嵌入层，即把Flutter嵌入到各个平台上去，这里做的主要工作包括渲染Surface设置,线程设置，以及插件等。从这里可以看出，Flutter的平台相关层很低，平台(如iOS)只是提供一个画布，剩余的所有渲染相关的逻辑都在Flutter内部，这就使得它具有了很好的跨端一致性。