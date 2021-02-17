## Flutter语言基础知识

* [Fluuter基础知识参考笔记-Jimmy](https://gitee.com/erliucxy/suibi/blob/master/2020/Fluuter%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86%E5%8F%82%E8%80%83%E7%AC%94%E8%AE%B0-Jimmy.md)

### Flutter调试APP

* 有各种各样的工具和功能来帮助调试Flutter应用程序。

**Dart 分析器**  
* 在运行应用程序前，请运行 flutter analyze 测试你的代码。这个工具（它是 dartanalyzer 工具的一个包装）将分析你的代码并帮助你发现可能的错误。 如果你使用 IntelliJ 的 Flutter 插件，那么已经自动启用了。 
* Dart 分析器大量使用了代码中的类型注释来帮助追踪问题。我们鼓励您在任何地方使用它们（避免 var 、无类型的参数、无类型的列表文字等），因为这是追踪问题的最快的方式。

**Dart Observatory (语句级的单步调试和分析器)**  
* 如果您使用 flutter run 启动应用程序，那么当它运行时，您可以打开 Observatory URL 的 Web 页面（例如 Observatory 监听http://127.0.0.1:8100/ ）， 直接使用语句级单步调试器连接到您的应用程序。如果您使用的是 IntelliJ ，则还可以使用其内置的调试器来调试您的应用程序。 
* Observatory 同时支持分析、检查堆等。有关 Observatory 的更多信息请参考Observatory 文档 . 
* 如果您使用 Observatory 进行分析，请确保通过 --profile 选项来运行 flutter run 命令来运行应用程序。 否则，配置文件中将出现的主要问题将是调试断言，以验证框架的各种不变量（请参阅下面的 “ 调试模式断言 ” ）。 

**  debugger() 声明**  
* 当使用 Dart Observatory （或另一个 Dart 调试器，例如 IntelliJ IDE 中的调试器）时，可以使用该 debugger() 语句插入编程式断点。要使用这个，你必须添加 import 'dart:developer'; 到相关文件顶部。 
* debugger() 语句采用一个可选 when 参数，您可以指定该参数仅在特定条件为真时中断，如下所示： 

```dart
void someFunction(double offset) { 
  debugger(when: offset > 30.0); 
  // ... 
} 
```

**print、debugPrint、flutter logs**  
* Dart  print() 功能将输出到系统控制台，您可以使用 flutter logs 了查看它（基本上是一个包装 adb logcat ）。 
* 如果你一次输出太多，那么 Android 有时会丢弃一些日志行。为了避免这种情况，您可以使用 Flutter 的 foundation 库中的debugPrint() 。 这是一个封装 print ，它将输出限制在一个级别，避免被 Android 内核丢弃。 
* Flutter 框架中的许多类都有 toString 实现。按照惯例，这些输出通常包括对象的 runtimeType 单行输出，通常在表单中 ClassName(more information about this instance…) 。 树中使用的一些类也具有 toStringDeep ，从该点返回整个子树的多行描述。已一些具有详细信息 toString 的类会实现一个 toStringShort ，它只返回对象的类型或其他非常简短的（一个或两个单词）描述。 

**调试模式断言**  
* 在开发过程中，强烈建议您使用 Flutter 的 “ 调试 ” 模式，有时也称为 “checked” 模式（注意： Dart2.0 后 “checked” 被废除，可以使用 “strong” mode ）。 如果您使用 flutter run 运行程序。在这种模式下， Dart assert 语句被启用，并且 Flutter 框架使用它来执行许多运行时检查来验证是否违反一些不可变的规则。 
* 当一个不可变的规则被违反时，它被报告给控制台，并带有一些上下文信息来帮助追踪问题的根源。 
* 要关闭调试模式并使用发布模式，请使用 flutter run --release 运行您的应用程序。 这也关闭了 Observatory 调试器。一个中间模式可以关闭除 Observatory 之外所有调试辅助工具的，称为 “profile mode” ，用 --profile 替代 --release 即可。 

**调试应用程序层**  
* Flutter框架的每一层都提供了将其当前状态或事件转储(dump)到控制台（使用debugPrint）的功能。
* Widget 层
* 渲染层
* 层
* 语义
* 调度
* 可视化调试
* 调试动画
* 调试性能问题
* 衡量应用启动时间
* 跟踪Dart代码性能
* Performance Overlay
* Material grid
  

**Widget 层**  
* 要转储 Widgets 库的状态，请调用debugDumpApp() 。 只要应用程序已经构建了至少一次（即在调用 build() 之后的任何时间），您可以在应用程序未处于构建阶段（即，不在 build() 方法内调用 ）的任何时间调用此方法（在调用 runApp() 之后）。 
* 如 , 这个应用程序 :

```dart
import 'package:flutter/material.dart' ; 

void main () { 
  runApp ( 
    new MaterialApp ( 
      home : new AppHome (), 
    ), 
  ); 
} 

class AppHome extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return new Material ( 
      child : new Center ( 
        child : new FlatButton ( 
          onPressed : () { 
            debugDumpApp (); 
          }, 
          child : new Text ( 'Dump App' ), 
        ), 
      ), 
    ); 
  } 
} 
```

* … 会输出这样的内容（精确的细节会根据框架的版本、设备的大小等等而变化）： 

```dart
I/flutter ( 6559): WidgetsFlutterBinding - CHECKED MODE 
I/flutter ( 6559): RenderObjectToWidgetAdapter < RenderBox > ([GlobalObjectKey RenderView(497039273)]; renderObject: RenderView) 
I/flutter ( 6559): └MaterialApp(state: _MaterialAppState(1009803148)) 
I/flutter ( 6559):  └ScrollConfiguration() 
I/flutter ( 6559):   └AnimatedTheme(duration: 200ms; state: _AnimatedThemeState(543295893; ticker inactive; ThemeDataTween(ThemeData(Brightness.light Color(0xff2196f3) etc...) → null))) 
I/flutter ( 6559):    └Theme(ThemeData(Brightness.light Color(0xff2196f3) etc...)) 
I/flutter ( 6559):     └WidgetsApp([GlobalObjectKey _MaterialAppState(1009803148)]; state: _WidgetsAppState(552902158)) 
I/flutter ( 6559):      └CheckedModeBanner() 
I/flutter ( 6559):       └Banner() 
I/flutter ( 6559):        └CustomPaint(renderObject: RenderCustomPaint) 
I/flutter ( 6559):         └DefaultTextStyle(inherit: true; color: Color(0xd0ff0000); family: "monospace"; size: 48.0; weight: 900; decoration: double Color(0xffffff00) TextDecoration.underline) 
I/flutter ( 6559):          └MediaQuery(MediaQueryData(size: Size(411.4, 683.4), devicePixelRatio: 2.625, textScaleFactor: 1.0, padding: EdgeInsets(0.0, 24.0, 0.0, 0.0))) 
I/flutter ( 6559):           └LocaleQuery(null) 
I/flutter ( 6559):            └Title(color: Color(0xff2196f3)) 
I/flutter ( 6559):             └Navigator([GlobalObjectKey < NavigatorState > _WidgetsAppState(552902158)]; state: NavigatorState(240327618; tracking 1 ticker)) 
I/flutter ( 6559):              └Listener(listeners: down, up, cancel; behavior: defer-to-child; renderObject: RenderPointerListener) 
I/flutter ( 6559):               └AbsorbPointer(renderObject: RenderAbsorbPointer) 
I/flutter ( 6559):                └Focus([GlobalKey 489139594]; state: _FocusState(739584448)) 
I/flutter ( 6559):                 └Semantics(container: true; renderObject: RenderSemanticsAnnotations) 
I/flutter ( 6559):                  └_FocusScope(this scope has focus; focused subscope: [GlobalObjectKey MaterialPageRoute < Null > (875520219)]) 
I/flutter ( 6559):                   └Overlay([GlobalKey 199833992]; state: OverlayState(619367313; entries: [OverlayEntry@248818791(opaque: false; maintainState: false), OverlayEntry@837336156(opaque: false; maintainState: true)])) 
I/flutter ( 6559):                    └_Theatre(renderObject: _RenderTheatre) 
I/flutter ( 6559):                     └Stack(renderObject: RenderStack) 
I/flutter ( 6559):                      ├_OverlayEntry([GlobalKey 612888877]; state: _OverlayEntryState(739137453)) 
I/flutter ( 6559):                      │└IgnorePointer(ignoring: false; renderObject: RenderIgnorePointer) 
I/flutter ( 6559):                      │ └ModalBarrier() 
I/flutter ( 6559):                      │  └Semantics(container: true; renderObject: RenderSemanticsAnnotations) 
I/flutter ( 6559):                      │   └GestureDetector() 
I/flutter ( 6559):                      │    └RawGestureDetector(state: RawGestureDetectorState(39068508; gestures: tap; behavior: opaque)) 
I/flutter ( 6559):                      │     └_GestureSemantics(renderObject: RenderSemanticsGestureHandler) 
I/flutter ( 6559):                      │      └Listener(listeners: down; behavior: opaque; renderObject: RenderPointerListener) 
I/flutter ( 6559):                      │       └ConstrainedBox(BoxConstraints(biggest); renderObject: RenderConstrainedBox) 
I/flutter ( 6559):                      └_OverlayEntry([GlobalKey 727622716]; state: _OverlayEntryState(279971240)) 
I/flutter ( 6559):                       └_ModalScope([GlobalKey 816151164]; state: _ModalScopeState(875510645)) 
I/flutter ( 6559):                        └Focus([GlobalObjectKey MaterialPageRoute < Null > (875520219)]; state: _FocusState(331487674)) 
I/flutter ( 6559):                         └Semantics(container: true; renderObject: RenderSemanticsAnnotations) 
I/flutter ( 6559):                          └_FocusScope(this scope has focus) 
I/flutter ( 6559):                           └Offstage(offstage: false; renderObject: RenderOffstage) 
I/flutter ( 6559):                            └IgnorePointer(ignoring: false; renderObject: RenderIgnorePointer) 
I/flutter ( 6559):                             └_MountainViewPageTransition(animation: AnimationController( ⏭ 1.000; paused; for MaterialPageRoute < Null > (/))➩ProxyAnimation➩Cubic(0.40, 0.00, 0.20, 1.00)➩Tween < Offset > (Offset(0.0, 1.0) → Offset(0.0, 0.0))➩Offset(0.0, 0.0); state: _AnimatedState(552160732)) 
I/flutter ( 6559):                              └SlideTransition(animation: AnimationController( ⏭ 1.000; paused; for MaterialPageRoute < Null > (/))➩ProxyAnimation➩Cubic(0.40, 0.00, 0.20, 1.00)➩Tween < Offset > (Offset(0.0, 1.0) → Offset(0.0, 0.0))➩Offset(0.0, 0.0); state: _AnimatedState(714726495)) 
I/flutter ( 6559):                               └FractionalTranslation(renderObject: RenderFractionalTranslation) 
I/flutter ( 6559):                                └RepaintBoundary(renderObject: RenderRepaintBoundary) 
I/flutter ( 6559):                                 └PageStorage([GlobalKey 619728754]) 
I/flutter ( 6559):                                  └_ModalScopeStatus(active) 
I/flutter ( 6559):                                   └AppHome() 
I/flutter ( 6559):                                    └Material(MaterialType.canvas; elevation: 0; state: _MaterialState(780114997)) 
I/flutter ( 6559):                                     └AnimatedContainer(duration: 200ms; has background; state: _AnimatedContainerState(616063822; ticker inactive; has background)) 
I/flutter ( 6559):                                      └Container(bg: BoxDecoration()) 
I/flutter ( 6559):                                       └DecoratedBox(renderObject: RenderDecoratedBox) 
I/flutter ( 6559):                                        └Container(bg: BoxDecoration(backgroundColor: Color(0xfffafafa))) 
I/flutter ( 6559):                                         └DecoratedBox(renderObject: RenderDecoratedBox) 
I/flutter ( 6559):                                          └NotificationListener < LayoutChangedNotification > () 
I/flutter ( 6559):                                           └_InkFeature([GlobalKey ink renderer]; renderObject: _RenderInkFeatures) 
I/flutter ( 6559):                                            └AnimatedDefaultTextStyle(duration: 200ms; inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 400; baseline: alphabetic; state: _AnimatedDefaultTextStyleState(427742350; ticker inactive)) 
I/flutter ( 6559):                                             └DefaultTextStyle(inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 400; baseline: alphabetic) 
I/flutter ( 6559):                                              └Center(alignment: Alignment.center; renderObject: RenderPositionedBox) 
I/flutter ( 6559):                                               └FlatButton() 
I/flutter ( 6559):                                                └MaterialButton(state: _MaterialButtonState(398724090)) 
I/flutter ( 6559):                                                 └ConstrainedBox(BoxConstraints(88.0<=w<=Infinity, h=36.0); renderObject: RenderConstrainedBox relayoutBoundary=up1) 
I/flutter ( 6559):                                                  └AnimatedDefaultTextStyle(duration: 200ms; inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 500; baseline: alphabetic; state: _AnimatedDefaultTextStyleState(315134664; ticker inactive)) 
I/flutter ( 6559):                                                   └DefaultTextStyle(inherit: false; color: Color(0xdd000000); family: "Roboto"; size: 14.0; weight: 500; baseline: alphabetic) 
I/flutter ( 6559):                                                    └IconTheme(color: Color(0xdd000000)) 
I/flutter ( 6559):                                                     └InkWell(state: _InkResponseState < InkResponse > (369160267)) 
I/flutter ( 6559):                                                      └GestureDetector() 
I/flutter ( 6559):                                                       └RawGestureDetector(state: RawGestureDetectorState(175370983; gestures: tap; behavior: opaque)) 
I/flutter ( 6559):                                                        └_GestureSemantics(renderObject: RenderSemanticsGestureHandler relayoutBoundary=up2) 
I/flutter ( 6559):                                                         └Listener(listeners: down; behavior: opaque; renderObject: RenderPointerListener relayoutBoundary=up3) 
I/flutter ( 6559):                                                          └Container(padding: EdgeInsets(16.0, 0.0, 16.0, 0.0)) 
I/flutter ( 6559):                                                           └Padding(renderObject: RenderPadding relayoutBoundary=up4) 
I/flutter ( 6559):                                                            └Center(alignment: Alignment.center; widthFactor: 1.0; renderObject: RenderPositionedBox relayoutBoundary=up5) 
I/flutter ( 6559):                                                             └Text("Dump App") 
I/flutter ( 6559):                                                              └RichText(renderObject: RenderParagraph relayoutBoundary=up6) 
```

* 这是一个 “ 扁平化 ” 的树，显示了通过各种构建函数投影的所有 widget （如果你在 widget 树的根中调用 toStringDeepwidget ，这是你获得的树）。 你会看到很多在你的应用源代码中没有出现的 widget ，因为它们是被框架中 widget 的 build() 函数插入的。例如，InkFeature 是 Material widget 的一个实现细节 。 
* 当按钮从被按下变为被释放时 debugDumpApp() 被调用， FlatButton 对象同时调用 setState() ，并将自己标记为 "dirty" 。 这就是为什么如果你看转储，你会看到特定的对象标记为 “dirty” 。您还可以查看已注册了哪些手势监听器 ; 在这种情况下，一个单一的 GestureDetector 被列出，并且监听 “tap” 手势（ “tap” 是 TapGestureDetector 的 toStringShort 函数输出的） 
* 如果您编写自己的 widget ，则可以通过覆盖debugFillProperties() 来添加信息。 将DiagnosticsProperty 对象作为方法参数，并调用父类方法。 该函数是该 toString 方法用来填充小部件描述信息的。 

**  渲染层**  
* 如果您尝试调试布局问题，那么 Widgets 层的树可能不够详细。在这种情况下，您可以通过调用 debugDumpRenderTree() 转储渲染树。 正如 debugDumpApp() ，除布局或绘制阶段外，您可以随时调用此函数。作为一般规则，从frame 回调   或事件处理器中调用它是最佳解决方案。 
* 要调用 debugDumpRenderTree() ，您需要添加 import'package:flutter/rendering.dart'; 到您的源文件。 
* 上面这个小例子的输出结果如下所示：

```dart
I/flutter ( 6559): RenderView 
I/flutter ( 6559):  │ debug mode enabled - android 
I/flutter ( 6559):  │ window size: Size(1080.0, 1794.0) (in physical pixels) 
I/flutter ( 6559):  │ device pixel ratio: 2.625 (physical pixels per logical pixel) 
I/flutter ( 6559):  │ configuration: Size(411.4, 683.4) at 2.625x (in logical pixels) 
I/flutter ( 6559):  │ 
I/flutter ( 6559):  └─child: RenderCustomPaint 
I/flutter ( 6559):    │ creator: CustomPaint ← Banner ← CheckedModeBanner ← 
I/flutter ( 6559):    │   WidgetsApp-[GlobalObjectKey _MaterialAppState(1009803148)] ← 
I/flutter ( 6559):    │   Theme ← AnimatedTheme ← ScrollConfiguration ← MaterialApp ← 
I/flutter ( 6559):    │   [root] 
I/flutter ( 6559):    │ parentData: < none > 
I/flutter ( 6559):    │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):    │ size: Size(411.4, 683.4) 
I/flutter ( 6559):    │ 
I/flutter ( 6559):    └─child: RenderPointerListener 
I/flutter ( 6559):      │ creator: Listener ← Navigator-[GlobalObjectKey < NavigatorState > 
I/flutter ( 6559):      │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery 
I/flutter ( 6559):      │   ← DefaultTextStyle ← CustomPaint ← Banner ← CheckedModeBanner ← 
I/flutter ( 6559):      │   WidgetsApp-[GlobalObjectKey _MaterialAppState(1009803148)] ← 
I/flutter ( 6559):      │   Theme ← AnimatedTheme ← ⋯ 
I/flutter ( 6559):      │ parentData: < none > 
I/flutter ( 6559):      │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):      │ size: Size(411.4, 683.4) 
I/flutter ( 6559):      │ behavior: defer-to-child 
I/flutter ( 6559):      │ listeners: down, up, cancel 
I/flutter ( 6559):      │ 
I/flutter ( 6559):      └─child: RenderAbsorbPointer 
I/flutter ( 6559):        │ creator: AbsorbPointer ← Listener ← 
I/flutter ( 6559):        │   Navigator-[GlobalObjectKey < NavigatorState > 
I/flutter ( 6559):        │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery 
I/flutter ( 6559):        │   ← DefaultTextStyle ← CustomPaint ← Banner ← CheckedModeBanner ← 
I/flutter ( 6559):        │   WidgetsApp-[GlobalObjectKey _MaterialAppState(1009803148)] ← 
I/flutter ( 6559):        │   Theme ← ⋯ 
I/flutter ( 6559):        │ parentData: < none > 
I/flutter ( 6559):        │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):        │ size: Size(411.4, 683.4) 
I/flutter ( 6559):        │ absorbing: false 
I/flutter ( 6559):        │ 
I/flutter ( 6559):        └─child: RenderSemanticsAnnotations 
I/flutter ( 6559):          │ creator: Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer 
I/flutter ( 6559):          │   ← Listener ← Navigator-[GlobalObjectKey < NavigatorState > 
I/flutter ( 6559):          │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery 
I/flutter ( 6559):          │   ← DefaultTextStyle ← CustomPaint ← Banner ← CheckedModeBanner ← 
I/flutter ( 6559):          │   ⋯ 
I/flutter ( 6559):          │ parentData: < none > 
I/flutter ( 6559):          │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):          │ size: Size(411.4, 683.4) 
I/flutter ( 6559):          │ 
I/flutter ( 6559):          └─child: _RenderTheatre 
I/flutter ( 6559):            │ creator: _Theatre ← Overlay-[GlobalKey 199833992] ← _FocusScope ← 
I/flutter ( 6559):            │   Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer ← 
I/flutter ( 6559):            │   Listener ← Navigator-[GlobalObjectKey < NavigatorState > 
I/flutter ( 6559):            │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery 
I/flutter ( 6559):            │   ← DefaultTextStyle ← ⋯ 
I/flutter ( 6559):            │ parentData: < none > 
I/flutter ( 6559):            │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            │ 
I/flutter ( 6559):            ├─onstage: RenderStack 
I/flutter ( 6559):            ╎ │ creator: Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ← 
I/flutter ( 6559):            ╎ │   _FocusScope ← Semantics ← Focus-[GlobalKey 489139594] ← 
I/flutter ( 6559):            ╎ │   AbsorbPointer ← Listener ← 
I/flutter ( 6559):            ╎ │   Navigator-[GlobalObjectKey < NavigatorState > 
I/flutter ( 6559):            ╎ │   _WidgetsAppState(552902158)] ← Title ← LocaleQuery ← MediaQuery 
I/flutter ( 6559):            ╎ │   ← ⋯ 
I/flutter ( 6559):            ╎ │ parentData: not positioned; offset=Offset(0.0, 0.0) 
I/flutter ( 6559):            ╎ │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎ │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎ │ 
I/flutter ( 6559):            ╎ ├─child 1: RenderIgnorePointer 
I/flutter ( 6559):            ╎ │ │ creator: IgnorePointer ← _OverlayEntry-[GlobalKey 612888877] ← 
I/flutter ( 6559):            ╎ │ │   Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ← _FocusScope 
I/flutter ( 6559):            ╎ │ │   ← Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer ← 
I/flutter ( 6559):            ╎ │ │   Listener ← Navigator-[GlobalObjectKey < NavigatorState > 
I/flutter ( 6559):            ╎ │ │   _WidgetsAppState(552902158)] ← Title ← ⋯ 
I/flutter ( 6559):            ╎ │ │ parentData: not positioned; offset=Offset(0.0, 0.0) 
I/flutter ( 6559):            ╎ │ │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎ │ │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎ │ │ ignoring: false 
I/flutter ( 6559):            ╎ │ │ ignoringSemantics: implicitly false 
I/flutter ( 6559):            ╎ │ │ 
I/flutter ( 6559):            ╎ │ └─child: RenderSemanticsAnnotations 
I/flutter ( 6559):            ╎ │   │ creator: Semantics ← ModalBarrier ← IgnorePointer ← 
I/flutter ( 6559):            ╎ │   │   _OverlayEntry-[GlobalKey 612888877] ← Stack ← _Theatre ← 
I/flutter ( 6559):            ╎ │   │   Overlay-[GlobalKey 199833992] ← _FocusScope ← Semantics ← 
I/flutter ( 6559):            ╎ │   │   Focus-[GlobalKey 489139594] ← AbsorbPointer ← Listener ← ⋯ 
I/flutter ( 6559):            ╎ │   │ parentData: < none > 
I/flutter ( 6559):            ╎ │   │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎ │   │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎ │   │ 
I/flutter ( 6559):            ╎ │   └─child: RenderSemanticsGestureHandler 
I/flutter ( 6559):            ╎ │     │ creator: _GestureSemantics ← RawGestureDetector ← GestureDetector 
I/flutter ( 6559):            ╎ │     │   ← Semantics ← ModalBarrier ← IgnorePointer ← 
I/flutter ( 6559):            ╎ │     │   _OverlayEntry-[GlobalKey 612888877] ← Stack ← _Theatre ← 
I/flutter ( 6559):            ╎ │     │   Overlay-[GlobalKey 199833992] ← _FocusScope ← Semantics ← ⋯ 
I/flutter ( 6559):            ╎ │     │ parentData: < none > 
I/flutter ( 6559):            ╎ │     │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎ │     │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎ │     │ 
I/flutter ( 6559):            ╎ │     └─child: RenderPointerListener 
I/flutter ( 6559):            ╎ │       │ creator: Listener ← _GestureSemantics ← RawGestureDetector ← 
I/flutter ( 6559):            ╎ │       │   GestureDetector ← Semantics ← ModalBarrier ← IgnorePointer ← 
I/flutter ( 6559):            ╎ │       │   _OverlayEntry-[GlobalKey 612888877] ← Stack ← _Theatre ← 
I/flutter ( 6559):            ╎ │       │   Overlay-[GlobalKey 199833992] ← _FocusScope ← ⋯ 
I/flutter ( 6559):            ╎ │       │ parentData: < none > 
I/flutter ( 6559):            ╎ │       │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎ │       │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎ │       │ behavior: opaque 
I/flutter ( 6559):            ╎ │       │ listeners: down 
I/flutter ( 6559):            ╎ │       │ 
I/flutter ( 6559):            ╎ │       └─child: RenderConstrainedBox 
I/flutter ( 6559):            ╎ │           creator: ConstrainedBox ← Listener ← _GestureSemantics ← 
I/flutter ( 6559):            ╎ │             RawGestureDetector ← GestureDetector ← Semantics ← ModalBarrier 
I/flutter ( 6559):            ╎ │             ← IgnorePointer ← _OverlayEntry-[GlobalKey 612888877] ← Stack ← 
I/flutter ( 6559):            ╎ │             _Theatre ← Overlay-[GlobalKey 199833992] ← ⋯ 
I/flutter ( 6559):            ╎ │           parentData: < none > 
I/flutter ( 6559):            ╎ │           constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎ │           size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎ │           additionalConstraints: BoxConstraints(biggest) 
I/flutter ( 6559):            ╎ │ 
I/flutter ( 6559):            ╎ └─child 2: RenderSemanticsAnnotations 
I/flutter ( 6559):            ╎   │ creator: Semantics ← Focus-[GlobalObjectKey 
I/flutter ( 6559):            ╎   │   MaterialPageRoute < Null > (875520219)] ← _ModalScope-[GlobalKey 
I/flutter ( 6559):            ╎   │   816151164] ← _OverlayEntry-[GlobalKey 727622716] ← Stack ← 
I/flutter ( 6559):            ╎   │   _Theatre ← Overlay-[GlobalKey 199833992] ← _FocusScope ← 
I/flutter ( 6559):            ╎   │   Semantics ← Focus-[GlobalKey 489139594] ← AbsorbPointer ← 
I/flutter ( 6559):            ╎   │   Listener ← ⋯ 
I/flutter ( 6559):            ╎   │ parentData: not positioned; offset=Offset(0.0, 0.0) 
I/flutter ( 6559):            ╎   │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎   │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎   │ 
I/flutter ( 6559):            ╎   └─child: RenderOffstage 
I/flutter ( 6559):            ╎     │ creator: Offstage ← _FocusScope ← Semantics ← 
I/flutter ( 6559):            ╎     │   Focus-[GlobalObjectKey MaterialPageRoute < Null > (875520219)] ← 
I/flutter ( 6559):            ╎     │   _ModalScope-[GlobalKey 816151164] ← _OverlayEntry-[GlobalKey 
I/flutter ( 6559):            ╎     │   727622716] ← Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ← 
I/flutter ( 6559):            ╎     │   _FocusScope ← Semantics ← Focus-[GlobalKey 489139594] ← ⋯ 
I/flutter ( 6559):            ╎     │ parentData: < none > 
I/flutter ( 6559):            ╎     │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎     │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎     │ offstage: false 
I/flutter ( 6559):            ╎     │ 
I/flutter ( 6559):            ╎     └─child: RenderIgnorePointer 
I/flutter ( 6559):            ╎       │ creator: IgnorePointer ← Offstage ← _FocusScope ← Semantics ← 
I/flutter ( 6559):            ╎       │   Focus-[GlobalObjectKey MaterialPageRoute < Null > (875520219)] ← 
I/flutter ( 6559):            ╎       │   _ModalScope-[GlobalKey 816151164] ← _OverlayEntry-[GlobalKey 
I/flutter ( 6559):            ╎       │   727622716] ← Stack ← _Theatre ← Overlay-[GlobalKey 199833992] ← 
I/flutter ( 6559):            ╎       │   _FocusScope ← Semantics ← ⋯ 
I/flutter ( 6559):            ╎       │ parentData: < none > 
I/flutter ( 6559):            ╎       │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎       │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎       │ ignoring: false 
I/flutter ( 6559):            ╎       │ ignoringSemantics: implicitly false 
I/flutter ( 6559):            ╎       │ 
I/flutter ( 6559):            ╎       └─child: RenderFractionalTranslation 
I/flutter ( 6559):            ╎         │ creator: FractionalTranslation ← SlideTransition ← 
I/flutter ( 6559):            ╎         │   _MountainViewPageTransition ← IgnorePointer ← Offstage ← 
I/flutter ( 6559):            ╎         │   _FocusScope ← Semantics ← Focus-[GlobalObjectKey 
I/flutter ( 6559):            ╎         │   MaterialPageRoute < Null > (875520219)] ← _ModalScope-[GlobalKey 
I/flutter ( 6559):            ╎         │   816151164] ← _OverlayEntry-[GlobalKey 727622716] ← Stack ← 
I/flutter ( 6559):            ╎         │   _Theatre ← ⋯ 
I/flutter ( 6559):            ╎         │ parentData: < none > 
I/flutter ( 6559):            ╎         │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎         │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎         │ translation: Offset(0.0, 0.0) 
I/flutter ( 6559):            ╎         │ transformHitTests: true 
I/flutter ( 6559):            ╎         │ 
I/flutter ( 6559):            ╎         └─child: RenderRepaintBoundary 
I/flutter ( 6559):            ╎           │ creator: RepaintBoundary ← FractionalTranslation ← 
I/flutter ( 6559):            ╎           │   SlideTransition ← _MountainViewPageTransition ← IgnorePointer ← 
I/flutter ( 6559):            ╎           │   Offstage ← _FocusScope ← Semantics ← Focus-[GlobalObjectKey 
I/flutter ( 6559):            ╎           │   MaterialPageRoute < Null > (875520219)] ← _ModalScope-[GlobalKey 
I/flutter ( 6559):            ╎           │   816151164] ← _OverlayEntry-[GlobalKey 727622716] ← Stack ← ⋯ 
I/flutter ( 6559):            ╎           │ parentData: < none > 
I/flutter ( 6559):            ╎           │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎           │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎           │ metrics: 83.3% useful (1 bad vs 5 good) 
I/flutter ( 6559):            ╎           │ diagnosis: this is a useful repaint boundary and should be kept 
I/flutter ( 6559):            ╎           │ 
I/flutter ( 6559):            ╎           └─child: RenderDecoratedBox 
I/flutter ( 6559):            ╎             │ creator: DecoratedBox ← Container ← AnimatedContainer ← Material 
I/flutter ( 6559):            ╎             │   ← AppHome ← _ModalScopeStatus ← PageStorage-[GlobalKey 
I/flutter ( 6559):            ╎             │   619728754] ← RepaintBoundary ← FractionalTranslation ← 
I/flutter ( 6559):            ╎             │   SlideTransition ← _MountainViewPageTransition ← IgnorePointer ← 
I/flutter ( 6559):            ╎             │   ⋯ 
I/flutter ( 6559):            ╎             │ parentData: < none > 
I/flutter ( 6559):            ╎             │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎             │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎             │ decoration: 
I/flutter ( 6559):            ╎             │   < no decorations specified > 
I/flutter ( 6559):            ╎             │ configuration: ImageConfiguration(bundle: 
I/flutter ( 6559):            ╎             │   PlatformAssetBundle@367106502(), devicePixelRatio: 2.625, 
I/flutter ( 6559):            ╎             │   platform: android) 
I/flutter ( 6559):            ╎             │ 
I/flutter ( 6559):            ╎             └─child: RenderDecoratedBox 
I/flutter ( 6559):            ╎               │ creator: DecoratedBox ← Container ← DecoratedBox ← Container ← 
I/flutter ( 6559):            ╎               │   AnimatedContainer ← Material ← AppHome ← _ModalScopeStatus ← 
I/flutter ( 6559):            ╎               │   PageStorage-[GlobalKey 619728754] ← RepaintBoundary ← 
I/flutter ( 6559):            ╎               │   FractionalTranslation ← SlideTransition ← ⋯ 
I/flutter ( 6559):            ╎               │ parentData: < none > 
I/flutter ( 6559):            ╎               │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎               │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎               │ decoration: 
I/flutter ( 6559):            ╎               │   backgroundColor: Color(0xfffafafa) 
I/flutter ( 6559):            ╎               │ configuration: ImageConfiguration(bundle: 
I/flutter ( 6559):            ╎               │   PlatformAssetBundle@367106502(), devicePixelRatio: 2.625, 
I/flutter ( 6559):            ╎               │   platform: android) 
I/flutter ( 6559):            ╎               │ 
I/flutter ( 6559):            ╎               └─child: _RenderInkFeatures 
I/flutter ( 6559):            ╎                 │ creator: _InkFeature-[GlobalKey ink renderer] ← 
I/flutter ( 6559):            ╎                 │   NotificationListener < LayoutChangedNotification > ← DecoratedBox 
I/flutter ( 6559):            ╎                 │   ← Container ← DecoratedBox ← Container ← AnimatedContainer ← 
I/flutter ( 6559):            ╎                 │   Material ← AppHome ← _ModalScopeStatus ← PageStorage-[GlobalKey 
I/flutter ( 6559):            ╎                 │   619728754] ← RepaintBoundary ← ⋯ 
I/flutter ( 6559):            ╎                 │ parentData: < none > 
I/flutter ( 6559):            ╎                 │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎                 │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎                 │ 
I/flutter ( 6559):            ╎                 └─child: RenderPositionedBox 
I/flutter ( 6559):            ╎                   │ creator: Center ← DefaultTextStyle ← AnimatedDefaultTextStyle ← 
I/flutter ( 6559):            ╎                   │   _InkFeature-[GlobalKey ink renderer] ← 
I/flutter ( 6559):            ╎                   │   NotificationListener < LayoutChangedNotification > ← DecoratedBox 
I/flutter ( 6559):            ╎                   │   ← Container ← DecoratedBox ← Container ← AnimatedContainer ← 
I/flutter ( 6559):            ╎                   │   Material ← AppHome ← ⋯ 
I/flutter ( 6559):            ╎                   │ parentData: < none > 
I/flutter ( 6559):            ╎                   │ constraints: BoxConstraints(w=411.4, h=683.4) 
I/flutter ( 6559):            ╎                   │ size: Size(411.4, 683.4) 
I/flutter ( 6559):            ╎                   │ alignment: Alignment.center 
I/flutter ( 6559):            ╎                   │ widthFactor: expand 
I/flutter ( 6559):            ╎                   │ heightFactor: expand 
I/flutter ( 6559):            ╎                   │ 
I/flutter ( 6559):            ╎                   └─child: RenderConstrainedBox relayoutBoundary=up1 
I/flutter ( 6559):            ╎                     │ creator: ConstrainedBox ← MaterialButton ← FlatButton ← Center ← 
I/flutter ( 6559):            ╎                     │   DefaultTextStyle ← AnimatedDefaultTextStyle ← 
I/flutter ( 6559):            ╎                     │   _InkFeature-[GlobalKey ink renderer] ← 
I/flutter ( 6559):            ╎                     │   NotificationListener < LayoutChangedNotification > ← DecoratedBox 
I/flutter ( 6559):            ╎                     │   ← Container ← DecoratedBox ← Container ← ⋯ 
I/flutter ( 6559):            ╎                     │ parentData: offset=Offset(156.7, 323.7) 
I/flutter ( 6559):            ╎                     │ constraints: BoxConstraints(0.0<=w<=411.4, 0.0<=h<=683.4) 
I/flutter ( 6559):            ╎                     │ size: Size(98.0, 36.0) 
I/flutter ( 6559):            ╎                     │ additionalConstraints: BoxConstraints(88.0<=w<=Infinity, h=36.0) 
I/flutter ( 6559):            ╎                     │ 
I/flutter ( 6559):            ╎                     └─child: RenderSemanticsGestureHandler relayoutBoundary=up2 
I/flutter ( 6559):            ╎                       │ creator: _GestureSemantics ← RawGestureDetector ← GestureDetector 
I/flutter ( 6559):            ╎                       │   ← InkWell ← IconTheme ← DefaultTextStyle ← 
I/flutter ( 6559):            ╎                       │   AnimatedDefaultTextStyle ← ConstrainedBox ← MaterialButton ← 
I/flutter ( 6559):            ╎                       │   FlatButton ← Center ← DefaultTextStyle ← ⋯ 
I/flutter ( 6559):            ╎                       │ parentData: < none > 
I/flutter ( 6559):            ╎                       │ constraints: BoxConstraints(88.0<=w<=411.4, h=36.0) 
I/flutter ( 6559):            ╎                       │ size: Size(98.0, 36.0) 
I/flutter ( 6559):            ╎                       │ 
I/flutter ( 6559):            ╎                       └─child: RenderPointerListener relayoutBoundary=up3 
I/flutter ( 6559):            ╎                         │ creator: Listener ← _GestureSemantics ← RawGestureDetector ← 
I/flutter ( 6559):            ╎                         │   GestureDetector ← InkWell ← IconTheme ← DefaultTextStyle ← 
I/flutter ( 6559):            ╎                         │   AnimatedDefaultTextStyle ← ConstrainedBox ← MaterialButton ← 
I/flutter ( 6559):            ╎                         │   FlatButton ← Center ← ⋯ 
I/flutter ( 6559):            ╎                         │ parentData: < none > 
I/flutter ( 6559):            ╎                         │ constraints: BoxConstraints(88.0<=w<=411.4, h=36.0) 
I/flutter ( 6559):            ╎                         │ size: Size(98.0, 36.0) 
I/flutter ( 6559):            ╎                         │ behavior: opaque 
I/flutter ( 6559):            ╎                         │ listeners: down 
I/flutter ( 6559):            ╎                         │ 
I/flutter ( 6559):            ╎                         └─child: RenderPadding relayoutBoundary=up4 
I/flutter ( 6559):            ╎                           │ creator: Padding ← Container ← Listener ← _GestureSemantics ← 
I/flutter ( 6559):            ╎                           │   RawGestureDetector ← GestureDetector ← InkWell ← IconTheme ← 
I/flutter ( 6559):            ╎                           │   DefaultTextStyle ← AnimatedDefaultTextStyle ← ConstrainedBox ← 
I/flutter ( 6559):            ╎                           │   MaterialButton ← ⋯ 
I/flutter ( 6559):            ╎                           │ parentData: < none > 
I/flutter ( 6559):            ╎                           │ constraints: BoxConstraints(88.0<=w<=411.4, h=36.0) 
I/flutter ( 6559):            ╎                           │ size: Size(98.0, 36.0) 
I/flutter ( 6559):            ╎                           │ padding: EdgeInsets(16.0, 0.0, 16.0, 0.0) 
I/flutter ( 6559):            ╎                           │ 
I/flutter ( 6559):            ╎                           └─child: RenderPositionedBox relayoutBoundary=up5 
I/flutter ( 6559):            ╎                             │ creator: Center ← Padding ← Container ← Listener ← 
I/flutter ( 6559):            ╎                             │   _GestureSemantics ← RawGestureDetector ← GestureDetector ← 
I/flutter ( 6559):            ╎                             │   InkWell ← IconTheme ← DefaultTextStyle ← 
I/flutter ( 6559):            ╎                             │   AnimatedDefaultTextStyle ← ConstrainedBox ← ⋯ 
I/flutter ( 6559):            ╎                             │ parentData: offset=Offset(16.0, 0.0) 
I/flutter ( 6559):            ╎                             │ constraints: BoxConstraints(56.0<=w<=379.4, h=36.0) 
I/flutter ( 6559):            ╎                             │ size: Size(66.0, 36.0) 
I/flutter ( 6559):            ╎                             │ alignment: Alignment.center 
I/flutter ( 6559):            ╎                             │ widthFactor: 1.0 
I/flutter ( 6559):            ╎                             │ heightFactor: expand 
I/flutter ( 6559):            ╎                             │ 
I/flutter ( 6559):            ╎                             └─child: RenderParagraph relayoutBoundary=up6 
I/flutter ( 6559):            ╎                               │ creator: RichText ← Text ← Center ← Padding ← Container ← 
I/flutter ( 6559):            ╎                               │   Listener ← _GestureSemantics ← RawGestureDetector ← 
I/flutter ( 6559):            ╎                               │   GestureDetector ← InkWell ← IconTheme ← DefaultTextStyle ← ⋯ 
I/flutter ( 6559):            ╎                               │ parentData: offset=Offset(0.0, 10.0) 
I/flutter ( 6559):            ╎                               │ constraints: BoxConstraints(0.0<=w<=379.4, 0.0<=h<=36.0) 
I/flutter ( 6559):            ╎                               │ size: Size(66.0, 16.0) 
I/flutter ( 6559):            ╎                               ╘═╦══ text ═══ 
I/flutter ( 6559):            ╎                                 ║ TextSpan: 
I/flutter ( 6559):            ╎                                 ║   inherit: false 
I/flutter ( 6559):            ╎                                 ║   color: Color(0xdd000000) 
I/flutter ( 6559):            ╎                                 ║   family: "Roboto" 
I/flutter ( 6559):            ╎                                 ║   size: 14.0 
I/flutter ( 6559):            ╎                                 ║   weight: 500 
I/flutter ( 6559):            ╎                                 ║   baseline: alphabetic 
I/flutter ( 6559):            ╎                                 ║   "Dump App" 
I/flutter ( 6559):            ╎                                 ╚═══════════ 
I/flutter ( 6559):            ╎ 
I/flutter ( 6559):            └╌no offstage children 
```

* 这是根 RenderObject 对象的 toStringDeep 函数的输出。 
* 当调试布局问题时，关键要看的是 size 和 constraints 字段。约束沿着树向下传递，尺寸向上传递。 
* 例如，在上面的转储中，您可以看到窗口大小， Size(411.4, 683.4) ，它用于强制RenderPositionedBox 下的所有渲染框到屏幕的大小， 约束条件为 BoxConstraints(w=411.4, h=683.4) 。从 RenderPositionedBox 的转储中看到是由 Center widget 创建的（如 creator 字段所描述的）， 设置其孩子的约束为： BoxConstraints(0.0<=w<=411.4,0.0<=h<=683.4) 。一个子 widget RenderPadding 进一步插入这些约束以添加填充空间， padding 值为 EdgeInsets(16.0, 0.0, 16.0, 0.0) ，因此 RenderConstrainedBox 具有约束 BoxConstraints(0.0<=w<=395.4, 0.0<=h<=667.4) 。该 creator 字段告诉我们的这个对象可能是其FlatButton 定义的一部分，它在其内容上设置最小宽度为 88 像素，并且设置高度为 36.0 像素（这是 Material Design 设计规范中 FlatButton 类的尺寸标准）。 
* 最内部 RenderPositionedBox 再次松开约束，这次是将按钮中的文本居中。 在RenderParagraph 中基于它的内容来决定其大小。 如果您现在按照 size 链继续往下查看，您会看到文本的大小是如何影响其按钮的框的宽度的，它们都是根据孩子的尺寸自行调整大小。 
* 另一种需要注意的是每个盒子描述的 ”relayoutSubtreeRoot” 部分，它告诉你有多少祖先以某种方式依赖于这个元素的大小。 因此， RenderParagraph 有一个 relayoutSubtreeRoot=up8 ，这意味着当它 RenderParagraph 被标及为 ”dirty” 时，它的八个祖先也必须被标记为 ”dirty” ，因为它们可能受到新尺寸的影响。 
* 如果您编写自己的渲染对象，则可以通过覆盖debugFillProperties() 将信息添加到转储。 将DiagnosticsProperty 对象作为方法的参数，并调用父类方法。 

**层**  
* 如果您尝试调试合成问题，则可以使用debugDumpLayerTree() 。对于上面的例子，它会输出： 

```dart
I/flutter : TransformLayer 
I/flutter :  │ creator: [root] 
I/flutter :  │ offset: Offset(0.0, 0.0) 
I/flutter :  │ transform: 
I/flutter :  │   [0] 3.5,0.0,0.0,0.0 
I/flutter :  │   [1] 0.0,3.5,0.0,0.0 
I/flutter :  │   [2] 0.0,0.0,1.0,0.0 
I/flutter :  │   [3] 0.0,0.0,0.0,1.0 
I/flutter :  │ 
I/flutter :  ├─child 1: OffsetLayer 
I/flutter :  │ │ creator: RepaintBoundary ← _FocusScope ← Semantics ← Focus-[GlobalObjectKey MaterialPageRoute(560156430)] ← _ModalScope-[GlobalKey 328026813] ← _OverlayEntry-[GlobalKey 388965355] ← Stack ← Overlay-[GlobalKey 625702218] ← Navigator-[GlobalObjectKey _MaterialAppState(859106034)] ← Title ← ⋯ 
I/flutter :  │ │ offset: Offset(0.0, 0.0) 
I/flutter :  │ │ 
I/flutter :  │ └─child 1: PictureLayer 
I/flutter :  │ 
I/flutter :  └─child 2: PictureLayer 
```

* 这是根 Layer 的 toStringDeep 输出的。 
* 根部的变换是应用设备像素比的变换 ; 在这种情况下，每个逻辑像素代表 3.5 个设备像素。 
* RepaintBoundary  widget 在渲染树的层中创建了一个 RenderRepaintBoundary 。这用于减少需要重绘的需求量。 

**语义**  
* 您还可以调用debugDumpSemanticsTree() 获取语义树（呈现给系统可访问性 API 的树）的转储。 要使用此功能，必须首先启用辅助功能，例如启用系统辅助工具或 SemanticsDebugger   （下面讨论）。 
* 对于上面的例子，它会输出 : 

```dart
I/flutter : SemanticsNode(0; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4)) 
I/flutter :  ├SemanticsNode(1; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4)) 
I/flutter :  │ └SemanticsNode(2; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4); canBeTapped) 
I/flutter :  └SemanticsNode(3; Rect.fromLTRB(0.0, 0.0, 411.4, 683.4)) 
I/flutter :    └SemanticsNode(4; Rect.fromLTRB(0.0, 0.0, 82.0, 36.0); canBeTapped; "Dump App") 
```

**调度**  
* 要找出相对于帧的开始 / 结束事件发生的位置，可以切换debugPrintBeginFrameBanner 和debugPrintEndFrameBanner 布尔值以将帧的开始和结束打印到控制台。 
* 例如 : 

```dart
I/flutter : ▄▄▄▄▄▄▄▄ Frame 12         30s 437.086ms ▄▄▄▄▄▄▄▄ 
I/flutter : Debug print: Am I performing this work more than once per frame? 
I/flutter : Debug print: Am I performing this work more than once per frame? 
I/flutter : ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 
debugPrintScheduleFrameStacks 还可以用来打印导致当前帧被调度的调用堆栈。 
```

**可视化调试**  
* 您也可以通过设置 debugPaintSizeEnabled 为 true 以可视方式调试布局问题。 这是来自 rendering 库的布尔值。它可以在任何时候启用，并在为 true 时影响绘制。 设置它的最简单方法是在 void main() 的顶部设置。 
* 当它被启用时，所有的盒子都会得到一个明亮的深青色边框， padding （来自 widget 如 Padding ）显示为浅蓝色，子 widget 周围有一个深蓝色框， 对齐方式（来自 widget 如 Center 和 Align ）显示为黄色箭头 . 空白（如没有任何子节点的 Container ）以灰色显示。 
* debugPaintBaselinesEnabled 做了类似的事情，但对于具有基线的对象，文字基线以绿色显示，表意 (ideographic) 基线以橙色显示。 
* debugPaintPointersEnabled 标志打开一个特殊模式，任何正在点击的对象都会以深青色突出显示。 这可以帮助您确定某个对象是否以某种不正确的方式进行 hit 测试（ Flutter 检测点击的位置是否有能响应用户操作的 widget ） , 例如，如果它实际上超出了其父项的范围，首先不会考虑通过 hit 测试。 
* 如果您尝试调试合成图层，例如以确定是否以及在何处添加 RepaintBoundary  widget ，则可以使用debugPaintLayerBordersEnabled   标志， 该标志用橙色或轮廓线标出每个层的边界，或者使用debugRepaintRainbowEnabled 标志， 只要他们重绘时，这会使该层被一组旋转色所覆盖。 
* 所有这些标志只能在调试模式下工作。通常， Flutter 框架中以 “ debug... ” 开头的任何内容都只能在调试模式下工作。 

**调试动画**  
* 调试动画最简单的方法是减慢它们的速度。为此，请将timeDilation 变量（在 scheduler 库中）设置为大于 1.0 的数字，例如 50.0 。 最好在应用程序启动时只设置一次。如果您在运行中更改它，尤其是在动画运行时将其值减小，则框架的观察时可能会倒退，这可能会导致断言并且通常会干扰您的工作。 

**调试性能问题**  
* 要了解您的应用程序导致重新布局或重新绘制的原因，您可以分别设置debugPrintMarkNeedsLayoutStacks 和  debugPrintMarkNeedsPaintStacks 标志。 每当渲染盒被要求重新布局和重新绘制时，这些都会将堆栈跟踪记录到控制台。如果这种方法对您有用，您可以使用 services 库中的 debugPrintStack() 方法按需打印堆栈痕迹。 

**衡量应用启动时间**  
* 要收集有关 Flutter 应用程序启动所需时间的详细信息，可以在运行 flutter run 时使用 trace-startup 和 profile 选项。 
* $ flutter run --trace-startup --profile 
* 跟踪输出保存为 start_up_info.json ，在 Flutter 工程目录在 build 目录下。输出列出了从应用程序启动到这些跟踪事件（以微秒捕获）所用的时间： 
	* 进入 Flutter 引擎时 . 
	* 展示应用第一帧时 . 
	* 初始化 Flutter 框架时 . 
	* 完成 Flutter 框架初始化时 . 
* 如 : 

```dart
{ 
  "engineEnterTimestampMicros": 96025565262, 
  "timeToFirstFrameMicros": 2171978, 
  "timeToFrameworkInitMicros": 514585, 
  "timeAfterFrameworkInitMicros": 1657393 
} 
```

**跟踪Dart代码性能**  
* 要执行自定义性能跟踪和测量 Dart 任意代码段的 wall/CPU 时间（类似于在 Android 上使用systrace ）。 使用 dart:developer 的Timeline 工具来包含你想测试的代码块，例如：

```dart
Timeline.startSync('interesting function'); 
// iWonderHowLongThisTakes(); 
Timeline.finishSync(); 
```

* 然后打开你应用程序的 Observatory timeline 页面，在 ”Recorded Streams” 中选择 ’Dart’ 复选框，并执行你想测量的功能。 
* 刷新页面将在 Chrome 的跟踪工具 中显示应用按时间顺序排列的 timeline 记录。 
* 请确保运行 flutter run 时带有 --profile 标志，以确保运行时性能特征与您的最终产品差异最小。 

**Performance Overlay**  
* 要获得应用程序性能图，请将MaterialApp 构造函数的 showPerformanceOverlay 参数设置为 true 。  WidgetsApp 构造函数也有类似的参数（如果你没有使用 MaterialApp 或者 WidgetsApp ，你可以通过将你的应用程序包装在一个 stack 中， 并将一个 widget 放在通过new PerformanceOverlay.allEnabled() 创建的 stack 上来获得相同的效果）。 
* 这将显示两个图表。第一个是 GPU 线程花费的时间，最后一个是 CPU 线程花费的时间。 图中的白线以 16ms 增量沿纵轴显示 ; 如果图中超过这三条线之一，那么您的运行频率低于 60Hz 。横轴代表帧。 该图仅在应用程序绘制时更新，因此如果它处于空闲状态，该图将停止移动。 
* 这应该始终在发布模式（ release mode ）下测试，因为在调试模式下，故意牺牲性能来换取有助于开发调试的功能，如 assert 声明，这些都是非常耗时的，因此结果将会产生误导。 

**Material grid**  
* 在开发实现Material Design 的应用程序时， 将Material Design 基线网格 覆盖在应用程序上可能有助于验证对齐。 为此，MaterialApp   构造函数   有一个 debugShowMaterialGrid 参数， 当在调试模式设置为 true 时，它将覆盖这样一个网格。 
* 您也可以直接使用GridPaper widget 将这种网格覆盖在非 Material 应用程序上   

### Flutter第一个应用

**实现一个计数器2019.2.14** 
* https://book.flutterchina.club/chapter2/
* 用 Android Studio 和 VS Code 创建的 Flutter 应用模板是一个简单的计数器示例，本节先仔细讲解一下这个计数器 Demo 的源码，让读者对 Flutter 应用程序结构有个基本了解，在随后小节中，将会基于此示例，一步一步添加一些新的功能来介绍 Flutter 应用的其它概念与技术。对于接下来的示例，希望读者可以跟着笔者实际动手来写一下，这样不仅可以加深印象，而且也会对介绍的概念与技术有一个真切的体会。如果你还不是很熟悉 Dart 或者没有移动开发经验，不用担心，只要你熟悉面向对象和基本编程概念（如变量、循环和条件控制），则可以完成本示例。 
* 通过 Android Studio 和 VS Code 根据前面 “ 编辑器配置与使用 ” 一章中介绍的创建 Flutter 工程的方法创建一个新的 Flutter 工程，命名为 "first_flutter_app" 。创建好后，就会得到一个计数器应用的 Demo 。 
* 注意，默认 Demo 示例可能随着编辑器 Flutter 插件版本变化而变化，本例中会介绍计数器示例的全部代码，所以不会对本示例产生影响。

---

* 主要Dart代码是在 lib/main.dart 文件中，下面我们看看该示例的源码：

```dart
import 'package:flutter/material.dart' ; 

void main () => runApp ( new MyApp ()); 

class MyApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return new MaterialApp ( 
      title : 'Flutter Demo' , 
      theme : new ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : new MyHomePage ( title : 'Flutter Demo Home Page' ), 
    ); 
  } 
} 

class MyHomePage extends StatefulWidget { 
  MyHomePage ({ Key key , this . title }) : super ( key : key ); 
  final String title ; 

  @override 
  _MyHomePageState createState () => new _MyHomePageState (); 
} 

class _MyHomePageState extends State < MyHomePage > { 
  int _counter = 0 ; 

  void _incrementCounter () { 
    setState (() { 
      _counter ++ ; 
    }); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return new Scaffold ( 
      appBar : new AppBar ( 
        title : new Text ( widget . title ), 
      ), 
      body : new Center ( 
        child : new Column ( 
          mainAxisAlignment : MainAxisAlignment . center , 
          children : < Widget > [ 
            new Text ( 
              'You have pushed the button this many times:' , 
            ), 
            new Text ( 
              '$_counter' , 
              style : Theme . of ( context ). textTheme . display1 , 
            ), 
          ], 
        ), 
      ), 
      floatingActionButton : new FloatingActionButton ( 
        onPressed : _incrementCounter , 
        tooltip : 'Increment' , 
        child : new Icon ( Icons . add ), 
      ), // This trailing comma makes auto-formatting nicer for build methods. 
    ); 
  } 
} 
```

**1.导入包。**
	* Material是一种标准的移动端和web端的视觉设计语言
	* import 'package:flutter/material.dart' ; 
	* 此行代码作用是导入了 Material UI 组件库。Material 是一种标准的移动端和 web 端的视觉设计语言， Flutter 默认提供了一套丰富的 Material 风格的 UI 组件。 

---

**2.应用入口。**
	* void main () => runApp ( new MyApp ()); 
	* 与 C/C++ 、 Java 类似， Flutter 应用中 main 函数为应用程序的入口， main 函数中调用了， runApp   方法，它的功能是启动 Flutter 应用，它接受一个 Widget 参数，在本示例中它是 MyApp 类的一个实例，该参数代表 Flutter 应用。 
	* main 函数使用了 ( => ) 符号，这是 Dart 中单行函数或方法的简写。 

---

**3.应用结构。**
	* 一个有状态的widget（Stateful widget）
	* StatelessWidget类，这也就意味着应用本身也是一个widget
	* Stateful widget 和Stateless widget有两点不同：
	* MyApp 类代表 Flutter 应用，它继承了   StatelessWidget 类，这也就意味着应用本身也是一个 widget 。 
	* 在 Flutter 中，大多数东西都是 widget ，包括对齐 (alignment) 、填充 (padding) 和布局 (layout) 。 
	* Flutter 在构建页面时，会调用组件的 build 方法， widget 的主要工作是提供一个 build() 方法来描述如何构建 UI 界面（通常是通过组合、拼装其它基础 widget ）。 
	* MaterialApp   是 Material 库中提供的 Flutter APP 框架，通过它可以设置应用的名称、主题、语言、首页及路由列表等。 MaterialApp 也是一个 widget 。 
	* Scaffold   是 Material 库中提供的页面脚手架，它包含导航栏和 Body 以及 FloatingActionButton （如果需要的话）。 本书后面示例中，路由默认都是通过 Scaffold 创建。 
	* home   为 Flutter 应用的首页，它也是一个 widget 。

```dart
class MyApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return new MaterialApp ( 
      // 应用名称   
      title : 'Flutter Demo' ,   
      theme : new ThemeData ( 
        // 蓝色主题   
        primarySwatch : Colors . blue , 
      ), 
      // 应用首页路由   
      home : new MyHomePage ( title : 'Flutter Demo Home Page' ), 
    ); 
  } 
} 
```

---

**4.首页**
	* MyHomePage   是应用的首页，它继承自 StatefulWidget 类，表示它是一个有状态的 widget （ Stateful widget ）。现在，我们可以简单认为 Stateful widget 和 Stateless widget 有两点不同： 
	* Stateful widget 可以拥有状态，这些状态在 widget 生命周期中是可以变的，而 Stateless widget 是不可变的。 
	* Stateful widget 至少由两个类组成： 
	* 一个 StatefulWidget 类。 
	* 一个 State 类；   StatefulWidget 类本身是不变的，但是 State 类中持有的状态在 widget 生命周期中可能会发生变化。 
	* _MyHomePageState 类是 MyHomePage 类对应的状态类。看到这里，细心的读者可能已经发现，和 MyApp   类不同，   MyHomePage 类中并没有 build 方法，取而代之的是， build 方法被挪到了 _MyHomePageState 方法中，至于为什么这么做，先留个疑问，在分析完完整代码后再来解答。

```dart
class MyHomePage extends StatefulWidget { 
  MyHomePage ({ Key key , this . title }) : super ( key : key ); 
  final String title ; 
  @override 
  _MyHomePageState createState () => new _MyHomePageState (); 
} 

class _MyHomePageState extends State < MyHomePage > { 
	... 
}
````

---

**5._MyHomePageState中都包含哪些东西：**
	* 当按钮点击时，会调用此函数，该函数的作用是先自增 _counter ，然后调用 setState   方法。 setState 方法的作用是通知 Flutter 框架，有状态发生了改变， Flutter 框架收到通知后，会执行 build 方法来根据新的状态重新构建界面， Flutter 对此方法做了优化，使重新执行变的很快，所以你可以重新构建任何需要更新的东西，而无需分别去修改各个 widget 。

```dart
//状态。 
int _counter = 0 ; 
//_counter   为保存屏幕右下角带 “ ➕ ” 号按钮点击次数的状态。

//设置状态的自增函数。 
void _incrementCounter () { 
	setState (() { 
	   _counter ++ ; 
   }); 
} 
```

* 构建UI界面
* Scaffold 是 Material 库中提供的一个 widget, 它提供了默认的导航栏、标题和包含主屏幕 widget 树的 body 属性。 widget 树可以很复杂。 
* body 的 widget 树中包含了一个 Center  widget ， Center   可以将其子 widget 树对齐到屏幕中心，   Center   子 widget 是一个 Column  widget ， Column 的作用是将其所有子 widget 沿屏幕垂直方向依次排列， 此例中 Column 包含两个   Text 子 widget ，第一个 Text  widget 显示固定文本 “You have pushed the button this many times:” ，第二个 Text  widget 显示 _counter 状态的数值。 
* floatingActionButton 是页面右下角的带 “ ➕ ” 的悬浮按钮，它的 onPressed 属性接受一个回调函数，代表它本点击后的处理器，本例中直接将 _incrementCounter 作为其处理函数。 
* 现在，我们将整个流程串起来：当右下角的 floatingActionButton 按钮被点击之后，会调用 _incrementCounter ，在 _incrementCounter 中，首先会自增 _counter 计数器（状态），然后 setState 会通知 Flutter 框架状态发生变化，接着， Flutter 会调用 build 方法以新的状态重新构建 UI ，最终显示在设备屏幕上。 

```dart
Widget build ( BuildContext context ) { 
return new Scaffold ( 
  appBar : new AppBar ( 
    title : new Text ( widget . title ), 
  ), 
  body : new Center ( 
    child : new Column ( 
      mainAxisAlignment : MainAxisAlignment . center , 
      children : < Widget > [ 
        new Text ( 
          'You have pushed the button this many times:' , 
        ), 
        new Text ( 
          '$_counter' , 
          style : Theme . of ( context ). textTheme . display1 , 
        ), 
      ], 
    ), 
  ), 
  floatingActionButton : new FloatingActionButton ( 
    onPressed : _incrementCounter , 
    tooltip : 'Increment' , 
    child : new Icon ( Icons . add ), 
  ), 
); 
} 
```

---

* 流程
* 构建 UI 界面的逻辑在 build 方法中，当 MyHomePage 第一次创建时， _MyHomePageState 类会被创建，当初始化完成后， Flutter 框架会调用 Widget 的 build 方法来构建 widget 树，最终将 widget 树渲染到设备屏幕上。 

---

* 为什么要将build方法放在State中，而不是放在StatefulWidget中？
* 现在，我们回答之前提出的问题，为什么 build() 方法在 State （而不是 StatefulWidget ）中 ？这主要是为了开发的灵活性。如果将 build() 方法在 StatefulWidget 中则会有两个问题： 
* 状态访问不便试想一下，如果我们的 Stateful widget 有很多状态，而每次状态改变都要调用 build 方法，由于状态是保存在 State 中的，如果将 build 方法放在 StatefulWidget 中，那么构建时读取状态将会很不方便，试想一下，如果真的将 build 方法放在 StatefulWidget 中的话，由于构建用户界面过程需要依赖 State ，所以 build 方法将必须加一个 State 参数，大概是下面这样：

```dart
Widget build ( BuildContext context , State state ){ 
	//state.counter 
	... 
}
```

* 这样的话就只能将 State 的所有状态声明为公开的状态，这样才能在 State 类外部访问状态，但将状态设置为公开后，状态将不再具有私密性，这样依赖，对状态的修改将会变的不可控。将 build() 方法放在 State 中的话，构建过程则可以直接访问状态，这样会很方便。 
* 继承 StatefulWidget 不便 例如， Flutter 中有一个动画 widget 的基类 AnimatedWidget ，它继承自 StatefulWidget 类。 AnimatedWidget 中引入了一个抽象方法 build(BuildContext context) ，继承自 AnimatedWidget 的动画 widget 都要实现这个 build 方法。现在设想一下，如果 StatefulWidget   类中已经有了一个 build 方法，正如上面所述，此时 build 方法需要接收一个 state 对象，这就意味着 AnimatedWidget 必须将自己的 State 对象 ( 记为 _animatedWidgetState) 提供给其子类，因为子类需要在其 build 方法中调用父类的 build 方法，代码可能如下： 

```dart
class MyAnimationWidget extends AnimatedWidget { 
	@override 
	Widget build ( BuildContext context , State state ){ 
		// 由于子类要用到 AnimatedWidget 的状态对象 _animatedWidgetState ， 
		// 所以 AnimatedWidget 必须通过某种方式将其状态对象 _animatedWidgetState 
		// 暴露给其子类     
	super . build ( context , _animatedWidgetState ) 
	} 
} 
```

* 这样很显然是不合理的，因为 
* AnimatedWidget 的状态对象是 AnimatedWidget 内部实现细节，不应该暴露给外部。 
* 如果要将父类状态暴露给子类，那么必须得有一种传递机制，而做这一套传递机制是无意义的，因为父子类之间状态的传递和子类本身逻辑是无关的。 
* 综上所述，可以发现，对于 StatefulWidget ，将 build 方法放在 State 中，可以给开发带来很大的灵活性。 

### Flutter的文本字体样式2019214

* TextSpan
	* 对一个Text内容的不同部分按照不同的样式显示，这时就可以使用TextSpan
* TextStyle
	* 指定文本显示的样式如颜色、字体、粗细、背景等。
* Text

---

**TextSpan**
* 对一个Text内容的不同部分按照不同的样式显示，这时就可以使用TextSpan
* 在上面的例子中， Text 的所有文本内容只能按同一种样式，如果我们需要对一个 Text 内容的不同部分按照不同的样式显示，这时就可以使用 TextSpan ，它代表文本的一个 “ 片段 ” 。我们看看 TextSpan 的定义 : 

```dart
const TextSpan ({ 
  TextStyle style ,   
  Sting text , 
  List < TextSpan > children , 
  GestureRecognizer recognizer , 
}); 
```

* 其中 style   和   text 属性代表该文本片段的样式和内容。   children 是一个 TextSpan 的数组，也就是说 TextSpan 可以包括其他 TextSpan 。而 recognizer 用于对该文本片段上用于手势进行识别处理。下面我们看一个效果，然后用 TextSpan 实现它。 
* 源码： 

```dart
Text . rich ( TextSpan ( 
    children : [ 
     TextSpan ( 
       text : "Home: " 
     ), 
     TextSpan ( 
       text : "https://flutterchina.club" , 
       style : TextStyle ( 
         color : Colors . blue 
       ),   
       recognizer : _tapRecognizer 
     ), 
    ] 
))
```

* 上面代码中，我们通过 TextSpan 实现了一个基础文本片段和一个链接片段，然后通过 Text.rich   方法将 TextSpan   添加到 Text 中，之所以可以这样做，是因为 Text 其实就是 RichText 的一个包装，而 RichText 是可以显示多种样式 ( 富文本 ) 的 widget 。 
* _tapRecognizer ，它是点击链接后的一个处理器（代码已省略），关于手势识别的更多内容我们将在后面单独介绍。 

---

**TextStyle**
* 指定文本显示的样式如颜色、字体、粗细、背景等。
* TextStyle 用于指定文本显示的样式如颜色、字体、粗细、背景等。我们看一个示例： 

```dart
Text ( "Hello world" , 
  style : TextStyle ( 
    color : Colors . blue , 
    fontSize : 18.0 , 
    height : 1.2 ,   
    fontFamily : "Courier" , 
    background : new Paint ().. color = Colors . yellow , 
    decoration : TextDecoration . underline , 
    decorationStyle : TextDecorationStyle . dashed 
  ), 
); 
```

* 效果如下： 
* 此示例只展示了 TextStyle 的部分属性，它还有一些其它属性，属性名基本都是自解释的，在此不再赘述，读者可以查阅 SDK 文档。值得注意的是： 
	* height ：该属性用于指定行高，但它并不是一个绝对值，而是一个因子，具体的行高等于 fontSize * height 。 
	* fontFamily   ：由于不同平台默认支持的字体集不同，所以在手动指定字体时一定要先在不同平台测试一下。 
	* fontSize ：该属性和 Text 的 textScaleFactor 都用于控制字体大小。但是有两给主要区别： 
	* fontSize 可以精确指定字体大小，而 textScaleFactor 只能通过缩放比例来控制。 
	* textScaleFactor 主要是用于系统字体大小设置改变时对 Flutter 应用字体进行全局调整，而 fontSize 通常用于单个文本。 

---

**Text**
* Text 用于显示简单样式文本，它包含一些控制文本显示样式的一些属性，一个简单的例子如下： 

```dart
Text ( "Hello world" , 
  textAlign : TextAlign . center , 
); 

Text ( "Hello world! I'm Jack. " * 4 , 
  maxLines : 1 , 
  overflow : TextOverflow . ellipsis , 
); 

Text ( "Hello world" , 
  textScaleFactor : 1.5 , 
); 
```

* 运行效果如下： 
* textAlign ：文本的对齐方式；可以选择左对齐、右对齐还是居中。注意，对齐的参考系是 Text widget 本身。本例中虽然是指定了居中对齐，但因为 Text 文本内容宽度不足一行， Text 的宽度和文本内容长度相等，那么这时指定对齐方式是没有意义的，只有 Text 宽度大于文本内容长度时指定此属性才有意义。下面我们指定一个较长的字符串： 

```dart
Text ( "Hello world " * 6 ,   // 字符串重复六次 
 textAlign : TextAlign . center , 
) ；
```

* 运行效果如下：
* 字符串内容超过一行， Text 宽度等于屏幕宽度，第二行文本便会居中显示。 
	* maxLines 、 overflow ：指定文本显示的最大行数，默认情况下，文本是自动折行的，如果指定此参数，则文本最多不会超过指定的行。如果有多余的文本，可以通过 overflow 来指定截断方式，默认是直接截断，本例中指定的截断方式 TextOverflow.ellipsis ，它会将多余文本截断后以省略符 “...” 表示； TextOverflow 的其它截断方式请参考 SDK 文档。 
	* textScaleFactor ：代表文本相对于当前字体大小的缩放因子，相对于去设置文本的样式 style 属性的 fontSize ，它是调整字体大小的一个快捷方式。该属性的默认值可以通过 MediaQueryData.textScaleFactor 获得，如果没有 MediaQuery ，那么会默认值将为 1.0 。 

### Flutter加载资源文件
* Flutter 应用程序可以包含代码和 assets （有时称为资源）。 assets 是会打包到程序安装包中的，可在运行时访问。常见类型的 assets 包括静态数据（例如 JSON 文件）、配置文件、图标和图片（ JPEG ， WebP ， GIF ，动画 WebP / GIF ， PNG ， BMP 和 WBMP ）等。 
* https://book.flutterchina.club/chapter2/flutter_assets_mgr.html

**指定 assets**  
* 和包管理一样， Flutter 也使用pubspec.yaml 文件来管理应用程序所需的资源。举一个例子 : 

```dart
flutter: 
  assets: 
    - assets/my_icon.png 
    - assets/background.png 
```

* assets 指定应包含在应用程序中的文件。 每个 asset 都通过相对于 pubspec.yaml 文件所在位置的显式路径进行标识。 asset 的声明顺序是无关紧要的。 asset 的实际目录可以是任意文件夹（在本示例中是 assets ）。 
* 在构建期间， Flutter 将 asset 放置到称为  asset bundle   的特殊存档中，应用程序可以在运行时读取它们（但不能修改）。 

**Asset 变体（variant）**  
* 构建过程支持 asset 变体的概念：不同版本的 asset 可能会显示在不同的上下文中。 在 pubspec.yaml 的 assets 部分中指定 asset 路径时，构建过程中，会在相邻子目录中查找具有相同名称的任何文件。这些文件随后会与指定的 asset 一起被包含在 asset bundle 中。 
* 例如，如果应用程序目录中有以下文件 : 

```dart
…/pubspec.yaml 
…/graphics/my_icon.png 
…/graphics/background.png 
…/graphics/dark/background.png 
…etc. 
```

* 然后 pubspec.yaml 文件中只需包含 : 

```dart
flutter: 
  assets: 
    - graphics/background.png 
```

* 那么这两个 graphics/background.png 和 graphics/dark/background.png   都将包含在您的 asset bundle 中。前者被认为是 main asset   （主资源），后者被认为是一种变体（ variant ）。 
* 在选择匹配当前设备分辨率的图片时， Flutter 会使用到 asset 变体（见下文），将来， Flutter 可能会将这种机制扩展到本地化、阅读提示等方面。 

**加载 assets**  
* 您的应用可以通过AssetBundle 对象访问其 asset 。有两种主要方法允许从 Asset bundle 中加载字符串或图片 ( 二进制 ) 文件。 

**加载文本assets**  
* 通过rootBundle   对象加载：每个 Flutter 应用程序都有一个rootBundle 对象， 通过它可以轻松访问主资源包，直接使用 package:flutter/services.dart 中全局静态的 rootBundle 对象来加载 asset 即可。 
* 通过  DefaultAssetBundle   加载：建议使用  DefaultAssetBundle   来获取当前 BuildContext 的 AssetBundle 。 这种方法不是使用应用程序构建的默认 asset bundle ，而是使父级 widget 在运行时动态替换的不同的 AssetBundle ，这对于本地化或测试场景很有用。 
* 通常，可以使用 DefaultAssetBundle.of() 在应用运行时来间接加载 asset （例如 JSON 文件），而在 widget 上下文之外，或其它 AssetBundle 句柄不可用时，可以使用 rootBundle 直接加载这些 asset ，例如： 

```dart
import 'dart:async' show Future ; 
import 'package:flutter/services.dart' show rootBundle ; 

Future < String > loadAsset () async { 
  return await rootBundle . loadString ( 'assets/config.json' ); 
} 
```

**声明分辨率相关的图片 assets**  
* AssetImage   可以将 asset 的请求逻辑映射到最接近当前设备像素比例 (dpi) 的 asset 。为了使这种映射起作用，必须根据特定的目录结构来保存 asset ： 

```dart
…/image.png 
…/M x/image.png 
…/N x/image.png 
…etc. 
```

* 其中 M 和 N 是数字标识符，对应于其中包含的图像的分辨率，也就是说，它们指定不同设备像素比例的图片。 
* 主资源默认对应于 1.0 倍的分辨率图片。看一个例子： 

```dart
…/my_icon.png 
…/2.0x/my_icon.png 
…/3.0x/my_icon.png 
```

* 在设备像素比率为 1.8 的设备上， .../2.0x/my_icon.png   将被选择。对于 2.7 的设备像素比率， .../3.0x/my_icon.png 将被选择。 
* 如果未在 Image  widget 上指定渲染图像的宽度和高度，那么 Image  widget 将占用与主资源相同的屏幕空间大小。 也就是说，如果 .../my_icon.png 是 72px 乘 72px ，那么 .../3.0x/my_icon.png 应该是 216px 乘 216px; 但如果未指定宽度和高度，它们都将渲染为 72 像素 ×72 像素（以逻辑像素为单位）。 
* pubspec.yaml 中 asset 部分中的每一项都应与实际文件相对应，但主资源项除外。当主资源缺少某个资源时，会按分辨率从低到高的顺序去选择 ，也就是说 1x 中没有的话会在 2x 中找， 2x 中还没有的话就在 3x 中找。 

**加载图片**  
* 要加载图片，可以使用  AssetImage 类。例如，我们可以从上面的 asset 声明中加载背景图片： 

```dart
Widget build ( BuildContext context ) { 
  return new DecoratedBox ( 
    decoration : new BoxDecoration ( 
      image : new DecorationImage ( 
        image : new AssetImage ( 'graphics/background.png' ), 
      ), 
    ), 
  ); 
} 
```

* 注意， AssetImage   并非是一个 widget ， 它实际上是一个 ImageProvider ，有些时候你可能期望直接得到一个显示图片的 widget ，那么你可以使用 Image.asset() 方法，如： 

```dart
Widget build ( BuildContext context ) { 
  return Image . asset ( 'graphics/background.png' ); 
} 
```

* 使用默认的 asset bundle 加载资源时，内部会自动处理分辨率等，这些处理对开发者来说是无感知的。 ( 如果使用一些更低级别的类，如  ImageStream 或  ImageCache   时你会注意到有与缩放相关的参数 ) 

**依赖包中的资源图片**  
* 要加载依赖包中的图像，必须给 AssetImage 提供 package 参数。 
* 例如，假设您的应用程序依赖于一个名为 “my_icons” 的包，它具有如下目录结构： 

```dart
…/pubspec.yaml 
…/icons/heart.png 
…/icons/1.5x/heart.png 
…/icons/2.0x/heart.png 
…etc. 
```

* 然后加载图像，使用 : 

```dart
  new AssetImage ( 'icons/heart.png' , package : 'my_icons' ) 
或 
new Image . asset ( 'icons/heart.png' , package : 'my_icons' ) 
```

* 注意：包在使用本身的资源时也应该加上 package 

**打包包中的 assets**  
* 如果在 pubspec.yaml 文件中声明了期望的资源，它将会打包到相应的 package 中。特别是，包本身使用的资源必须在 pubspec.yaml 中指定。 
* 包也可以选择在其 lib/ 文件夹中包含未在其 pubspec.yaml 文件中声明的资源。在这种情况下，对于要打包的图片，应用程序必须在 pubspec.yaml 中指定包含哪些图像。 例如，一个名为 “fancy_backgrounds” 的包，可能包含以下文件： 

```dart
…/lib/backgrounds/background1.png 
…/lib/backgrounds/background2.png 
…/lib/backgrounds/background3.png 
```

* 要包含第一张图像，必须在 pubspec.yaml 的 assets 部分中声明它：

```dart
flutter: 
  assets: 
    - packages/fancy_backgrounds/backgrounds/background1.png 
```

* lib/ 是隐含的，所以它不应该包含在资产路径中。 

---

**特定平台 assets**  
**设置app图标**  
* 上面的资源都是 flutter 应用中的，这些资源只有在 Flutter 框架运行之后才能使用，如果要给我们的应用设置 APP 图标或者添加启动图，那我们必须使用特定平台的 assets 。 
* 设置 APP 图标 
* 更新 Flutter 应用程序启动图标的方式与在本机 Android 或 iOS 应用程序中更新启动图标的方式相同。 

**安卓**  
* 在 Flutter 项目的根目录中，导航到 .../android/app/src/main/res 目录，里面包含了各种资源文件夹（如 mipmap-hdpi 已包含占位符图像 ”ic_launcher.png” ）。 只需按照Android 开发人员指南 中的说明， 将其替换为所需的资源，并遵守每种屏幕密度（ dpi ）的建议图标大小标准。 
* 注意 :   如果您重命名 .png 文件，则还必须在您 AndroidManifest.xml 的 < application > 标签的 android:icon 属性中更新名称。 
* http://ww1.sinaimg.cn/large/006Akqprgy1g05xterijhj307109e74g.jpg

**ios**  
* 在 Flutter 项目的根目录中，导航到 .../ios/Runner 。该目录中 Assets.xcassets/AppIcon.appiconset 已经包含占位符图片。 只需将它们替换为适当大小的图片。保留原始文件名称。 
* 在 Flutter 框架加载时， Flutter 会使用本地平台机制绘制启动页。此启动页将持续到 Flutter 渲染应用程序的第一帧时。 
* 注意 :   这意味着如果您不在应用程序的 main() 方法中调用runApp   函数 （或者更具体地说，如果您不调用window.render 去响应window.onDrawFrame ）的话， 启动屏幕将永远持续显示。 
* http://ww1.sinaimg.cn/large/006Akqprgy1g05xt783vsj307s0bgdg3.jpg

**设置app启动页**  
**安卓**  
* 要将启动屏幕（ splash screen ）添加到您的 Flutter 应用程序， 请导航至 .../android/app/src/main 。在 res/drawable/launch_background.xml ，通过自定义 drawable 来实现自定义启动界面（你也可以直接换一张图片） 

** ios**  
* 要将图片添加到启动屏幕（ splash screen ）的中心，请导航至 .../ios/Runner 。在 Assets.xcassets/LaunchImage.imageset ， 拖入图片，并命名为 LaunchImage.png 、 LaunchImage@2x.png 、 LaunchImage@3x.png 。 如果你使用不同的文件名，那您还必须更新同一目录中的 Contents.json 文件，图片的具体尺寸可以查看苹果官方的标准。 
* 您也可以通过打开 Xcode 完全自定义 storyboard 。在 Project Navigator 中导航到 Runner/Runner 然后通过打开 Assets.xcassets 拖入图片，或者通过在 LaunchScreen.storyboard 中使用 Interface Builder 进行自定义。 
* http://ww1.sinaimg.cn/large/006Akqprgy1g05xty5439j30r207imxx.jpg

### Flutter和硬件和第三方服务以及平台交互

* 我怎么访问 GPS 传感器？
* 我怎么访问摄像头？
* 我怎么登录 Facebook？
* 我怎么使用 Firebase 特性？
* 我怎创建自己的原生集成层？

**Flutter和平台的原生代码交互？**  
* Flutter 的代码并不直接在平台之下运行，相反， Dart 代码构建的 Flutter 应用在设备上以原生的方式运行，却 “ 侧步躲开了 ” 平台提供的 SDK 。这意味着，例如，你在 Dart 中发起一个网络请求，它就直接在 Dart 的上下文中运行。你并不会用上平常在 iOS 或 Android 上使用的原生 API 。你的 Flutter 程序仍然被原生平台的   ViewController   管理作一个 view ，但是你并不会直接访问   ViewController   自身，或是原生框架。 
* 但这并不意味着 Flutter 不能和原生 API ，或任何你编写的原生代码交互。 Flutter 提供了  platform channels   ，来和管理你的 Flutter view 的 ViewController 通信和交互数据。平台管道本质上是一个异步通信机制，桥接了 Dart 代码和宿主 ViewController ，以及它运行于的 iOS 框架。你可以用平台管道来执行一个原生的函数，或者是从设备的传感器中获取数据。 
* 除了直接使用平台管道之外，你还可以使用一系列预先制作好的  plugins 。例如，你可以直接使用插件来访问相机胶卷或是设备的摄像头，而不必编写你自己的集成层代码。你可以在  Pub   上找到插件，这是一个 Dart 和 Flutter 的开源包仓库。其中一些包可能会支持集成 iOS 或 Android ，或两者均可。 
* 如果你在 Pub 上找不到符合你需求的插件，你可以自己编写   ，并且发布在 Pub 上 。 
* https://flutterchina.club/platform-channels/

---

**platform channels的方式**
* 但这并不意味着 Flutter 不能和原生 API ，或任何你编写的原生代码交互。 Flutter 提供了  platform channels   ，来和管理你的 Flutter view 的 ViewController 通信和交互数据。平台管道本质上是一个异步通信机制，桥接了 Dart 代码和宿主 ViewController ，以及它运行于的 iOS 框架。你可以用平台管道来执行一个原生的函数，或者是从设备的传感器中获取数据。 

---

**plugins的方式**
* flutter插件开源 https://github.com/flutter/plugins
* 除了直接使用平台管道之外，你还可以使用一系列预先制作好的  plugins 。例如，你可以直接使用插件来访问相机胶卷或是设备的摄像头，而不必编写你自己的集成层代码。你可以在  Pub   上找到插件，这是一个 Dart 和 Flutter 的开源包仓库。其中一些包可能会支持集成 iOS 或 Android ，或两者均可。 
* 如果你在 Pub 上找不到符合你需求的插件，你可以自己编写   ，并且发布在 Pub 上 。 

---

**使用平台通道编写平台特定的代码**
* 译者语：所谓 “ 平台特定 ” 或 “ 特定平台 ” ，平台指的就是原生 Android 或 IOS ，本文主要讲原生和 Flutter 之间如何通信、如何进行功能互调。 
* Flutter 平台特定的 API 支持不依赖于代码生成，而是依赖于灵活的消息传递的方式： 
	* 应用的 Flutter 部分通过平台通道（ platform channel ）将消息发送到其应用程序的所在的宿主（ iOS 或 Android ）。
	* 宿主监听的平台通道，并接收该消息。然后它会调用特定于该平台的 API （使用原生编程语言） - 并将响应发送回客户端，即应用程序的 Flutter 部分。

---

**框架概述: 平台通道**
* 消息和响应是异步传递的，以确保用户界面保持响应 ( 不会挂起 ) 。 
* 在客户端， MethodChannel  (API ) 可以发送与方法调用相对应的消息。 在宿主平台上， MethodChannel   在 Android （ (API ) 和 FlutterMethodChannel iOS (API ) 可以接收方法调用并返回结果。这些类允许您用很少的 “ 脚手架 ” 代码开发平台插件。 
* 注意 : 如果需要，方法调用也可以反向发送，宿主作为客户端调用 Dart 中实现的 API 。 这个quick_actions 插件就是一个具体的例子 
* http://ww1.sinaimg.cn/large/006Akqprgy1g06xvga7uaj30g40hzmxi.jpg

---

**平台通道数据类型支持和解码器**
* 标准平台通道使用标准消息编解码器，以支持简单的类似 JSON 值的高效二进制序列化，例如 booleans,numbers, Strings, byte buffers, List, Maps （请参阅StandardMessageCodec 了解详细信息）。 当您发送和接收值时，这些值在消息中的序列化和反序列化会自动进行。 
* 下表显示了如何在宿主上接收 Dart 值，反之亦然：

```dart
Dart 
Android 
iOS 
null 
null 
nil (NSNull when nested) 
bool 
java.lang.Boolean 
NSNumber numberWithBool: 
int 
java.lang.Integer 
NSNumber numberWithInt: 
int, if 32 bits not enough 
java.lang.Long 
NSNumber numberWithLong: 
int, if 64 bits not enough 
java.math.BigInteger 
FlutterStandardBigInteger 
double 
java.lang.Double 
NSNumber numberWithDouble: 
String 
java.lang.String 
NSString 
Uint8List 
byte[] 
FlutterStandardTypedData typedDataWithBytes: 
Int32List 
int[] 
FlutterStandardTypedData typedDataWithInt32: 
Int64List 
long[] 
FlutterStandardTypedData typedDataWithInt64: 
Float64List 
double[] 
FlutterStandardTypedData typedDataWithFloat64: 
List 
java.util.ArrayList 
NSArray 
Map 
java.util.HashMap 
NSDictionary 
```

* 示例: 使用平台通道调用iOS和Android代码-获取电量
* 以下演示如何调用平台特定的 API 来获取和显示当前的电池电量。它通过一个平台消息 getBatteryLevel   调用 Android  BatteryManager  API 和 iOS  device.batteryLevel  API 。 。 
* 该示例在应用程序内添加了特定于平台的代码。如果您想开发一个通用的平台包，可以在其它应用中也使用的话，你需要开发一个插件， 则项目创建步骤稍有不同（请参阅开发 packages ），但平台通道代码仍以相同方式编写。 
* 注意 : 此示例的完整的可运行源代码位于：/examples/platform_channel/ ， 这个示例 Android 是用的 Java, IOS 用的是 Objective-C ， IOS Swift 版本请参阅  /examples/platform_channel_swift/ 

---

**Step 1: 创建一个新的应用程序项目**
* 首先创建一个新的应用程序 : 
	* 在终端运行中： flutter create batterylevel 
	* 默认情况下，模板支持使用 Java 编写 Android 代码，或使用 Objective-C 编写 iOS 代码。要使用 Kotlin 或 Swift ，请使用 -i 和 / 或 -a 标志 : 
	* 在终端中运行 :  flutter create -i swift -a kotlin batterylevel 

---

**Step 2: 创建Flutter平台客户端**
* 该应用的 State 类拥有当前的应用状态。我们需要延长这一点以保持当前的电量 
* 首先，我们构建通道。我们使用 MethodChannel 调用一个方法来返回电池电量。 
* 通道的客户端和宿主通过通道构造函数中传递的通道名称进行连接。单个应用中使用的所有通道名称必须是唯一的 ; 我们建议在通道名称前加一个唯一的 “ 域名前缀 ” ，例如 samples.flutter.io/battery 。 

```dart
import 'dart:async' ; 
import 'package:flutter/material.dart' ; 
import 'package:flutter/services.dart' ; 
... 
class _MyHomePageState extends State < MyHomePage > { 
  static const platform = const MethodChannel ( 'samples.flutter.io/battery' ); 

  // Get battery level. 
} 
```

* 接下来，我们调用通道上的方法，指定通过字符串标识符调用方法 getBatteryLevel 。 该调用可能失败 - 例如，如果平台不支持平台 API （例如在模拟器中运行时），所以我们将 invokeMethod 调用包装在 try-catch 语句中。 
* 我们使用返回的结果，在 setState 中来更新用户界面状态 batteryLevel 。 

```dart
// Get battery level. 
  String _batteryLevel = 'Unknown battery level.' ; 

  Future < Null > _getBatteryLevel () async { 
    String batteryLevel ; 
    try { 
      final int result = await platform . invokeMethod ( 'getBatteryLevel' ); 
      batteryLevel = 'Battery level at $result % .' ; 
    } on PlatformException catch ( e ) { 
      batteryLevel = "Failed to get battery level: '${e.message}'." ; 
    } 

    setState (() { 
      _batteryLevel = batteryLevel ; 
    }); 
  } 
```

* 最后，我们在 build 创建包含一个小字体显示电池状态和一个用于刷新值的按钮的用户界面。 

```dart
@override 
Widget build ( BuildContext context ) { 
  return new Material ( 
    child : new Center ( 
      child : new Column ( 
        mainAxisAlignment : MainAxisAlignment . spaceEvenly , 
        children : [ 
          new RaisedButton ( 
            child : new Text ( 'Get Battery Level' ), 
            onPressed : _getBatteryLevel , 
          ), 
          new Text ( _batteryLevel ), 
        ], 
      ), 
    ), 
  ); 
} 
```

---

**Step 3a: 使用Java添加Android平台特定的实现**
* 注意 : 以下步骤使用 Java 。如果您更喜欢 Kotlin ，请跳到步骤 3b. 
* 首先在 Android Studio 中打开您的 Flutter 应用的 Android 部分： 
	* 启动 Android Studio 
	* 选择 ‘File > Open…’ 
	* 定位到您 Flutter app 目录 , 然后选择里面的   android 文件夹，点击 OK 
	* 在 java 目录下打开   MainActivity.java 
* 接下来，在 onCreate 里创建 MethodChannel 并设置一个 MethodCallHandler 。确保使用与在 Flutter 客户端使用的通道名称相同。 

```dart
import io . flutter . app . FlutterActivity ; 
import io . flutter . plugin . common . MethodCall ; 
import io . flutter . plugin . common . MethodChannel ; 
import io . flutter . plugin . common . MethodChannel . MethodCallHandler ; 
import io . flutter . plugin . common . MethodChannel . Result ; 

public class MainActivity extends FlutterActivity { 
    private static final String CHANNEL = "samples.flutter.io/battery" ; 

    @Override 
    public void onCreate ( Bundle savedInstanceState ) { 

        super . onCreate ( savedInstanceState ); 

        new MethodChannel ( getFlutterView (), CHANNEL ). setMethodCallHandler ( 
                new MethodCallHandler () { 
                    @Override 
                    public void onMethodCall ( MethodCall call , Result result ) { 
                        // TODO 
                    } 
                }); 
    } 
} 
```

* 接下来，我们添加 Java 代码，使用 Android 电池 API 来获取电池电量。此代码与您在原生 Android 应用中编写的代码完全相同。 
* 首先，添加需要导入的依赖。 

```dart
import android.content.ContextWrapper; 
import android.content.Intent; 
import android.content.IntentFilter; 
import android.os.BatteryManager; 
import android.os.Build.VERSION; 
import android.os.Build.VERSION_CODES; 
import android.os.Bundle;
```

* 然后，将下面的新方法添加到 activity 类中的，位于 onCreate 方法下方： 

```dart
private int getBatteryLevel () { 
  int batteryLevel = - 1 ; 
  if ( VERSION . SDK_INT >= VERSION_CODES . LOLLIPOP ) { 
    BatteryManager batteryManager = ( BatteryManager ) getSystemService ( BATTERY_SERVICE ); 
    batteryLevel = batteryManager . getIntProperty ( BatteryManager . BATTERY_PROPERTY_CAPACITY ); 
  } else { 
    Intent intent = new ContextWrapper ( getApplicationContext ()). 
        registerReceiver ( null , new IntentFilter ( Intent . ACTION_BATTERY_CHANGED )); 
    batteryLevel = ( intent . getIntExtra ( BatteryManager . EXTRA_LEVEL , - 1 ) * 100 ) / 
        intent . getIntExtra ( BatteryManager . EXTRA_SCALE , - 1 ); 
  } 

  return batteryLevel ; 
} 
```

* 最后，我们完成之前添加的 onMethodCall 方法。我们需要处理平台方法名为 getBatteryLevel ，所以我们在 call 参数中进行检测是否为 getBatteryLevel 。 这个平台方法的实现只需调用我们在前一步中编写的 Android 代码，并使用 response 参数返回成功和错误情况的响应。如果调用未知的方法，我们也会通知返回：

```dart
@Override 
public void onMethodCall ( MethodCall call , Result result ) { 
    if ( call . method . equals ( "getBatteryLevel" )) { 
        int batteryLevel = getBatteryLevel (); 

        if ( batteryLevel != - 1 ) { 
            result . success ( batteryLevel ); 
        } else { 
            result . error ( "UNAVAILABLE" , "Battery level not available." , null ); 
        } 
    } else { 
        result . notImplemented (); 
    } 
}     
```

* 您现就可以在 Android 上运行该应用程序。如果您使用的是 Android 模拟器，则可以通过工具栏中的 ... 按钮访问 Extended Controls 面板中的电池电量 

---

**Step 3b: 使用Kotlin添加Android平台特定的实现**
* 注意 : 以下步骤与步骤 3a 类似，只是使用 Kotlin 而不是 Java 。 
* 此步骤假定您在step 1. 中 使用该 -a kotlin 选项创建了项目 
* 首先在 Android Studio 中打开您的 Flutter 应用的 Android 部分 
	* 启动 Android Studio 
	* 选择 the menu item ‘File > Open…’ 
	* 定位到您 Flutter app 目录 , 然后选择里面的   android 文件夹，点击 OK 
	* 在 kotlin 目录中打开 MainActivity.kt . ( 注意：如果您使用 Android Studio 2.3 进行编辑，请注意 ’kotlin’ 文件夹将显示为 ’java’ 。 ) 
* 接下来，在 onCreate 里创建 MethodChannel 并设置一个 MethodCallHandler 。确保使用与在 Flutter 客户端使用的通道名称相同。 

```dart
import android . os . Bundle 
import io . flutter . app . FlutterActivity 
import io . flutter . plugin . common . MethodChannel 
import io . flutter . plugins . GeneratedPluginRegistrant 

class MainActivity () : FlutterActivity () { 
  private val CHANNEL = "samples.flutter.io/battery" 

  override fun onCreate ( savedInstanceState : Bundle ? ) { 
    super . onCreate ( savedInstanceState ) 
    GeneratedPluginRegistrant . registerWith ( this ) 

    MethodChannel ( flutterView , CHANNEL ). setMethodCallHandler { call , result -> 
      // TODO 
    } 
  } 
} 
```

* 接下来，我们添加 Kotlin 代码，使用 Android 电池 API 来获取电池电量。此代码与您在原生 Android 应用中编写的代码完全相同。 
* 首先，添加需要导入的依赖。 

```dart
import android.content.Context 
import android.content.ContextWrapper 
import android.content.Intent 
import android.content.IntentFilter 
import android.os.BatteryManager 
import android.os.Build.VERSION 
import android.os.Build.VERSION_CODES 
```

* 然后，将下面的新方法添加到 activity 类中的，位于 onCreate 方法下方： 

```dart
private fun getBatteryLevel () : Int { 
val batteryLevel : Int 
if ( VERSION . SDK_INT >= VERSION_CODES . LOLLIPOP ) { 
  val batteryManager = getSystemService ( Context . BATTERY_SERVICE ) as BatteryManager 
  batteryLevel = batteryManager . getIntProperty ( BatteryManager . BATTERY_PROPERTY_CAPACITY ) 
} else { 
  val intent = ContextWrapper ( applicationContext ). registerReceiver ( null , IntentFilter ( Intent . ACTION_BATTERY_CHANGED )) 
  batteryLevel = intent !! . getIntExtra ( BatteryManager . EXTRA_LEVEL , - 1 ) * 100 / intent . getIntExtra ( BatteryManager . EXTRA_SCALE , - 1 ) 
} 

return batteryLevel 
}
```
  
* 最后，我们完成之前添加的 onMethodCall 方法。我们需要处理平台方法名为 getBatteryLevel ，所以我们在 call 参数中进行检测是否为 getBatteryLevel 。 这个平台方法的实现只需调用我们在前一步中编写的 Android 代码，并使用 response 参数返回成功和错误情况的响应。如果调用未知的方法，我们也会通知返回：

```dart
MethodChannel ( flutterView , CHANNEL ). setMethodCallHandler { call , result -> 
  if ( call . method == "getBatteryLevel" ) { 
    val batteryLevel = getBatteryLevel () 

    if ( batteryLevel != - 1 ) { 
      result . success ( batteryLevel ) 
    } else { 
      result . error ( "UNAVAILABLE" , "Battery level not available." , null ) 
    } 
  } else { 
    result . notImplemented () 
  } 
} 	
```

* 您现就可以在 Android 上运行该应用程序。如果您使用的是 Android 模拟器，则可以通过工具栏中的 ... 按钮访问 Extended Controls 面板中的电池电量 

---

**Step 4a: 使用Objective-C添加iOS平台特定的实现**
* 注意 : 以下步骤使用 Objective-C 。如果您喜欢 Swift ，请跳到步骤 4b 
* 首先打开 Xcode 中 Flutter 应用程序的 iOS 部分 : 
	* 启动 Xcode 
	* 选择 ‘File > Open…’ 
	* 定位到您 Flutter app 目录 , 然后选择里面的   iOS 文件夹，点击 OK 
	* 确保 Xcode 项目的构建没有错误。 
	* 选择 Runner > Runner ，打开 `AppDelegate.m 
* 接下来，在 application didFinishLaunchingWithOptions: 方法内部创建一个 FlutterMethodChannel ，并添加一个处理方法。 确保与在 Flutter 客户端使用的通道名称相同。

```dart
# import <Flutter/Flutter.h> 

@implementation AppDelegate 
- ( BOOL ) application :( UIApplication * ) application didFinishLaunchingWithOptions :( NSDictionary * ) launchOptions { 
  FlutterViewController * controller = ( FlutterViewController * ) self . window . rootViewController ; 

  FlutterMethodChannel * batteryChannel = [ FlutterMethodChannel 
                                          methodChannelWithName : @"samples.flutter.io/battery" 
                                          binaryMessenger : controller ]; 

  [ batteryChannel setMethodCallHandler : ^ ( FlutterMethodCall * call , FlutterResult result ) { 
    // TODO 
  }]; 

  return [ super application : application didFinishLaunchingWithOptions : launchOptions ]; 
} 
```

* 接下来，我们添加 ObjectiveC 代码，使用 iOS 电池 API 来获取电池电量。此代码与您在本机 iOS 应用程序中编写的代码完全相同。 
* 在 AppDelegate 类中添加以下新的方法： 

```dart
- ( int ) getBatteryLevel { 
  UIDevice * device = UIDevice . currentDevice ; 
  device . batteryMonitoringEnabled = YES ; 
  if ( device . batteryState == UIDeviceBatteryStateUnknown ) { 
    return - 1 ; 
  } else { 
    return ( int )( device . batteryLevel * 100 ); 
  } 
} 
```

* 最后，我们完成之前添加的 setMethodCallHandler 方法。我们需要处理的平台方法名为 getBatteryLevel ，所以我们在 call 参数中进行检测是否为 getBatteryLevel 。 这个平台方法的实现只需调用我们在前一步中编写的 IOS 代码，并使用 response 参数返回成功和错误情况的响应。如果调用未知的方法，我们也会通知返回：

```dart
[ batteryChannel setMethodCallHandler : ^ ( FlutterMethodCall * call , FlutterResult result ) { 
  if ([ @"getBatteryLevel" isEqualToString : call . method ]) { 
    int batteryLevel = [ self getBatteryLevel ]; 

    if ( batteryLevel == - 1 ) { 
      result ([ FlutterError errorWithCode : @"UNAVAILABLE" 
                                 message : @"Battery info unavailable" 
                                 details : nil ]); 
    } else { 
      result ( @ ( batteryLevel )); 
    } 
  } else { 
    result ( FlutterMethodNotImplemented ); 
  } 
}]; 
```

* 您现在可以在 iOS 上运行应用程序。如果您使用的是 iOS 模拟器，请注意，它不支持电池 API ，因此应用程序将显示 “ 电池信息不可用 ” 。 

---

**Step 4b: 使用Swift添加一个iOS平台的实现**
* 注意 : 以下步骤与步骤 4a 类似，只不过是使用 Swift 而不是 Objective-C. 
* 此步骤假定您在步骤 1 中 使用 -i swift 选项创建了项目。 
* 首先打开 Xcode 中 Flutter 应用程序的 iOS 部分 : 
	* 启动 Xcode 
	* 选择 ‘File > Open…’ 
	* 定位到您 Flutter app 目录 , 然后选择里面的   ios 文件夹，点击 OK 
	* 确保 Xcode 项目的构建没有错误。 
	* 选择 Runner > Runner ，然后打开 AppDelegate.swift 
* 接下来，覆盖 application 方法并创建一个 FlutterMethodChannel 绑定通道名称 samples.flutter.io/battery ： 

```dart
@UIApplicationMain 
@objc class AppDelegate : FlutterAppDelegate { 
  override func application ( 
    _ application : UIApplication , 
    didFinishLaunchingWithOptions launchOptions : [ UIApplicationLaunchOptionsKey : Any ] ? ) -> Bool { 
    GeneratedPluginRegistrant . register ( with : self ); 

    let controller : FlutterViewController = window ? . rootViewController as ! FlutterViewController ; 
    let batteryChannel = FlutterMethodChannel . init ( name : "samples.flutter.io/battery" , 
                                                   binaryMessenger : controller ); 
    batteryChannel . setMethodCallHandler ({ 
      ( call : FlutterMethodCall , result : FlutterResult ) -> Void in 
      // Handle battery messages. 
    }); 
    
    return super . application ( application , didFinishLaunchingWithOptions : launchOptions ); 
  } 
} 
```

* 接下来，我们添加 Swift 代码，使用 iOS 电池 API 来获取电池电量。此代码与您在本机 iOS 应用程序中编写的代码完全相同。 
* 将以下新方法添加到 AppDelegate.swift 底部 

```dart
private func receiveBatteryLevel ( result : FlutterResult ) { 
  let device = UIDevice . current ; 
  device . isBatteryMonitoringEnabled = true ; 
  if ( device . batteryState == UIDeviceBatteryState . unknown ) { 
    result ( FlutterError . init ( code : "UNAVAILABLE" , 
                             message : "Battery info unavailable" , 
                             details : nil )); 
  } else { 
    result ( Int ( device . batteryLevel * 100 )); 
  } 
} 
```

* 最后，我们完成之前添加的 setMethodCallHandler 方法。我们需要处理的平台方法名为 getBatteryLevel ，所以我们在 call 参数中进行检测是否为 getBatteryLevel 。 这个平台方法的实现只需调用我们在前一步中编写的 IOS 代码，并使用 response 参数返回成功和错误情况的响应。如果调用未知的方法，我们也会通知返回： 

```dart
batteryChannel . setMethodCallHandler ({ 
  ( call : FlutterMethodCall , result : FlutterResult ) -> Void in 
  if ( "getBatteryLevel" == call . method ) { 
    receiveBatteryLevel ( result : result ); 
  } else { 
    result ( FlutterMethodNotImplemented ); 
  } 
});
```
 
* 您现在可以在 iOS 上运行应用程序。如果您使用的是 iOS 模拟器，请注意，它不支持电池 API ，因此应用程序将显示 “ 电池信息不可用 ” 。

---

* 从UI代码中分离平台特定的代码
* 如果您希望在多个 Flutter 应用程序中使用特定于平台的代码，将代码分离为位于主应用程序之外的目录中，做一个平台插件会很有用。详情请参阅开发 packages   。 

---

* 将平台特定的代码作为一个包发布
* 如果您希望与 Flutter 生态系统中的其他开发人员分享您的特定平台的代码，请参阅发 [ 发布 packages](/developing-packages/#publish 以了解详细信息。 )

---

* 自定义平台通道和编解码器
* 除了上面提到的 MethodChannel ，你还可以使用BasicMessageChannel ，它支持使用自定义消息编解码器进行基本的异步消息传递。 此外，您可以使用专门的BinaryCodec ，StringCodec 和  JSONMessageCodec 类，或创建自己的编解码器。 

---

* 我怎么访问 GPS 传感器？
* 使用  location   社区插件。 

---

* 我怎么访问摄像头？
* image_picker   在访问摄像头时非常常用。 

---

* 我怎么登录 Facebook？
* 登录 Facebook 可以使用  flutter_facebook_login   社区插件。 

---

* 我怎么使用 Firebase 特性？
* 大多数 Firebase 特性被  first party plugins   包含了。这些第一方插件由 Flutter 团队维护：

```dart
firebase_admob  for Firebase AdMob 
firebase_analytics  for Firebase Analytics 
firebase_auth  for Firebase Auth 
firebase_core  for Firebase’s Core package 
firebase_database  for Firebase RTDB 
firebase_storage  for Firebase Cloud Storage 
firebase_messaging  for Firebase Messaging (FCM) 
cloud_firestore  for Firebase Cloud Firestore 
```

* 你也可以在 Pub 上找到 Firebase 的第三方插件。 

---

* 我怎创建自己的原生集成层？
* 如果有一些 Flutter 和社区插件遗漏的平台相关的特性，可以根据  developing packages and plugins   页面构建自己的插件。 
* Flutter 的插件结构，简要来说，就像 Android 中的 Event bus 。你发送一个消息，并让接受者处理并反馈结果给你。在这种情况下，接受者就是在 Android 或 iOS 上的原生代码。 

### Flutter的Viewcontrollers

** ViewController 相当于 Flutter 中的什么？** 
* 在 iOS 中，一个 ViewController 代表了用户界面的一部分，最常用于一个屏幕，或是其中一部分。它们被组合在一起用于构建复杂的用户界面，并帮助你拆分 App 的 UI 。在 Flutter 中，这一任务回落到了 widgets 中。就像在界面导航部分提到的一样，一个屏幕也是被 widgets 来表示的，因为 “ 万物皆 widget ！ ” 。使用   Navigator   在   Route   之间跳转，或者渲染相同数据的不同状态。 

** 我该怎么监听 iOS 中的生命周期事件？** 
* 在 iOS 中，你可以重写   ViewController   中的方法来捕获它的视图的生命周期，或者在   AppDelegate   中注册生命周期的回调函数。在 Flutter 中没有这两个概念，但你可以通过 hook  WidgetsBinding   观察者来监听生命周期事件，并监听   didChangeAppLifecycleState()   的变化事件。 
* 可观察的生命周期事件有： 
	* inactive  - 应用处于不活跃的状态，并且不会接受用户的输入。这个事件仅工作在 iOS 平台，在 Android 上没有等价的事件。 
	* paused  - 应用暂时对用户不可见，虽然不接受用户输入，但是是在后台运行的。 
	* resumed  - 应用可见，也响应用户的输入。 
	* suspending  - 应用暂时被挂起，在 iOS 上没有这一事件。 
	* 更多关于这些状态的细节和含义，请参见  AppLifecycleStatus  documentation   。 

### Flutter的flutterForiOS开发者

* 本文档适用那些希望将现有 iOS 经验应用于 Flutter 的开发者。如果你拥有 iOS 开发基础，那么你可以使用这篇文档开始学习 Flutter 的开发。 
* 开发 Flutter 时，你的 iOS 经验和技能将会大有裨益，因为 Flutter 依赖于移动操作系统的众多功能和配置。 Flutter 是用于为移动设备构建用户界面的全新方式，但它也有一个插件系统用于和 iOS （及 Android ）进行非 UI 任务的通信。如果你是 iOS 开发专家，则你不必将 Flutter 彻底重新学习一遍。 
* 你可以将此文档作为 cookbook ，通过跳转并查找与你的需求最相关的问题。 
* https://flutterchina.club/flutter-for-ios/

### Flutter的主题和文字
* 主题和文字
* 我怎么给 App 设置主题？
* 你也可以在你的 App 中使用 WidgetApp，它提供了许多相似的功能，但不如 MaterialApp 那样强大。
* 对任何子组件定义颜色和样式，可以给 MaterialApp widget 传递一个 ThemeData 对象。举个例子，在下面的代码中，primary swatch 被设置为蓝色，并且文字的选中颜色是红色：
* 我怎么给 Text widget 设置自定义字体？
* 我怎么给我的 Text widget 设置样式？

---

**  我怎么给 App 设置主题？**  
* 你也可以在你的 App 中使用 WidgetApp，它提供了许多相似的功能，但不如 MaterialApp 那样强大。
* 对任何子组件定义颜色和样式，可以给 MaterialApp widget 传递一个 ThemeData 对象。举个例子，在下面的代码中，primary swatch * 被设置为蓝色，并且文字的选中颜色是红色：
* Flutter 实现了一套漂亮的 MD 组件，并且开箱可用。它接管了一大堆你需要的样式和主题。 
* 为了充分发挥你的 App 中 MD 组件的优势，声明一个顶级 widget ， MaterialApp ，用作你的 App 入口。 MaterialApp 是一个便利组件，包含了许多 App 通常需要的 MD 风格组件。它通过一个 WidgetsApp 添加了 MD 功能来实现。 
* 但是 Flutter 足够地灵活和富有表现力来实现任何其他的设计语言。在 iOS 上，你可以用  Cupertino library   来制作遵守  Human Interface Guidelines   的界面。查看这些 widget 的集合，请参阅  Cupertino widgets gallery 。 
* 你也可以在你的 App 中使用 WidgetApp ，它提供了许多相似的功能，但不如   MaterialApp   那样强大。 
* 对任何子组件定义颜色和样式，可以给   MaterialApp  widget 传递一个   ThemeData   对象。举个例子，在下面的代码中， primary swatch 被设置为蓝色，并且文字的选中颜色是红色：

```dart
class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
        textSelectionColor : Colors . red 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 
```

* 对任何子组件定义颜色和样式，可以给 MaterialApp widget 传递一个 ThemeData 对象。举个例子，在下面的代码中，primary swatch 被设置为蓝色，并且文字的选中颜色是红色：

```dart
class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
        textSelectionColor : Colors . red 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 
```

**我怎么给 Text widget 设置自定义字体？**
* 在 iOS 中，你在项目中引入任意的   ttf   文件，并在   info.plist   中设置引用。在 Flutter 中，在文件夹中放置字体文件，并在   pubspec.yaml   中引用它，就像添加图片那样。 

```dart
fonts: 
   - family: MyCustomFont 
     fonts: 
       - asset: fonts/MyCustomFont.ttf 
       - style: italic 
```

* 然后在你的   Text  widget 中指定字体： 

```dart
@override 
Widget build ( BuildContext context ) { 
  return Scaffold ( 
    appBar : AppBar ( 
      title : Text ( "Sample App" ), 
    ), 
    body : Center ( 
      child : Text ( 
        'This is a custom font text' , 
        style : TextStyle ( fontFamily : 'MyCustomFont' ), 
      ), 
    ), 
  ); 
} 
```

---

**我怎么给我的 Text widget 设置样式？**  
* 除了字体以外，你也可以给 Text widget 的样式元素设置自定义值。 Text  widget 接受一个   TextStyle   对象，你可以指定许多参数，比如： 

```dart
color 
decoration 
decorationColor 
decorationStyle 
fontFamily 
fontSize 
fontStyle 
fontWeight 
hashCode 
height 
inherit 
letterSpacing 
textBaseline 
wordSpacing 
```

### Flutter的线程和异步
* 线程和异步
* 我怎么编写异步的代码？
* Flutter 的 event loop 和 iOS 中的 main loop 相似
* Dart 的单线程模型并不意味着你写的代码一定是阻塞操作，从而卡住 UI。相反，使用 Dart 语言提供的异步工具，例如 async / await ，来实现异步操作
* 编写网络请求代码而不会挂起 UI例子
* 例子展示了异步加载数据，并用 ListView 展示出来
* 你是怎么把工作放到后台线程的？
* 有时候你需要处理大量的数据，这会导致你的 UI 挂起
* 在 Flutter 中，使用 Isolate 来发挥多核心 CPU 的优势来处理那些长期运行或是计算密集型的任务。
* Isolates 是分离的运行线程，并且不和主线程的内存堆共享内存。这意味着你不能访问主线程中的变量，或者使用 setState() 来更新 UI。正如它们的名字一样，Isolates 不能共享内存。
* 展示了一个简单的 isolate，是如何把数据返回给主线程来更新 UI 的：
* 这里，dataLoader() 是一个运行于自己独立执行线程上的 Isolate。在 isolate 里，你可以执行 CPU 密集型任务（例如解析一个庞大的 json），或是计算密集型的数学操作，如加密或信号处理等。
* 我怎么发起网络请求？http package
* 我怎么展示一个长时间运行的任务的进度？
* 在下面的例子中，build 函数被拆分成三个函数。如果 showLoadingDialog() 是 true （当 widgets.length == 0 时），则渲染 ProgressIndicator。否则，当数据从网络请求中返回时，渲染 ListView 。

---

**我怎么编写异步的代码？**
* Flutter 的 event loop 和 iOS 中的 main loop 相似
* Dart 的单线程模型并不意味着你写的代码一定是阻塞操作，从而卡住 UI。相反，使用 Dart 语言提供的异步工具，例如 async / await ，来实现异步操作
* 编写网络请求代码而不会挂起 UI例子
* 例子展示了异步加载数据，并用 ListView 展示出来
* Dart 是单线程执行模型，但是它支持   Isolate （一种让 Dart 代码运行在其他线程的方式）、事件循环和异步编程。除非你自己创建一个   Isolate   ，否则你的 Dart 代码永远运行在 UI 线程，并由 event loop 驱动。 Flutter 的 event loop 和 iOS 中的 main loop 相似 —— Looper   是附加在主线程上的。 
* Dart 的单线程模型并不意味着你写的代码一定是阻塞操作，从而卡住 UI 。相反，使用 Dart 语言提供的异步工具，例如   async  /  await   ，来实现异步操作。 
* 举个例子，你可以使用   async  /  await   来让 Dart 帮你做一些繁重的工作，编写网络请求代码而不会挂起 UI ： 

```dart
loadData () async { 
  String dataURL = "https://jsonplaceholder.typicode.com/posts" ; 
  http . Response response = await http . get ( dataURL ); 
  setState (() { 
    widgets = json . decode ( response . body ); 
  }); 
} 
```

* 一旦   await   到网络请求完成，通过调用   setState()   来更新 UI ，这会触发 widget 子树的重建，并更新相关数据。 
* 下面的例子展示了异步加载数据，并用   ListView   展示出来： 

```dart
import 'dart:convert' ; 
import 'package:flutter/material.dart' ; 
import 'package:http/http.dart' as http ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 

    loadData (); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView . builder ( 
          itemCount : widgets . length , 
          itemBuilder : ( BuildContext context , int position ) { 
            return getRow ( position ); 
          })); 
  } 

  Widget getRow ( int i ) { 
    return Padding ( 
      padding : EdgeInsets . all ( 10.0 ), 
      child : Text ( "Row ${widgets[i][" title "]}" ) 
    ); 
  } 

  loadData () async { 
    String dataURL = "https://jsonplaceholder.typicode.com/posts" ; 
    http . Response response = await http . get ( dataURL ); 
    setState (() { 
      widgets = json . decode ( response . body ); 
    }); 
  } 
} 
```

* 更多关于在后台工作的信息，以及 Flutter 和 iOS 的区别，请参考下一章节。 

---

**编写网络请求代码而不会挂起 UI例子**

```dart
loadData () async { 
  String dataURL = "https://jsonplaceholder.typicode.com/posts" ; 
  http . Response response = await http . get ( dataURL ); 
  setState (() { 
    widgets = json . decode ( response . body ); 
  }); 
} 
```

---

**例子展示了异步加载数据，并用 ListView 展示出来**

```dart

import 'dart:convert' ; 
import 'package:flutter/material.dart' ; 
import 'package:http/http.dart' as http ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 

    loadData (); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView . builder ( 
          itemCount : widgets . length , 
          itemBuilder : ( BuildContext context , int position ) { 
            return getRow ( position ); 
          })); 
  } 

  Widget getRow ( int i ) { 
    return Padding ( 
      padding : EdgeInsets . all ( 10.0 ), 
      child : Text ( "Row ${widgets[i][" title "]}" ) 
    ); 
  } 

  loadData () async { 
    String dataURL = "https://jsonplaceholder.typicode.com/posts" ; 
    http . Response response = await http . get ( dataURL ); 
    setState (() { 
      widgets = json . decode ( response . body ); 
    }); 
  } 
} 
```

---

**你是怎么把工作放到后台线程的？**
* 有时候你需要处理大量的数据，这会导致你的 UI 挂起
* 在 Flutter 中，使用 Isolate 来发挥多核心 CPU 的优势来处理那些长期运行或是计算密集型的任务。
* Isolates 是分离的运行线程，并且不和主线程的内存堆共享内存。这意味着你不能访问主线程中的变量，或者使用 setState() 来更新 UI。正如它们的名字一样，Isolates 不能共享内存。
* 展示了一个简单的 isolate，是如何把数据返回给主线程来更新 UI 的：
* 这里，dataLoader() 是一个运行于自己独立执行线程上的 Isolate。在 isolate 里，你可以执行 CPU 密集型任务（例如解析一个庞大的 json），或是计算密集型的数学操作，如加密或信号处理等。

**展示了一个简单的 isolate，是如何把数据返回给主线程来更新 UI 的：**

```dart
loadData () async { 
  ReceivePort receivePort = ReceivePort (); 
  await Isolate . spawn ( dataLoader , receivePort . sendPort ); 

  // The 'echo' isolate sends its SendPort as the first message 
  SendPort sendPort = await receivePort . first ; 

  List msg = await sendReceive ( sendPort , "https://jsonplaceholder.typicode.com/posts" ); 

  setState (() { 
    widgets = msg ; 
  }); 
} 

// The entry point for the isolate 
static dataLoader ( SendPort sendPort ) async { 
  // Open the ReceivePort for incoming messages. 
  ReceivePort port = ReceivePort (); 

  // Notify any other isolates what port this isolate listens to. 
  sendPort . send ( port . sendPort ); 

  await for ( var msg in port ) { 
    String data = msg [ 0 ]; 
    SendPort replyTo = msg [ 1 ]; 

    String dataURL = data ; 
    http . Response response = await http . get ( dataURL ); 
    // Lots of JSON to parse 
    replyTo . send ( json . decode ( response . body )); 
  } 
} 

Future sendReceive ( SendPort port , msg ) { 
  ReceivePort response = ReceivePort (); 
  port . send ([ msg , response . sendPort ]); 
  return response . first ; 
} 
```

---

* 这里，dataLoader() 是一个运行于自己独立执行线程上的 Isolate。在 isolate 里，你可以执行 CPU 密集型任务（例如解析一个庞大的 json），或是计算密集型的数学操作，如加密或信号处理等。

```dart
import 'dart:convert' ; 
import 'package:flutter/material.dart' ; 
import 'package:http/http.dart' as http ; 
import 'dart:async' ; 
import 'dart:isolate' ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 
    loadData (); 
  } 

  showLoadingDialog () { 
    if ( widgets . length == 0 ) { 
      return true ; 
    } 

    return false ; 
  } 

  getBody () { 
    if ( showLoadingDialog ()) { 
      return getProgressDialog (); 
    } else { 
      return getListView (); 
    } 
  } 

  getProgressDialog () { 
    return Center ( child : CircularProgressIndicator ()); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
        appBar : AppBar ( 
          title : Text ( "Sample App" ), 
        ), 
        body : getBody ()); 
  } 

  ListView getListView () => ListView . builder ( 
      itemCount : widgets . length , 
      itemBuilder : ( BuildContext context , int position ) { 
        return getRow ( position ); 
      }); 

  Widget getRow ( int i ) { 
    return Padding ( padding : EdgeInsets . all ( 10.0 ), child : Text ( "Row ${widgets[i][" title "]}" )); 
  } 

  loadData () async { 
    ReceivePort receivePort = ReceivePort (); 
    await Isolate . spawn ( dataLoader , receivePort . sendPort ); 

    // The 'echo' isolate sends its SendPort as the first message 
    SendPort sendPort = await receivePort . first ; 

    List msg = await sendReceive ( sendPort , "https://jsonplaceholder.typicode.com/posts" ); 

    setState (() { 
      widgets = msg ; 
    }); 
  } 

// the entry point for the isolate 
  static dataLoader ( SendPort sendPort ) async { 
    // Open the ReceivePort for incoming messages. 
    ReceivePort port = ReceivePort (); 

    // Notify any other isolates what port this isolate listens to. 
    sendPort . send ( port . sendPort ); 

    await for ( var msg in port ) { 
      String data = msg [ 0 ]; 
      SendPort replyTo = msg [ 1 ]; 

      String dataURL = data ; 
      http . Response response = await http . get ( dataURL ); 
      // Lots of JSON to parse 
      replyTo . send ( json . decode ( response . body )); 
    } 
  } 

  Future sendReceive ( SendPort port , msg ) { 
    ReceivePort response = ReceivePort (); 
    port . send ([ msg , response . sendPort ]); 
    return response . first ; 
  } 
} 
```

---

**我怎么发起网络请求？**
* http package
* https://flutterchina.club/cookbook/networking/fetch-data/
  
**http package**
* 在 Flutter 中，使用流行的  http package   做网络请求非常简单。它把你可能需要自己做的网络请求操作抽象了出来，让发起请求变得简单。 
* 要使用   http   包，在   pubspec.yaml   中把它添加为依赖： 

```dart
dependencies: 
  ... 
  http: ^0.11.3+16 
```

* 发起网络请求，在   http.get()   这个   async   方法中使用   await   ： 

```dart
import 'dart:convert' ; 
import 'package:flutter/material.dart' ; 
import 'package:http/http.dart' as http ; 
[...] 
  loadData () async { 
    String dataURL = "https://jsonplaceholder.typicode.com/posts" ; 
    http . Response response = await http . get ( dataURL ); 
    setState (() { 
      widgets = json . decode ( response . body ); 
    }); 
  } 
} 
```

---

**我怎么展示一个长时间运行的任务的进度？**
* 在下面的例子中，build 函数被拆分成三个函数。如果 showLoadingDialog() 是 true （当 widgets.length == 0 时），则渲染 ProgressIndicator。否则，当数据从网络请求中返回时，渲染 ListView 。
* 在 iOS 中，在后台运行耗时任务时你会使用   UIProgressView 。 
* 在 Flutter 中，使用一个   ProgressIndicator  widget 。通过一个布尔 flag 来控制是否展示进度。在任务开始时，告诉 Flutter 更新状态，并在结束后隐去。 
* 在下面的例子中， build 函数被拆分成三个函数。如果   showLoadingDialog()   是   true   （当   widgets.length == 0   时），则渲染   ProgressIndicator 。否则，当数据从网络请求中返回时，渲染   ListView   。 

```dart
import 'dart:convert' ; 
import 'package:flutter/material.dart' ; 
import 'package:http/http.dart' as http ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 
    loadData (); 
  } 

  showLoadingDialog () { 
    return widgets . length == 0 ; 
  } 

  getBody () { 
    if ( showLoadingDialog ()) { 
      return getProgressDialog (); 
    } else { 
      return getListView (); 
    } 
  } 

  getProgressDialog () { 
    return Center ( child : CircularProgressIndicator ()); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
        appBar : AppBar ( 
          title : Text ( "Sample App" ), 
        ), 
        body : getBody ()); 
  } 

  ListView getListView () => ListView . builder ( 
      itemCount : widgets . length , 
      itemBuilder : ( BuildContext context , int position ) { 
        return getRow ( position ); 
      }); 

  Widget getRow ( int i ) { 
    return Padding ( padding : EdgeInsets . all ( 10.0 ), child : Text ( "Row ${widgets[i][" title "]}" )); 
  } 

  loadData () async { 
    String dataURL = "https://jsonplaceholder.typicode.com/posts" ; 
    http . Response response = await http . get ( dataURL ); 
    setState (() { 
      widgets = json . decode ( response . body ); 
    }); 
  } 
} 
```

* 在下面的例子中，build 函数被拆分成三个函数。如果 showLoadingDialog() 是 true （当 widgets.length == 0 时），则渲染 ProgressIndicator。否则，当数据从网络请求中返回时，渲染 ListView 。

```dart
import 'dart:convert' ; 
import 'package:flutter/material.dart' ; 
import 'package:http/http.dart' as http ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 
    loadData (); 
  } 

  showLoadingDialog () { 
    return widgets . length == 0 ; 
  } 

  getBody () { 
    if ( showLoadingDialog ()) { 
      return getProgressDialog (); 
    } else { 
      return getListView (); 
    } 
  } 

  getProgressDialog () { 
    return Center ( child : CircularProgressIndicator ()); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
        appBar : AppBar ( 
          title : Text ( "Sample App" ), 
        ), 
        body : getBody ()); 
  } 

  ListView getListView () => ListView . builder ( 
      itemCount : widgets . length , 
      itemBuilder : ( BuildContext context , int position ) { 
        return getRow ( position ); 
      }); 

  Widget getRow ( int i ) { 
    return Padding ( padding : EdgeInsets . all ( 10.0 ), child : Text ( "Row ${widgets[i][" title "]}" )); 
  } 

  loadData () async { 
    String dataURL = "https://jsonplaceholder.typicode.com/posts" ; 
    http . Response response = await http . get ( dataURL ); 
    setState (() { 
      widgets = json . decode ( response . body ); 
    }); 
  } 
} 
```

### Flutter的数据库和本地存储

**我怎么在 Flutter 中访问 UserDefaults？** 
* 在 iOS 中，你可以使用属性列表来存储键值对的集合，即我们熟悉的 UserDefaults 。 
* 在 Flutter 中，可以使用Shared Preferences plugin来达到相似的功能。它包裹了UserDefaluts以及Android 上等价的SharedPreferences的功能。 

**CoreData 相当于 Flutter 中的什么？** 
* 在 iOS 中，你通过 CoreData 来存储结构化的数据。这是一个 SQL 数据库的上层封装，让查询和关联模型变得更加简单。 
* 在 Flutter 中，使用  SQFlite   插件来实现这个功能。 

**我怎么推送通知？** 
* 在 iOS 中，你需要向苹果开发者平台中注册来允许推送通知。 
* 在 Flutter 中，使用   firebase_messaging   插件来实现这一功能。 
* 更多使用 Firebase Cloud Messaging API 的信息，请参阅  firebase_messaging   插件文档。 

### Flutter的手势检测及触摸事件处理

**我怎么给 Flutter 的 widget 添加一个点击监听者？**  
* 如果 widget 本身支持事件监测，直接传递给它一个函数，并在这个函数里实现响应方法。例如，RaisedButton widget 拥有一个 RaisedButton 参数：
* 如果 widget 本身不支持事件监测，则在外面包裹一个 GestureDetector，并给它的 onTap 属性传递一个函数：

**如果 widget 本身支持事件监测，直接传递给它一个函数，并在这个函数里实现响应方法。例如，RaisedButton widget 拥有一个 RaisedButton 参数：**  

```dart
@override 
Widget build ( BuildContext context ) { 
  return RaisedButton ( 
    onPressed : () { 
      print ( "click" ); 
    }, 
    child : Text ( "Button" ), 
  ); 
} 
```

**如果 widget 本身不支持事件监测，则在外面包裹一个 GestureDetector，并给它的 onTap 属性传递一个函数：**  

```dart
class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      body : Center ( 
        child : GestureDetector ( 
          child : FlutterLogo ( 
            size : 200.0 , 
          ), 
          onTap : () { 
            print ( "tap" ); 
          }, 
        ), 
      ), 
    ); 
  } 
} 
```

**例子:展示了一个 GestureDetector 是如何在双击时旋转 Flutter 的 logo 的：**  
* 使用   GestureDetector   你可以监听更广阔范围内的手势，比如： 
	* Tapping 
	* onTapDown  — 在特定位置轻触手势接触了屏幕。 
	* onTapUp  — 在特定位置产生了一个轻触手势，并停止接触屏幕。 
	* onTap  — 产生了一个轻触手势。 
	* onTapCancel  — 触发了   onTapDown   但没能触发 tap 。 
	* Double tapping 
	* onDoubleTap  — 用户在同一个位置快速点击了两下屏幕。 
	* Long pressing 
	* onLongPress  — 用户在同一个位置长时间接触屏幕。 
	* Vertical dragging 
	* onVerticalDragStart  — 接触了屏幕，并且可能会垂直移动。 
	* onVerticalDragUpdate  — 接触了屏幕，并继续在垂直方向移动。 
	* onVerticalDragEnd  — 之前接触了屏幕并垂直移动，并在停止接触屏幕前以某个垂直的速度移动。 
	* Horizontal dragging 
	* onHorizontalDragStart  — 接触了屏幕，并且可能会水平移动。 
	* onHorizontalDragUpdate  — 接触了屏幕，并继续在水平方向移动。 
	* onHorizontalDragEnd  — 之前接触屏幕并水平移动的触摸点与屏幕分离。 

```dart
AnimationController controller ; 
CurvedAnimation curve ; 

@override 
void initState () { 
  controller = AnimationController ( duration : const Duration ( milliseconds : 2000 ), vsync : this ); 
  curve = CurvedAnimation ( parent : controller , curve : Curves . easeIn ); 
} 

class SampleApp extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      body : Center ( 
        child : GestureDetector ( 
          child : RotationTransition ( 
            turns : curve , 
            child : FlutterLogo ( 
              size : 200.0 , 
            )), 
          onDoubleTap : () { 
            if ( controller . isCompleted ) { 
              controller . reverse (); 
            } else { 
              controller . forward (); 
            } 
          }, 
        ), 
      ), 
    ); 
  } 
} 
```

### Flutter的基础widget(2019.2.14)

**概念**  
* 读者可以认为widget就是一个控件
* 在前面的介绍中，我们知道 Flutter 中几乎所有的对象都是一个 Widget ，与原生开发中 “ 控件 ” 不同的是， Flutter 中的 widget 的概念更广泛，它不仅可以表示 UI 元素，也可以表示一些功能性的组件如：用于手势检测的   GestureDetector  widget 、用于应用主题数据传递的 Theme 等等。而原生开发中的控件通常只是指 UI 元素。在后面的内容中，我们在描述 UI 元素时，我们可能会用到 “ 控件 ” 、 “ 组件 ” 这样的概念，读者心里需要知道他们就是 widget ，只是在不同场景的不同表述而已。由于 Flutter 主要就是用于构建用户界面的，所以，在大多数时候，读者可以认为 widget 就是一个控件，不必纠结于概念。 

**Widget与Element**  
* Widget其实并不是表示最终绘制在设备屏幕上的显示元素，而只是显示元素的一个配置数据。
* Flutter中真正代表屏幕上显示元素的类是Element，也就是说Widget只是描述Element的一个配置，
* Widget只是UI元素的一个配置数据，并且一个Widget可以对应多个Element
* 总结一下：
	* 宽泛地认为Widget树就是指UI控件树或UI渲染树
	* Widget树实际上是一个配置树，而真正的UI渲染树是由Element构成

---

* 在 Flutter 中， Widget 的功能是 “ 描述一个 UI 元素的配置数据 ” ，它就是说， Widget 其实并不是表示最终绘制在设备屏幕上的显示元素，而只是显示元素的一个配置数据。实际上， Flutter 中真正代表屏幕上显示元素的类是 Element ，也就是说 Widget 只是描述 Element 的一个配置，有关 Element 的详细介绍我们将在本书后面的高级部分深入介绍，读者现在只需要知道， Widget 只是 UI 元素的一个配置数据，并且一个 Widget 可以对应多个 Element ，这是因为同一个 Widget 对象可以被添加到 UI 树的不同部分，而真正渲染时， UI 树的每一个 Widget 节点都会对应一个 Element 对象。
* 总结一下： 
	* Widget 实际上就是 Element 的配置数据， Widget 树实际上是一个配置树，而真正的 UI 渲染树是由 Element 构成；不过，由于 Element 是通过 Widget 生成，所以它们之间有对应关系，所以在大多数场景，我们可以宽泛地认为 Widget 树就是指 UI 控件树或 UI 渲染树。 
	* 一个 Widget 对象可以对应多个 Element 对象。这很好理解，根据同一份配置（ Widget ），可以创建多个实例（ Element ）。 
	* 读者应该将这两点牢记在心中。 

---

* Widget只是UI元素的一个配置数据，并且一个Widget可以对应多个Element，这是因为同一个 Widget 对象可以被添加到 UI 树的不同部分，而真正渲染时， UI 树的每一个 Widget 节点都会对应一个 Element 对象。 
* 总结一下：
	* Widget 实际上就是 Element 的配置数据， Widget 树实际上是一个配置树，而真正的 UI 渲染树是由 Element 构成；不过，由于 Element 是通过 Widget 生成，所以它们之间有对应关系，所以在大多数场景，我们可以宽泛地认为 Widget 树就是指 UI 控件树或 UI 渲染树。 
	* 一个 Widget 对象可以对应多个 Element 对象。这很好理解，根据同一份配置（ Widget ），可以创建多个实例（ Element ）。 

**主要接口**  

**Widget类的声明：**  

```dart
@immutable 
abstract class Widget extends DiagnosticableTree { 
  const Widget ({ this . key }); 
  final Key key ; 

  @protected 
  Element createElement (); 

  @override 
  String toStringShort () { 
    return key == null ? '$runtimeType' : '$runtimeType-$key' ; 
  } 

  @override 
  void debugFillProperties ( DiagnosticPropertiesBuilder properties ) { 
    super . debugFillProperties ( properties ); 
    properties . defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle . dense ; 
  } 

  static bool canUpdate ( Widget oldWidget , Widget newWidget ) { 
    return oldWidget . runtimeType == newWidget . runtimeType 
        && oldWidget . key == newWidget . key ; 
  } 
} 
```

* 参数介绍
	* Widget类继承自DiagnosticableTree，DiagnosticableTree即“诊断树”，主要作用是提供调试信息
	* Widget 类继承自 DiagnosticableTree ， DiagnosticableTree 即 “ 诊断树 ” ，主要作用是提供调试信息。 
	* Key : 这个 key 属性类似于 React/Vue 中的 key ，主要的作用是决定是否在下一次 build 时复用旧的 widget ，决定的条件在 canUpdate() 方法中。 
	* createElement() ：正如前文所述 “ 一个 Widget 可以对应多个 Element ” ； Flutter Framework 在构建 UI 树时，会先调用此方法生成对应节点的 Element 对象。此方法是 Flutter Framework 隐式调用的，在我们开发过程中基本不会调用到。 
	* debugFillProperties(...)   复写父类的方法，主要是设置诊断树的一些特性。 
	* canUpdate(...) 是一个静态方法，它主要用于在 Widget 树重新 build 时复用旧的 widget ，其实具体来说，应该是：是否用新的 Widget 对象去更新旧 UI 树上所对应的 Element 对象的配置；通过其源码我们可以看到，只要 newWidget 与 oldWidget 的 runtimeType 和 key 同时相等时就会用 newWidget 去更新 Element 对象的配置，否则就会创建新的 Element 。 
	* 有关 Key 和 Widget 复用的细节将会在本书后面高级部分深入讨论，读者现在只需知道，为 Widget 显式添加 key 的话可能（但不一定）会使 UI 在重新构建时变的高效，读者目前可以先忽略此参数。本书后面的示例中，我们只在构建列表项 UI 时会显式指定 Key 。 
	* 另外 Widget 类本身是一个抽象类，其中最核心的就是定义了 createElement() 接口，在 Flutter 开发中，我们一般都不用直接继承 Widget 类来实现 Widget ，相反，我们通常会通过继承 StatelessWidget 和 StatefulWidget 来间接继承 Widget 类来实现，而 StatelessWidget 和 StatefulWidget 都是直接继承自 Widget 类，而这两个类也正是 Flutter 中非常重要的两个抽象类，它们引入了两种 Widget 模型，接下来我们将重点介绍一下这两个类。 

---

**Stateless Widget**  
* StatelessWidget相对比较简单，它继承自Widget，重写了createElement()方法
* StatelessWidget用于不需要维护状态的场景，它通常在build方法中通过嵌套其它Widget来构建UI，在构建过程中会递归的构建其嵌套的Widget
* 举个例子，你可能会用一个   UIImageView   来展示你的 logo  image   。如果这个 logo 在运行时不会改变，那么你就可以在 Flutter 中使用   StatelessWidget   。 
* 如果一个 widget 在一次 build 之后永远不变，那它就是无状态的。但是，即便一个 widget 是有状态的，包含它的父亲 widget 也可以是无状态的，只要父 widget 本身不响应这些变化 
* 在之前的章节中，我们已经简单介绍过 StatelessWidget ， StatelessWidget 相对比较简单，它继承自 Widget ，重写了 createElement() 方法： 

```dart
@override 
StatelessElement createElement () => new StatelessElement ( this ); 
StatelessElement   间接继承自 Element 类，与 StatelessWidget 相对应（作为其配置数据）。 
StatelessWidget 用于不需要维护状态的场景，它通常在 build 方法中通过嵌套其它 Widget 来构建 UI ，在构建过程中会递归的构建其嵌套的 Widget 。我们看一个简单的例子： 
class Echo extends StatelessWidget { 
  const Echo ({ 
    Key key ,   
    @required this . text , 
    this . backgroundColor : Colors . grey , 
  }): super ( key : key ); 

  final String text ; 
  final Color backgroundColor ; 

  @override 
  Widget build ( BuildContext context ) { 
    return Center ( 
      child : Container ( 
        color : backgroundColor , 
        child : Text ( text ), 
      ), 
    ); 
  } 
} 
```

* 上面的代码，实现了一个回显字符串的 Echo  widget 。 
* 按照惯例， widget 的构造函数应使用命名参数，命名参数中的必要参数要添加 @required 标注，这样有利于静态代码分析器进行检查，另外，在继承 widget 时，第一个参数通常应该是 Key ，如果接受子 widget 的 child 参数，那么通常应该将它放在参数列表的最后。同样是按照惯例， widget 的属性应被声明为 final ，防止被意外改变。 
* 然后我们可以通过如下方式使用它： 

```dart
Widget build ( BuildContext context ) { 
  return Echo ( text : "hello world" ); 
} 
```

* StatelessWidget相对比较简单，它继承自Widget，重写了createElement()方法

```dart
@override 
StatelessElement createElement () => new StatelessElement ( this ); 
StatelessElement   间接继承自 Element 类，与 StatelessWidget 相对应（作为其配置数据）。
```

---

**  Stateful Widget**  
* StatefulWidget也是继承自widget类，并重写了createElement()方法，不同的是返回的Element 对象并不相同
* 另外StatefulWidget类中添加了一个新的接口createState()
	* 如果你希望在发起 HTTP 请求时，依托接收到的数据动态的改变 UI ，请使用   StatefulWidget 。当 HTTP 请求结束后，通知 Flutter 框架 widget 的   State   更新了，好让系统来更新 UI 。 
	* 如果一个 widget 在它的   build   方法之外改变（例如，在运行时由于用户的操作而改变），它就是有状态的。 

---

* StatefulWidget的类定义

```dart
abstract class StatefulWidget extends Widget { 
  const StatefulWidget ({ Key key }) : super ( key : key ); 

  @override 
  StatefulElement createElement () => new StatefulElement ( this ); 

  @protected 
  State createState (); 
} 
```

---

**参数介绍**
	* StatefulElement   间接继承自 Element 类，与 StatefulWidget 相对应（作为其配置数据）。 StatefulElement 中可能会多次调用 createState() 来创建状态 (State) 对象。 
	* createState()   用于创建和 Stateful widget 相关的状态，它在 Stateful widget 的生命周期中可能会被多次调用。例如，当一个 Stateful widget 同时插入到 widget 树的多个位置时， Flutter framework 就会调用该方法为每一个位置生成一个独立的 State 实例，其实，本质上就是一个 StatefulElement 对应一个 State 实例。 在本书中经常会出现 “ 树 “ 的概念，在不同的场景可能指不同的意思，在说 “widget 树 ” 时它可以指 widget 结构树，但由于 widget 与 Element 有对应关系（一可能对多），在有些场景（ Flutter 的 SDK 文档中）也代指 “UI 树 ” 的意思。而在 stateful widget 中， State 对象也和 StatefulElement 具有对应关系（一对一），所以在 Flutter 的 SDK 文档中，可以经常看到 “ 从树中移除 State 对象 ” 或 “ 插入 State 对象到树中 ” 这样的描述。其实，无论哪种描述，其意思都是在描述 “ 一棵构成用户界面的节点元素的树 ” ，读者不必纠结于这些概念，还是那句话 “ 得其神，忘其形 ” ，因此，本书中出现的各种 “ 树 ” ，如果没有特别说明，读者都可抽象的认为它是 “ 一棵构成用户界面的节点元素的树 ” 。 

---

**State**
* 一个 StatefulWidget 类会对应一个 State 类， State 表示与其对应的 StatefulWidget 要维护的状态， State 中的保存的状态信息可以： 
	1.	在 widget build 时可以被同步读取。 
	2.	在 widget 生命周期中可以被改变，当 State 被改变时，可以手动调用其 setState() 方法通知 Flutter framework 状态发生改变， Flutter framework 在收到消息后，会重新调用其 build 方法重新构建 widget 树，从而达到更新 UI 的目的。 
* State 中有两个常用属性： 
	* widget ，它表示与该 State 实例关联的 widget 实例，由 Flutter framework 动态设置。注意，这种关联并非永久的，因为在应用声明周期中， UI 树上的某一个节点的 widget 实例在重新构建时可能会变化，但 State 实例只会在第一次插入到树中时被创建，当在重新构建时，如果 widget 被修改了， Flutter framework 会动态设置 State.widget 为新的 widget 实例。 
	* context ，它是 BuildContext 类的一个实例，表示构建 widget 的上下文，它是操作 widget 在树中位置的一个句柄，它包含了一些查找、遍历当前 Widget 树的一些方法。每一个 widget 都有一个自己的 context 对象。 对于 BuildContext 读者现在可以先作了解，随着本书后面内容的展开，也会用到 Context 的一些方法，读者可以通过具体的场景对其有个直观的认识。关于 BuildContext 更多的内容，我们也将在后面高级部分再深入介绍。
* State生命周期
* 理解 State 的生命周期对 flutter 开发非常重要，为了加深读者印象，本节我们通过一个实例来演示一下 State 的生命周期。在接下来的示例中，我们实现一个计数器 widget ，点击它可以使计数器加 1 ，由于要保存计数器的数值状态，所以我们应继承 StatefulWidget ，代码如下： 

```dart
class CounterWidget extends StatefulWidget { 
  const CounterWidget ({ 
    Key key , 
    this . initValue : 0 
  }); 

  final int initValue ; 

  @override 
  _CounterWidgetState createState () => new _CounterWidgetState (); 
} 
CounterWidget 接收一个 initValue 整形参数，它表示计数器的初始值。下面我们看一下 State 的代码： 
class _CounterWidgetState extends State < CounterWidget > {   
  int _counter ; 

  @override 
  void initState () { 
    super . initState (); 
    // 初始化状态   
    _counter = widget . initValue ; 
    print ( "initState" ); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    print ( "build" ); 
    return Center ( 
      child : FlatButton ( 
        child : Text ( '$_counter' ), 
        // 点击后计数器自增   
        onPressed :() => setState (() => ++ _counter ) , 
      ), 
    ); 
  } 

  @override 
  void didUpdateWidget ( CounterWidget oldWidget ) { 
    super . didUpdateWidget ( oldWidget ); 
    print ( "didUpdateWidget" ); 
  } 

  @override 
  void deactivate () { 
    super . deactivate (); 
    print ( "deactive" ); 
  } 

  @override 
  void dispose () { 
    super . dispose (); 
    print ( "dispose" ); 
  } 

  @override 
  void reassemble () { 
    super . reassemble (); 
    print ( "reassemble" ); 
  } 

  @override 
  void didChangeDependencies () { 
    super . didChangeDependencies (); 
    print ( "didChangeDependencies" ); 
  }
} 
```

* 接下来，我们创建一个新路由，在新路由中，我们只显示一个 CounterWidget ： 

```dart
Widget build ( BuildContext context ) { 
  return CounterWidget (); 
} 
```

* 我们运行应用并打开该路由页面，在新路由页打开后，屏幕中央就会出现一个数字 0 ，然后控制台日志输出： 

```dart
I/flutter ( 5436): initState 
I/flutter ( 5436): didChangeDependencies 
I/flutter ( 5436): build 
```

* 可以看到，在 StatefulWidget 插入到 Widget 树时首先 initState 方法会被调用。 
* 然后我们点击 ⚡️ 按钮热重载，控制台输出日志如下： 

```dart
I/flutter ( 5436): reassemble 
I/flutter ( 5436): didUpdateWidget 
I/flutter ( 5436): build 
```

* 可以看到此时 initState   和 didChangeDependencies 都没有被调用，而此时 didUpdateWidget 被调用。 
* 接下来，我们在 widget 树中移除 CounterWidget ，将路由 build 方法改为： 

```dart
Widget build ( BuildContext context ) { 
  // 移除计数器   
  //return CounterWidget(); 
  // 随便返回一个 Text() 
  return Text ( "xxx" ); 
} 
```

* 然后热重载，日志如下： 

```dart
I/flutter ( 5436): reassemble 
I/flutter ( 5436): deactive 
I/flutter ( 5436): dispose 
```

* 我们可以看到，在 CounterWidget 从 widget 树中移除时， deactive 和 dispose 会依次被调用。 
下面我们来看看各个回调函数： 
	* initState ：当 Widget 第一次插入到 Widget 树时会被调用，对于每一个 State 对象， Flutter framework 只会调用一次该回调，所以，通常在该回调中做一些一次性的操作，如状态初始化、订阅子树的事件通知等。不能在该回调中调用 BuildContext.inheritFromWidgetOfExactType （该方法用于在 Widget 树上获取离当前 widget 最近的一个父级 InheritFromWidget ，关于 InheritedWidget 我们将在后面章节介绍），原因是在初始化完成后， Widget 树中的 InheritFromWidget 也可能会发生变化，所以正确的做法应该在在 build （） 方法或 didChangeDependencies() 中调用它。 
	* didChangeDependencies() ：当 State 对象的依赖发生变化时会被调用；例如：在之前 build()   中包含了一个 InheritedWidget ，然后在之后的 build()   中 InheritedWidget 发生了变化，那么此时 InheritedWidget 的子 widget 的 didChangeDependencies() 回调都会被调用。典型的场景是当系统语言 Locale 或应用主题改变时， Flutter framework 会通知 widget 调用此回调。 
	* build() ：此回调读者现在应该已经相当熟悉了，它主要是用于构建 Widget 子树的，会在如下场景被调用： 
	1.在调用 initState() 之后。 
	2.在调用 didUpdateWidget() 之后。 
	3.在调用 setState() 之后。 
	4.在调用 didChangeDependencies() 之后。 
	5.在 State 对象从树中一个位置移除后（会调用 deactivate ）又重新插入到树的其它位置之后。 
	* reassemble() ：此回调是专门为了开发调试而提供的，在热重载 (hot reload) 时会被调用，此回调在 Release 模式下永远不会被调用。 
	* didUpdateWidget() ：在 widget 重新构建时， Flutter framework 会调用 Widget.canUpdate 来检测 Widget 树中同一位置的新旧节点，然后决定是否需要更新，如果 Widget.canUpdate 返回 true 则会调用此回调。正如之前所述， Widget.canUpdate 会在新旧 widget 的 key 和 runtimeType 同时相等时会返回 true ，也就是说在在新旧 widget 的 key 和 runtimeType 同时相等时 didUpdateWidget() 就会被调用。 
	* deactivate() ：当 State 对象从树中被移除时，会调用此回调。在一些场景下， Flutter framework 会将 State 对象重新插到树中，如包含此 State 对象的子树在树的一个位置移动到另一个位置时（可以通过 GlobalKey 来实现）。如果移除后没有重新插入到树中则紧接着会调用 dispose() 方法。 
	* dispose() ：当 State 对象从树中被永久移除时调用；通常在此回调中释放资源。 
* todo: 这里缺一张生命周期图 
* 注意：在继承 StatefulWidget 重写其方法时，对于包含 @mustCallSuper 标注的父类方法，都要在子类方法中先调用父类方法。 

**状态管理** 
* 响应式的编程框架中都会有一个永恒的主题 ——“ 状态管理 ” ，无论是在 React/Vue （两者都是支持响应式编程的 web 开发框架）还是 Flutter ，他们讨论的问题和解决的思想都是一致的。所以，如果你对 React/Vue 的状态管理有了解，可以跳过本节。言归正传，我们想一个问题， stateful widget 的状态应该被谁管理？ widget 本身？父 widget ？都会？还是另一个对象？答案是取决于实际情况！以下是管理状态的最常见的方法： 
	* Widget 管理自己的 state 。 
	* 父 widget 管理子 widget 状态。 
	* 混合管理（父 widget 和子 widget 都管理状态）。 
* 如何决定使用哪种管理方法？以下原则可以帮助你决定： 
	* 如果状态是用户数据，如复选框的选中状态、滑块的位置，则该状态最好由父 widget 管理。 
	* 如果状态是有关界面外观效果的，例如颜色、动画，那么状态最好由 widget 本身来管理。 
	* 如果某一个状态是不同 widget 共享的则最好由它们共同的父 widget 管理。 
* 在 widget 内部管理状态封装性会好一些，而在父 widget 中管理会比较灵活。有些时候，如果不确定到底该怎么管理状态，那么推荐的首选是在父 widget 中管理（灵活会显得更重要一些）。 
* 接下来，我们将通过创建三个简单示例 TapboxA 、 TapboxB 和 TapboxC 来说明管理状态的不同方式。 这些例子功能是相似的 —— 创建一个盒子，当点击它时，盒子背景会在绿色与灰色之间切换。状态   _active 确定颜色：绿色为 true   ，灰色为 false 。 


* 下面的例子将使用 GestureDetector 来识别点击事件，关于该 GestureDetector 的详细内容我们将在后面 “ 事件处理 ” 一章中介绍。 

---

* Widget管理自身状态
	* 父widget管理子widget的state
  * 混合管理
* Flutter widget库介绍
		* 基础widget
		* 默认有引入
		* Material widget
		* Cupertino widget
* 总结
* 全局状态管理

---

**Widget管理自身状态**  
* _TapboxAState 类 : 
	* 管理 TapboxA 的状态。 
	* 定义 _active ：确定盒子的当前颜色的布尔值。 
	* 定义 _handleTap() 函数，该函数在点击该盒子时更新 _active ，并调用 setState() 更新 UI 。 
	* 实现 widget 的所有交互式行为。 
	
```dart
// TapboxA 管理自身状态 . 
//------------------------- TapboxA ---------------------------------- 

class TapboxA extends StatefulWidget { 
  TapboxA ({ Key key }) : super ( key : key ); 

  @override 
  _TapboxAState createState () => new _TapboxAState (); 
} 

class _TapboxAState extends State < TapboxA > { 
  bool _active = false ; 

  void _handleTap () { 
    setState (() { 
      _active = ! _active ; 
    }); 
  } 

  Widget build ( BuildContext context ) { 
    return new GestureDetector ( 
      onTap : _handleTap , 
      child : new Container ( 
        child : new Center ( 
          child : new Text ( 
            _active ? 'Active' : 'Inactive' , 
            style : new TextStyle ( fontSize : 32.0 , color : Colors . white ), 
          ), 
        ), 
        width : 200.0 , 
        height : 200.0 , 
        decoration : new BoxDecoration ( 
          color : _active ? Colors . lightGreen [ 700 ] : Colors . grey [ 600 ], 
        ), 
      ), 
    ); 
  } 
} 
```

---

* 父widget管理子widget的state
* 对于父 widget 来说，管理状态并告诉其子 widget 何时更新通常是比较好的方式。 例如， IconButton 是一个图片按钮，但它是一个无状态的 widget ，因为我们认为父 widget 需要知道该按钮是否被点击来采取相应的处理。 
* 在以下示例中， TapboxB 通过回调将其状态导出到其父项。由于 TapboxB 不管理任何状态，因此它的父类为 StatelessWidget 。 
* ParentWidgetState 类 : 
	* 为 TapboxB 管理 _active 状态 . 
	* 实现 _handleTapboxChanged() ，当盒子被点击时调用的方法 . 
	* 当状态改变时，调用 setState() 更新 UI. 
* TapboxB 类 : 
	* 继承 StatelessWidget 类，因为所有状态都由其父 widget 处理。 
	* 当检测到点击时，它会通知父 widget 。 
	

```dart
// ParentWidget 为 TapboxB 管理状态 . 
//------------------------ ParentWidget -------------------------------- 

class ParentWidget extends StatefulWidget { 
  @override 
  _ParentWidgetState createState () => new _ParentWidgetState (); 
} 

class _ParentWidgetState extends State < ParentWidget > { 
  bool _active = false ; 

  void _handleTapboxChanged ( bool newValue ) { 
    setState (() { 
      _active = newValue ; 
    }); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return new Container ( 
      child : new TapboxB ( 
        active : _active , 
        onChanged : _handleTapboxChanged , 
      ), 
    ); 
  } 
} 

//------------------------- TapboxB ---------------------------------- 
class TapboxB extends StatelessWidget { 
  TapboxB ({ Key key , this . active : false , @required this . onChanged }) 
      : super ( key : key ); 

  final bool active ; 
  final ValueChanged < bool > onChanged ; 

  void _handleTap () { 
    onChanged ( ! active ); 
  } 

  Widget build ( BuildContext context ) { 
    return new GestureDetector ( 
      onTap : _handleTap , 
      child : new Container ( 
        child : new Center ( 
          child : new Text ( 
            active ? 'Active' : 'Inactive' , 
            style : new TextStyle ( fontSize : 32.0 , color : Colors . white ), 
          ), 
        ), 
        width : 200.0 , 
        height : 200.0 , 
        decoration : new BoxDecoration ( 
          color : active ? Colors . lightGreen [ 700 ] : Colors . grey [ 600 ], 
        ), 
      ), 
    ); 
  } 
} 
```

---

* 混合管理
* 对于一些 widget 来说，混合管理的方式非常有用。在这种情况下， widget 自身管理一些内部状态，而父 widget 管理一些其他外部状态。 
* 在下面 TapboxC 示例中，按下时，盒子的周围会出现一个深绿色的边框。抬起时，边框消失；点击生效，盒子的颜色改变。 TapboxC 将其 _active 状态导出到其父 widget 中，但在内部管理其 _highlight 状态。这个例子有两个状态对象 _ParentWidgetState 和 _TapboxCState 。 
* _ParentWidgetStateC 对象 : 
	* 管理 _active   状态。 
	* 实现   _handleTapboxChanged()   ，当盒子被点击时调用。 
	* 当点击盒子并且 _active 状态改变时调用 setState() 更新 UI 。 
* _TapboxCState 对象 : 
	* 管理 _highlight  state 。 
	* GestureDetector 监听所有 tap 事件。当用户点下时，它添加高亮（深绿色边框）；当用户释放时，会移除高亮。 
	* 当按下、抬起、或者取消点击时更新 _highlight 状态，调用 setState() 更新 UI 。 
	* 当点击时，将状态的改变传递给父 widget. 

```dart
//---------------------------- ParentWidget ---------------------------- 
class ParentWidgetC extends StatefulWidget { 
  @override 
  _ParentWidgetCState createState () => new _ParentWidgetCState (); 
} 

class _ParentWidgetCState extends State < ParentWidgetC > { 
  bool _active = false ; 

  void _handleTapboxChanged ( bool newValue ) { 
    setState (() { 
      _active = newValue ; 
    }); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return new Container ( 
      child : new TapboxC ( 
        active : _active , 
        onChanged : _handleTapboxChanged , 
      ), 
    ); 
  } 
} 

//----------------------------- TapboxC ------------------------------ 
class TapboxC extends StatefulWidget { 
  TapboxC ({ Key key , this . active : false , @required this . onChanged }) 
      : super ( key : key ); 

  final bool active ; 
  final ValueChanged < bool > onChanged ; 

  _TapboxCState createState () => new _TapboxCState (); 
} 

class _TapboxCState extends State < TapboxC > { 
  bool _highlight = false ; 

  void _handleTapDown ( TapDownDetails details ) { 
    setState (() { 
      _highlight = true ; 
    }); 
  } 

  void _handleTapUp ( TapUpDetails details ) { 
    setState (() { 
      _highlight = false ; 
    }); 
  } 

  void _handleTapCancel () { 
    setState (() { 
      _highlight = false ; 
    }); 
  } 

  void _handleTap () { 
    widget . onChanged ( ! widget . active ); 
  } 

  Widget build ( BuildContext context ) { 
    // 在按下时添加绿色边框，当抬起时，取消高亮   
    return new GestureDetector ( 
      onTapDown : _handleTapDown , // 处理按下事件 
      onTapUp : _handleTapUp , // 处理抬起事件 
      onTap : _handleTap , 
      onTapCancel : _handleTapCancel , 
      child : new Container ( 
        child : new Center ( 
          child : new Text ( widget . active ? 'Active' : 'Inactive' , 
              style : new TextStyle ( fontSize : 32.0 , color : Colors . white )), 
        ), 
        width : 200.0 , 
        height : 200.0 , 
        decoration : new BoxDecoration ( 
          color : widget . active ? Colors . lightGreen [ 700 ] : Colors . grey [ 600 ], 
          border : _highlight 
              ? new Border . all ( 
                  color : Colors . teal [ 700 ], 
                  width : 10.0 , 
                ) 
              : null , 
        ), 
      ), 
    ); 
  } 
} 
```

* 另一种实现可能会将高亮状态导出到父 widget ，同时保持 _active 状态为内部，但如果你要将该 TapBox 给其它人使用，可能没有什么意义。 开发人员只会关心该框是否处于 Active 状态，而不在乎高亮显示是如何管理的，所以应该让 TapBox 内部处理这些细节。 

----

* Flutter widget库介绍
* 基础widget
* 默认有引入
* Material widget
* Cupertino widget

**基础widget**
* 默认有引入
	•	Text ：该 widget 可让您创建一个带格式的文本。 
	•	Row 、  Column ： 这些具有弹性空间的布局类 Widget 可让您在水平（ Row ）和垂直（ Column ）方向上创建灵活的布局。其设计是基于 web 开发中的 Flexbox 布局模型。 
	•	Stack ： 取代线性布局 ( 译者语：和 Android 中的 FrameLayout 相似 ) ，Stack 允许子 widget 堆叠， 你可以使用  Positioned   来定位他们相对于 Stack 的上下左右四条边的位置。 Stacks 是基于 Web 开发中的绝对定位（ absolute positioning ) 布局模型设计的。 
	•	Container ：  Container   可让您创建矩形视觉元素。 container 可以装饰一个BoxDecoration , 如 background 、一个边框、或者一个阴影。  Container   也可以具有边距（ margins ）、填充 (padding) 和应用于其大小的约束 (constraints) 。另外，  Container 可以使用矩阵在三维空间中对其进行变换。 

------------------------
Material widget

Flutter 提供了一套丰富的 Material widget ，可帮助您构建遵循 Material Design 的应用程序。 Material 应用程序以MaterialApp  widget 开始， 该 widget 在应用程序的根部创建了一些有用的 widget ，比如一个 Theme ，它配置了应用的主题。 是否使用MaterialApp 完全是可选的，但是使用它是一个很好的做法。在之前的示例中，我们已经使用过多个 Material widget 了，如： Scaffold 、 AppBar 、 FlatButton 等。要使用 Material widget ，需要先引入它： 
import 'package:flutter/material.dart' ; 

------------------------
Cupertino widget

Flutter 也提供了一套丰富的 Cupertino 风格的 widget ，尽管目前还没有 Material widget 那么丰富，但也在不断的完善中。值得一提的是在 Material widget 库中，有一些 widget 可以根据实际运行平台来切换表现风格，比如 MaterialPageRoute ，在路由切换时，如果是 Android 系统，它将会使用 Android 系统默认的页面切换动画 ( 从底向上 ) ，如果是 iOS 系统时，它会使用 iOS 系统默认的页面切换动画（从右向左）。由于在前面的示例中还没有 Cupertino widget 的示例，我们实现一个简单的 Cupertino 页面： 
// 导入 cupertino widget 库 
import 'package:flutter/cupertino.dart' ; 

class CupertinoTestRoute extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
    return CupertinoPageScaffold ( 
      navigationBar : CupertinoNavigationBar ( 
        middle : Text ( "Cupertino Demo" ), 
      ), 
      child : Center ( 
        child : CupertinoButton ( 
            color : CupertinoColors . activeBlue , 
            child : Text ( "Press" ), 
            onPressed : () {} 
        ), 
      ), 
    ); 
  } 
} 
下面是在 iPhoneX 上页面效果截图： 

------------------------
总结
Flutter 提供了丰富的 widget ，在实际的开发中你可以随意使用它们，不要怕引入过多 widget 库会让你的应用安装包变大，这不是 web 开发， dart 在编译时只会编译你使用了的代码。由于 Material 和 Cupertino 都是在基础 widget 库之上的，所以如果你的应用中引入了这两者之一，则不需要再引入 flutter/widgets.dart 了，因为它们内部已经引入过了。 

------------------------
全局状态管理

当应用中包括一些跨 widget （甚至跨路由）的状态需要同步时，上面介绍的方法很难胜任了。比如，我们有一个设置页，里面可以设置应用语言，但是我们为了让设置实时生效，我们期望在语言状态发生改变时，我们的 APP Widget 能够重新 build 一下，但我们的 APP Widget 和设置页并不在一起。正确的做法是通过一个全局状态管理器来处理这种 “ 相距较远 ” 的 widget 之间的通信。目前主要有两种办法： 
	1.	实现一个全局的事件总线，将语言状态改变对应为一个事件，然后在 APP Widget 所在的父 widget initState 方法中订阅语言改变的事件，当用户在设置页切换语言后，我们触发语言改变事件，然后 APP Widget 那边就会收到通知，然后重新 build 一下即可。 
	2.	使用 redux 这样的全局状态包，读者可以在 pub 上查看其详细信息。 
本书后面事件处理 一章中会实现一个全局事件总线。 

------------------------




### Flutter的工程结构和本地化及依赖和资源

* 我怎么在 Flutter 中引入 image assets？多分辨率怎么办？
* 使用图片的步骤
	* 要把一个叫 my_icon.png 的图片放到 Flutter 工程中，你可能想要把存储它的文件夹叫做 images。把基础图片（1.0x）放置到 images 文件夹中，并把其他变体放置在子文件夹中，并接上合适的比例系数：
	* 接着，在 pubspec.yaml 文件夹中声明这些图片：
	* 可以用 AssetImage 来访问这些图片：
	* 或者在 Image widget 中直接使用：

* iOS 把 images 和 assets 作为不同的东西，而 Flutter 中只有 assets 。被放到 iOS 中   Images.xcasset   文件夹下的资源在 Flutter 中被放到了 assets 文件夹中。 assets 可以是任意类型的文件，而不仅仅是图片。例如，你可以把 json 文件放置到   my-assets   文件夹中。 

```

my-assets/data.json 
在   pubspec.yaml   文件中声明 assets ： 
assets: 
  - my-assets/data.json 
  
```

* 然后在代码中使用  AssetBundle   来访问它： 

```

import 'dart:async' show Future ; 
import 'package:flutter/services.dart' show rootBundle ; 

Future < String > loadAsset () async { 
  return await rootBundle . loadString ( 'my-assets/data.json' ); 
} 

```

* 对于图片， Flutter 像 iOS 一样，遵循了一个简单的基于像素密度的格式。 Image assets 可能是   1.0x   2.0x   3.0x   或是其他的任何倍数。这些所谓的  devicePixelRatio   传达了物理像素到单个逻辑像素的比率。 
* Assets 可以被放置到任何属性文件夹中 ——Flutter 并没有预先定义的文件结构。在   pubspec.yaml   文件中声明 assets （和位置），然后 Flutter 会把他们识别出来。 
* 举个例子，要把一个叫   my_icon.png   的图片放到 Flutter 工程中，你可能想要把存储它的文件夹叫做   images 。把基础图片（ 1.0x ）放置到   images   文件夹中，并把其他变体放置在子文件夹中，并接上合适的比例系数： 

```

images/my_icon.png       // Base: 1.0x image 
images/2.0x/my_icon.png  // 2.0x image 
images/3.0x/my_icon.png  // 3.0x image 

```

* 接着，在   pubspec.yaml   文件夹中声明这些图片： 

```

assets: 
  - images/my_icon.jpeg 

```

* 你可以用   AssetImage   来访问这些图片： 

```

return AssetImage ( "images/a_dot_burr.jpeg" ); 

```

* 或者在   Image  widget 中直接使用： 

```

@override 
Widget build ( BuildContext context ) { 
  return Image . asset ( "images/my_image.png" ); 
} 

```

* 更多细节，参见  Adding Assets and Images in Flutter 。 

---

* 要把一个叫 my_icon.png 的图片放到 Flutter 工程中，你可能想要把存储它的文件夹叫做 images。把基础图片（1.0x）放置到 images 文件夹中，并把其他变体放置在子文件夹中，并接上合适的比例系数：

```

images/my_icon.png       // Base: 1.0x image 
images/2.0x/my_icon.png  // 2.0x image 
images/3.0x/my_icon.png  // 3.0x image 

```

* 接着，在 pubspec.yaml 文件夹中声明这些图片：

```

assets: 
  - images/my_icon.jpeg 

```

* 可以用 AssetImage 来访问这些图片：

```

return AssetImage ( "images/a_dot_burr.jpeg" ); 

```

* 或者在 Image widget 中直接使用：

```

@override 
Widget build ( BuildContext context ) { 
  return Image . asset ( "images/my_image.png" ); 
} 

```

---

* 我在哪里放置字符串？我怎么做本地化？
* flutter_localizations
* Flutter 目前并没有一个用于处理字符串的系统
* 目前，最佳实践是把你的文本拷贝到静态区，并在这里访问。例如：
* 不像 iOS 拥有一个   Localizable.strings   文件， Flutter 目前并没有一个用于处理字符串的系统。目前，最佳实践是把你的文本拷贝到静态区，并在这里访问。例如： 

```

class Strings { 
  static String welcomeMessage = "Welcome To Flutter" ; 
} 

```

* 并且这样访问你的字符串： 

```

Text ( Strings . welcomeMessage ) 

```

* 默认情况下， Flutter 只支持美式英语字符串。如果你要支持其他语言，请引入   flutter_localizations   包。你可能也要引入  intl   包来支持其他的 i10n 机制，比如日期 / 时间格式化。 

```

dependencies: 
  # ... 
  flutter_localizations: 
    sdk: flutter 
  intl: "^0.15.6" 
  
```

* 要使用   flutter_localizations   包，还需要在 app widget 中指定   localizationsDelegates   和   supportedLocales 。 

```

import 'package:flutter_localizations/flutter_localizations.dart' ; 

MaterialApp ( 
  localizationsDelegates : [ 
   // Add app-specific localization delegate[s] here 
   GlobalMaterialLocalizations . delegate , 
   GlobalWidgetsLocalizations . delegate , 
  ], 
  supportedLocales : [ 
    const Locale ( 'en' , 'US' ), // English 
    const Locale ( 'he' , 'IL' ), // Hebrew 
    // ... other locales the app supports 
  ], 
  // ... 
)

```

* 这些代理包括了实际的本地化值，并且   supportedLocales   定义了 App 支持哪些地区。上面的例子使用了一个   MaterialApp   ，所以它既有   GlobalWidgetsLocalizations   用于基础 widgets ，也有   MaterialWidgetsLocalizations   用于 Material wigets 的本地化。如果你使用   WidgetsApp   ，则无需包括后者。注意，这两个代理虽然包括了 “ 默认 ” 值，但如果你想让你的 App 本地化，你仍需要提供一或多个代理作为你的 App 本地化副本。 
* 当初始化时， WidgetsApp   或   MaterialApp   会使用你指定的代理为你创建一个  Localizations  widget 。 Localizations  widget 可以随时从当前上下文中访问设备的地点，或者使用  Window.locale 。 
* 要访问本地化文件，使用   Localizations.of()   方法来访问提供代理的特定本地化类。如需翻译，使用  intl_translation   包来取出翻译副本到  arb   文件中。把它们引入 App 中，并用   intl   来使用它们。 
* 更多 Flutter 中国际化和本地化的细节，请访问  internationalization guide   ，那里有不使用   intl   包的示例代码。 
* 注意，在 Flutter 1.0 beta 2 之前，在 Flutter 中定义的 assets 不能在原生一侧被访问。原生定义的资源在 Flutter 中也不可用，因为它们在独立的文件夹中。 

* 目前，最佳实践是把你的文本拷贝到静态区，并在这里访问。例如：

```

class Strings { 
  static String welcomeMessage = "Welcome To Flutter" ; 
} 

```

* 并且这样访问你的字符串： 

```

Text ( Strings . welcomeMessage ) 

```

* Cocoapods 相当于什么？我该如何添加依赖？
* 在 iOS 中，你把依赖添加到   Podfile   中。 Flutter 使用 Dart 构建系统和 Pub 包管理器来处理依赖。这些工具将本机 Android 和 iOS 包装应用程序的构建委派给相应的构建系统。 
* 如果你的 Flutter 工程中的 iOS 文件夹中拥有 Podfile ，请仅在你为每个平台集成时使用它。总体来说，使用   pubspec.yaml   来在 Flutter 中声明外部依赖。一个可以找到优秀 Flutter 包的地方是  Pub 。 

### Flutter的导航

导航
  我怎么在不同页面之间跳转？
    可以粗略地把一个路由对应到一个 UIViewController
    Navigator 的工作原理和 iOS 中 UINavigationController 非常相似，当你想跳转到新页面或者从新页面返回时，它可以 push() 和 pop() 路由。
    在页面之间跳转，你有几个选择：
      具体指定一个由路由名构成的 Map。（MaterialApp）
        构建一个 Map 的例子：
      直接跳转到一个路由。（WidgetApp）
  我怎么跳转到其他 App？
    可以创建一个原生平台的整合层，或者使用现有的 plugin，例如 url_launcher。

---

** 我怎么在不同页面之间跳转？**

* 可以粗略地把一个路由对应到一个 UIViewController
* Navigator 的工作原理和 iOS 中 UINavigationController 非常相似，当你想跳转到新页面或者从新页面返回时，它可以 push() 和 pop() 路由。
* 在页面之间跳转，你有几个选择：
	* 具体指定一个由路由名构成的 Map。（MaterialApp）
	* 构建一个 Map 的例子：
	* 直接跳转到一个路由。（WidgetApp）

* 在 iOS 中，你可以使用管理了 view controller 栈的   UINavigationController   来在不同的 view controller 之间跳转。 
* Flutter 也有类似的实现，使用了   Navigator   和   Routes 。一个路由是 App 中 “ 屏幕 ” 或 “ 页面 ” 的抽象，而一个 Navigator 是管理多个路由的  widget   。你可以粗略地把一个路由对应到一个   UIViewController 。 Navigator 的工作原理和 iOS 中   UINavigationController   非常相似，当你想跳转到新页面或者从新页面返回时，它可以   push()   和   pop()   路由。 
* 下面是构建一个 Map 的例子： 

```

void main () { 
  runApp ( MaterialApp ( 
    home : MyAppHome (), // becomes the route named '/' 
    routes : < String , WidgetBuilder > { 
      '/a' : ( BuildContext context ) => MyPage ( title : 'page A' ), 
      '/b' : ( BuildContext context ) => MyPage ( title : 'page B' ), 
      '/c' : ( BuildContext context ) => MyPage ( title : 'page C' ), 
    }, 
  )); 
} 

```

* 通过把路由的名字   push   给一个   Navigator   来跳转： 

```

Navigator . of ( context ). pushNamed ( '/b' ); 

```

* Navigator   类不仅用来处理 Flutter 中的路由，还被用来获取你刚 push 到栈中的路由返回的结果。通过   await 等待路由返回的结果来达到这点。 
* 举个例子，要跳转到 “ 位置 ” 路由来让用户选择一个地点，你可能要这么做： 

```

Map coordinates = await Navigator . of ( context ). pushNamed ( '/location' ); 

* 之后，在 location 路由中，一旦用户选择了地点，携带结果一起   pop()   出栈： 

```

Navigator . of ( context ). pop ({ "lat" : 43.821757 , "long" : - 79.226392 }); 

```

## 构建一个 Map 的例子：

```

void main () { 
  runApp ( MaterialApp ( 
    home : MyAppHome (), // becomes the route named '/' 
    routes : < String , WidgetBuilder > { 
      '/a' : ( BuildContext context ) => MyPage ( title : 'page A' ), 
      '/b' : ( BuildContext context ) => MyPage ( title : 'page B' ), 
      '/c' : ( BuildContext context ) => MyPage ( title : 'page C' ), 
    }, 
  )); 
} 

```



### Flutter的布局

** UITableView 和 UICollectionView 相当于 Flutter 中的什么？**

* 可以用 ListView 来达到相似的实现
* 由于 Flutter 中 widget 的不可变特性，你需要向 ListView 传递一个 widget 列表，Flutter 会确保滚动是快速且流畅的。
* listView例子

* 在 iOS 中，你可能用 UITableView 或 UICollectionView 来展示一个列表。在 Flutter 中，你可以用ListView来达到相似的实现。在iOS中，你通过代理方法来确定行数，每一个index path 的单元格，以及单元格的尺寸。 
* 由于 Flutter 中 widget 的不可变特性，你需要向   ListView   传递一个 widget 列表， Flutter 会确保滚动是快速且流畅的。 

```

import 'package:flutter/material.dart' ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView ( children : _getListData ()), 
    ); 
  } 

  _getListData () { 
    List < Widget > widgets = []; 
    for ( int i = 0 ; i < 100 ; i ++ ) { 
      widgets . add ( Padding ( padding : EdgeInsets . all ( 10.0 ), child : Text ( "Row $i" ))); 
    } 
    return widgets ; 
  } 
} 

```

---

** listView例子 **

```

import 'package:flutter/material.dart' ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView ( children : _getListData ()), 
    ); 
  } 

  _getListData () { 
    List < Widget > widgets = []; 
    for ( int i = 0 ; i < 100 ; i ++ ) { 
      widgets . add ( Padding ( padding : EdgeInsets . all ( 10.0 ), child : Text ( "Row $i" ))); 
    } 
    return widgets ; 
  } 
} 

```

---

** 我怎么知道列表的哪个元素被点击了？**

* 在 Flutter 中，使用传递进来的 widget 的 touch handle：
* *iOS 中，你通过   tableView:didSelectRowAtIndexPath:   代理方法来实现。在 Flutter 中，使用传递进来的 widget 的 touch handle ： 

```

import 'package:flutter/material.dart' ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView ( children : _getListData ()), 
    ); 
  } 

  _getListData () { 
    List < Widget > widgets = []; 
    for ( int i = 0 ; i < 100 ; i ++ ) { 
      widgets . add ( GestureDetector ( 
        child : Padding ( 
          padding : EdgeInsets . all ( 10.0 ), 
          child : Text ( "Row $i" ), 
        ), 
        onTap : () { 
          print ( 'row tapped' ); 
        }, 
      )); 
    } 
    return widgets ; 
  } 
} 

```

---

** 我怎么动态地更新 ListView？**

* 使用 ListView.Builder 来构建列表。这个方法在你想要构建动态列表，或是列表拥有大量数据时会非常好用。
* 在 iOS 中，你改变列表的数据，并通过   reloadData()   方法来通知 table 或是 collection view 。 
* 在 Flutter 中，如果你想通过   setState()   方法来更新 widget 列表，你会很快发现你的数据展示并没有变化。这是因为当   setState()   被调用时， Flutter 渲染引擎会去检查 widget 树来查看是否有什么地方被改变了。当它得到你的   ListView   时，它会使用一个   ==   判断，并且发现两个   ListView   是相同的。没有什么东西是变了的，因此更新不是必须的。 
* 一个更新   ListView   的简单方法是，在   setState()   中创建一个新的 list ，并把旧 list 的数据拷贝给新的 list 。虽然这样很简单，但当数据集很大时，并不推荐这样做： 

```

import 'package:flutter/material.dart' ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 
    for ( int i = 0 ; i < 100 ; i ++ ) { 
      widgets . add ( getRow ( i )); 
    } 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView ( children : widgets ), 
    ); 
  } 

  Widget getRow ( int i ) { 
    return GestureDetector ( 
      child : Padding ( 
        padding : EdgeInsets . all ( 10.0 ), 
        child : Text ( "Row $i" ), 
      ), 
      onTap : () { 
        setState (() { 
          widgets = List . from ( widgets ); 
          widgets . add ( getRow ( widgets . length + 1 )); 
          print ( 'row $i' ); 
        }); 
      }, 
    ); 
  } 
} 

```

* 一个推荐的、高效的且有效的做法是，使用   ListView.Builder   来构建列表。这个方法在你想要构建动态列表，或是列表拥有大量数据时会非常好用。 

```

import 'package:flutter/material.dart' ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 
    for ( int i = 0 ; i < 100 ; i ++ ) { 
      widgets . add ( getRow ( i )); 
    } 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView . builder ( 
        itemCount : widgets . length , 
        itemBuilder : ( BuildContext context , int position ) { 
          return getRow ( position ); 
        }, 
      ), 
    ); 
  } 

  Widget getRow ( int i ) { 
    return GestureDetector ( 
      child : Padding ( 
        padding : EdgeInsets . all ( 10.0 ), 
        child : Text ( "Row $i" ), 
      ), 
      onTap : () { 
        setState (() { 
          widgets . add ( getRow ( widgets . length + 1 )); 
          print ( 'row $i' ); 
        }); 
      }, 
    ); 
  } 
} 

```

* 与创建一个 “ListView” 不同，创建一个ListView.builder接受两个主要参数：列表的初始长度，和一个ItemBuilder方法。 
* ItemBuilder方法和cellForItemAt代理方法非常类似，它接受一个位置，并且返回在这个位置上你希望渲染的 cell 。 
* 最后，也是最重要的，注意onTap()函数里并没有重新创建一个list，而是.add了一个 widget 。 

---

* 使用 ListView.Builder 来构建列表。这个方法在你想要构建动态列表，或是列表拥有大量数据时会非常好用。

```

import 'package:flutter/material.dart' ; 

void main () { 
  runApp ( SampleApp ()); 
} 

class SampleApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  List widgets = []; 

  @override 
  void initState () { 
    super . initState (); 
    for ( int i = 0 ; i < 100 ; i ++ ) { 
      widgets . add ( getRow ( i )); 
    } 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : ListView . builder ( 
        itemCount : widgets . length , 
        itemBuilder : ( BuildContext context , int position ) { 
          return getRow ( position ); 
        }, 
      ), 
    ); 
  } 

  Widget getRow ( int i ) { 
    return GestureDetector ( 
      child : Padding ( 
        padding : EdgeInsets . all ( 10.0 ), 
        child : Text ( "Row $i" ), 
      ), 
      onTap : () { 
        setState (() { 
          widgets . add ( getRow ( widgets . length + 1 )); 
          print ( 'row $i' ); 
        }); 
      }, 
    ); 
  } 
} 

```

---

** ScrollView 相当于 Flutter 里的什么？**

* 在 iOS 中，你给 view 包裹上   ScrollView   来允许用户在需要时滚动你的内容。 
* 在 Flutter 中，最简单的方法是使用   ListView  widget 。它表现得既和 iOS 中的   ScrollView   一致，也能和   TableView   一致，因为你可以给它的 widget 做垂直排布：
* 更多关于在 Flutter 总如何排布 widget 的文档，请参阅  layout tutorial 。

```

@override 
Widget build ( BuildContext context ) { 
  return ListView ( 
    children : < Widget > [ 
      Text ( 'Row One' ), 
      Text ( 'Row Two' ), 
      Text ( 'Row Three' ), 
      Text ( 'Row Four' ), 
    ], 
  ); 
} 

```

### Flutter的表单输入

表单输入
  Flutter 中表单怎么工作？我怎么拿到用户的输入？
    通过 TextEditingController 来获得用户输入：
  Text field 中的 placeholder 相当于什么？
  我怎么展示验证错误信息？

------------------------
*  Flutter 中表单怎么工作？我怎么拿到用户的输入？
* 通过 TextEditingController 来获得用户输入：
* 我们已经提到 Flutter 使用不可变的 widget ，并且状态是分离的，你可能会好奇在这种情境下怎么处理用户的输入。在 iOS 中，你经常在需要提交数据时查询组件当前的状态或动作，但这在 Flutter 中是怎么工作的呢？ 
* 在表单处理的实践中，就像在 Flutter 中任何其他的地方一样，要通过特定的 widgets 。如果你有一个   TextField 或是   TextFormField ，你可以通过  TextEditingController   来获得用户输入： 

```

class _MyFormState extends State < MyForm > { 
  // Create a text controller and use it to retrieve the current value. 
  // of the TextField! 
  final myController = TextEditingController (); 

  @override 
  void dispose () { 
    // Clean up the controller when disposing of the Widget. 
    myController . dispose (); 
    super . dispose (); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( 'Retrieve Text Input' ), 
      ), 
      body : Padding ( 
        padding : const EdgeInsets . all ( 16.0 ), 
        child : TextField ( 
          controller : myController , 
        ), 
      ), 
      floatingActionButton : FloatingActionButton ( 
        // When the user presses the button, show an alert dialog with the 
        // text the user has typed into our text field. 
        onPressed : () { 
          return showDialog ( 
            context : context , 
            builder : ( context ) { 
              return AlertDialog ( 
                // Retrieve the text the user has typed in using our 
                // TextEditingController 
                content : Text ( myController . text ), 
              ); 
            }, 
          ); 
        }, 
        tooltip : 'Show me the value!' , 
        child : Icon ( Icons . text_fields ), 
      ), 
    ); 
  } 
} 

```

* 你可以在这里获得更多信息，或是完整的代码列表：  Retrieve the value of a text field ，来自  Flutter Cookbook   。 

---

* 通过 TextEditingController 来获得用户输入：

```

class _MyFormState extends State < MyForm > { 
  // Create a text controller and use it to retrieve the current value. 
  // of the TextField! 
  final myController = TextEditingController (); 

  @override 
  void dispose () { 
    // Clean up the controller when disposing of the Widget. 
    myController . dispose (); 
    super . dispose (); 
  } 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( 'Retrieve Text Input' ), 
      ), 
      body : Padding ( 
        padding : const EdgeInsets . all ( 16.0 ), 
        child : TextField ( 
          controller : myController , 
        ), 
      ), 
      floatingActionButton : FloatingActionButton ( 
        // When the user presses the button, show an alert dialog with the 
        // text the user has typed into our text field. 
        onPressed : () { 
          return showDialog ( 
            context : context , 
            builder : ( context ) { 
              return AlertDialog ( 
                // Retrieve the text the user has typed in using our 
                // TextEditingController 
                content : Text ( myController . text ), 
              ); 
            }, 
          ); 
        }, 
        tooltip : 'Show me the value!' , 
        child : Icon ( Icons . text_fields ), 
      ), 
    ); 
  } 
} 

```

---

*  Text field 中的 placeholder 相当于什么？

* 在 Flutter 中，你可以轻易地通过向 Text widget 的装饰构造器参数重传递   InputDecoration   来展示 “ 小提示 ” ，或是占位符文字： 

```

body : Center ( 
  child : TextField ( 
    decoration : InputDecoration ( hintText : "This is a hint" ), 
  ), 
) 

```

---

*  我怎么展示验证错误信息？

* 就像展示 “ 小提示 ” 一样，向 Text widget 的装饰器构造器参数中传递一个   InputDecoration 。 
* 然而，你并不想在一开始就显示错误信息。相反，当用户输入了验证信息，更新状态，并传入一个新的   InputDecoration   对象： 

```

class SampleApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build ( BuildContext context ) { 
    return MaterialApp ( 
      title : 'Sample App' , 
      theme : ThemeData ( 
        primarySwatch : Colors . blue , 
      ), 
      home : SampleAppPage (), 
    ); 
  } 
} 

class SampleAppPage extends StatefulWidget { 
  SampleAppPage ({ Key key }) : super ( key : key ); 

  @override 
  _SampleAppPageState createState () => _SampleAppPageState (); 
} 

class _SampleAppPageState extends State < SampleAppPage > { 
  String _errorText ; 

  @override 
  Widget build ( BuildContext context ) { 
    return Scaffold ( 
      appBar : AppBar ( 
        title : Text ( "Sample App" ), 
      ), 
      body : Center ( 
        child : TextField ( 
          onSubmitted : ( String text ) { 
            setState (() { 
              if ( ! isEmail ( text )) { 
                _errorText = 'Error: This is not an email' ; 
              } else { 
                _errorText = null ; 
              } 
            }); 
          }, 
          decoration : InputDecoration ( hintText : "This is a hint" , errorText : _getErrorText ()), 
        ), 
      ), 
    ); 
  } 

  _getErrorText () { 
    return _errorText ; 
  } 

  bool isEmail ( String em ) { 
    String emailRegexp = 
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$' ; 

    RegExp regExp = RegExp ( p ); 
    
    return regExp . hasMatch ( em ); 
  } 
} 

```

### flutter包管理2019214

2.3包管理2019.2.14
  Android使用Gradle来管理依赖
  iOS用Cocoapods或Carthage来管理依赖
  如果我们的Flutter应用本身依赖某个包，我们需要将所依赖的包添加到dependencies 下
  简单的示例：
  pub仓库
    示例
      english_words第三方
  pubspec.yaml
  其它依赖方式
    可以依赖本地包和git仓库。
      依赖本地包
      依赖Git
  总结
  
  
----------------------------
一个完整的应用程序往往会依赖很多第三方包，正如在原生开发中， Android 使用 Gradle 来管理依赖， iOS 用 Cocoapods 或 Carthage 来管理依赖，而 Flutter 也有自己的依赖管理工具，本节我们主要介绍一下 flutter 如何使用配置文件 pubspec.yaml （位于项目根目录）来管理第三方依赖包。 
YAML 是一种直观、可读性高并且容易被人类阅读的文件格式，它和 xml 或 Json 相比，它语法简单并非常容易解析，所以 YAML 常用于配置文件， Flutter 也是用 yaml 文件作为其配置文件， Flutter 项目默认的配置文件是 pubspec.yaml ，我们看一个简单的示例： 
name : flutter_in_action 
description : First Flutter application. 

version : 1.0.0+1 

dependencies : 
  flutter : 
    sdk : flutter 
  cupertino_icons : ^0.1.2 

dev_dependencies : 
  flutter_test : 
    sdk : flutter 

flutter : 
  uses-material-design : true 
下面，我们逐一解释一下各个字段的意义： 
	•	name ：应用或包名称。 
	•	description: 应用或包的描述、简介。 
	•	version ：应用或包的版本号。 
	•	dependencies ：应用或包依赖的其它包或插件。 
	•	dev_dependencies ：开发环境依赖的工具包（而不是 flutter 应用本身依赖的包）。 
	•	flutter ： flutter 相关的配置选项。 
如果我们的 Flutter 应用本身依赖某个包，我们需要将所依赖的包添加到 dependencies   下，接下来我们通过一个例子来演示一下如何依赖、下载并使用第三方包。 
https://book.flutterchina.club/chapter2/flutter_assets_mgr.html


----------------------------
简单的示例：

----------------------------
name : flutter_in_action 
description : First Flutter application. 

version : 1.0.0+1 

dependencies : 
  flutter : 
    sdk : flutter 
  cupertino_icons : ^0.1.2 

dev_dependencies : 
  flutter_test : 
    sdk : flutter 

flutter : 
  uses-material-design : true 

下面，我们逐一解释一下各个字段的意义： 
	•	name ：应用或包名称。 
	•	description: 应用或包的描述、简介。 
	•	version ：应用或包的版本号。 
	•	dependencies ：应用或包依赖的其它包或插件。 
	•	dev_dependencies ：开发环境依赖的工具包（而不是 flutter 应用本身依赖的包）。 
	•	flutter ： flutter 相关的配置选项。 
如果我们的 Flutter 应用本身依赖某个包，我们需要将所依赖的包添加到 dependencies   下，接下来我们通过一个例子来演示一下如何依赖、下载并使用第三方包。 


----------------------------
pub仓库
  示例
    english_words第三方
      1.添加
      2.下载包
        你也可以在控制台，定位到当前工程目录，然后手动运行flutter packages get 命令来下载依赖包
      3.使用包
        1.引入english_words包。
        2.使用english_words包来生成随机字符串。
        3.热重载运行

----------------------------

Pub （https://pub.dartlang.org/   ）是 Google 官方的 Dart Packages 仓库，类似于 node 中的 npm 仓库， android 中的 jcenter ，我们可以在上面查找我们需要的包和插件，也可以向 pub 发布我们的包和插件。我们将在后面的章节中介绍如何向 pub 发布我们的包和插件。 


----------------------------
english_words第三方
  1.添加
  2.下载包
    你也可以在控制台，定位到当前工程目录，然后手动运行flutter packages get 命令来下载依赖包
  3.使用包
    1.引入english_words包。
    2.使用english_words包来生成随机字符串。
    3.热重载运行

----------------------------
1.添加

将 english_words （ 3.1.3 版本）添加到依赖项列表，如下： 
dependencies : 
  flutter : 
    sdk : flutter 

  cupertino_icons : ^0.1.0 
  # 新添加的依赖 
  english_words : ^3.1.3 

----------------------------
2.下载包
  你也可以在控制台，定位到当前工程目录，然后手动运行flutter packages get 命令来下载依赖包


----------------------------
在 Android Studio 的编辑器视图中查看 pubspec.yaml 时，单击右上角的  Packages get   。 

这会将依赖包安装到您的项目。您可以在控制台中看到以下内容： 
   flutter packages get 
   Running "flutter packages get" in flutter_in_action .. . 
   Process finished with exit code 0 
http://ww1.sinaimg.cn/large/006Akqprgy1g05x9obflhj30dp0a8ab5.jpg
https://ws1.sinaimg.cn/large/006tKfTcly1g05xc7n46vj31gs0o8tf1.jpg
----------------------------

3.使用包
  1.引入english_words包。
  2.使用english_words包来生成随机字符串。
  3.热重载运行
----------------------------
1.引入english_words包。

import 'package:english_words/english_words.dart' ; 
在输入时， Android Studio 会自动提供有关库导入的建议选项。导入后该行代码将会显示为灰色，表示导入的库尚未使用。 



----------------------------
2.使用english_words包来生成随机字符串。

class RandomWordsWidget extends StatelessWidget { 
  @override 
  Widget build ( BuildContext context ) { 
   // 生成随机字符串 
    final wordPair = new WordPair . random (); 
    return Padding ( 
      padding : const EdgeInsets . all ( 8.0 ), 
      child : new Text ( wordPair . toString ()), 
    ); 
  } 
} 
我们将 RandomWordsWidget   添加到 " 计数器 " 示例的首页 MyHomePage   的 Column 的子 widget 中。 


----------------------------

3.热重载运行
如果应用程序正在运行，请使用热重载按钮 () 更新正在运行的应用程序。每次单击热重载或保存项目时，都会在正在运行的应用程序中随机选择不同的单词对。 这是因为单词对是在   build   方法内部生成的。每次热更新时， build 方法都会被执行 

----------------------------
可以依赖本地包和git仓库。
  依赖本地包
  依赖Git

----------------------------
依赖本地包

如果我们正在本地开发一个包，包名为 pkg1 ，我们可以通过下面方式依赖： 
dependencies : 
    pkg1 : 
        path : ../../code/pkg1 
路径可以是相对的，也可以是绝对的。 

----------------------------

依赖Git

依赖 Git ：你也可以依赖存储在 Git 仓库中的包。如果软件包位于仓库的根目录中，请使用以下语法 
dependencies : 
  pkg1 : 
    git : 
      url : git : //github.com/xxx/pkg1.git 
上面假定包位于 Git 存储库的根目录中。如果不是这种情况，可以使用 path 参数指定相对位置，例如： 
dependencies : 
  package1 : 
    git : 
      url : git : //github.com/flutter/packages.git 
      path : packages/package1 


----------------------------

总结

本节介绍了引用、下载、使用一个包的整体流程，并在后面介绍了多种不同的引入方式，这些是 Flutter 开发中常用的，但 Dart 的 dependencies 还有一些其它依赖方式，完整的内容读者可以自行查看：https://www.dartlang.org/tools/pub/dependencies   。 


----------------------------

```