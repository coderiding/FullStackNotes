## 渲染原理

- 我们看到的App界面，都是由CPU和GPU共同计算处理的。
- CPU内部流水线结构拥有并行计算能力，一般用于显示内容的计算。而GPU的并行计算能力更强，能够通过计算将图形结果显示在屏幕像素中。内存中的图形数据，经过转换显示到屏幕上的这个过程，就是渲染。而负责执行这个过程的，就是GPU。
- 渲染的过程中，GPU需要处理屏幕上的每一个像素点，并保证这些像素点的更新是流畅的，这就对GPU的并行计算能力要求非常高。
- 早期，图形渲染是由VGA(Video Graphics Array，视频图形阵列）来完成的，随着3D加速的需要，带来了比如三角形生成、光栅化、纹理贴图等技术。处理这一系列技术的处理器，就被统称为GPU。
- GPU的主要工作是将3D坐标转化成2D坐标，然后再把2D坐标转成实际像素，具体实现可以分为顶点着色器（确定形状的点）、形状装配（确定形状的线）、几何着色器（确定三角形个数）、光栅化（确定屏幕像素点）、片段着色器（对像素点着色）、测试与混合（检查深度和透明度进行混合）六个阶段。
- 为了能够更方便地控制GPU的运算，GPU的可编程能力也不断加强，开始支持C和C++语言。通过OpenGL标准定义的库，可以更容易地操作GPU。
- 在渲染过程中，CPU专门用来处理渲染内容的计算，比如视图创建、布局、图片解码等，内容计算完成后，再传输给GPU进行渲染。
- 在这个过程中，CPU和GPU的相互结合，能够充分利用手机硬件来提升用户使用App的体验。当然，在这个过程中，如果CPU的计算时间超过了屏幕刷新频率要求的时间，界面操作就会变得不流畅

---

## 原生渲染

- 原生界面更新渲染的流程，可以分为以下四步。
- 第一步，更新视图树，同步更新图层树。
- 第二步，CPU 计算要显示的内容，包括视图创建（设置Layer的属性）、布局计算、视图绘制（创建Layer 的Backing Image)、图像解码转换。当runloop在 BeforeWaiting和Exit时，会通知注册的监听，然后对图层打包，打完包后，将打包数据发送给一个独立负责渲染的进程 Render Server。
- 第三步，数据到达Render Server 后会被反序列化，得到图层树，按照图层树中图层顺序、RGBA值、图层frame过滤图层中被遮挡的部分，过滤后将图层树转成渲染树，渲染树的信息会转给OpenGLES/Metal。前面CPU所处理的这些事情统称为Commit Transaction。

## 为什么会感觉WebView和类React Native 比原生渲染得慢呢?

### 从第一次内容加载来看

- 即使是本地加载，大前端也要比原生多出脚本代码解析的工作。
- WebView 需要额外解析HTML+CSS+JavaScript代码，而类React Native 方案则需要解析JSON+JavaScript。HTML+CSS的复杂度要高于JSON，所以解析起来会比JSON慢。也就是说，首次内容加载时，WebView 会比类React Native慢。

### 从语言本身的解释执行性能来看

- 大前端加载后的界面更新会通过JavaScript解释执行，而JavaScript解释执行性能要比原生差，特别是解释执行复杂逻辑或大量计算时。所以，
- 大前端的运算速度，要比原生慢不少。
- 除了首次加载解析要耗时，以及JavaScript 语言本身解释慢导致的性能问题外，WebView的渲染进程是单独的，每帧的更新都要通过IPC调用GPU进程。频繁的IPC进程通信也会有性能损耗。
- WebView 的单独渲染进程还无法访问GPU的context，这样两个进程就没有办法共享纹理资源。纹理资源无法直接使用GPU的Context光栅化，那就只能通过IPC传给GPU进程，这也就导致GPU无法发挥自身的性能优势。由于WebView的光栅化无法及时同步到GPU，滑动时容易出现白屏，就很难避免了。
- 说完了大前端的渲染,你会发现,相对于原生渲染,无论是 Webview还是类 React Native 都会因为脚本语言本身的性能问题而在存在性能差距。那么,对于 Flutter这种没有使用脚 本语言,并且渲染引擎也是全新的框架,其渲染方式有什么不同,性能又怎样呢?

## Flutter 渲染

- Flutter界面是由Widget组成的，所有Widget 组成Widget Tree，界面更新时会更新Widget Tree,然后再更新Element Tree，最后更新 RenderObject Tree。
- 接下来的渲染流程，Flutter渲染在Framework层会有Build、Wiget Tree、Element Tree、RenderObject Tree、Layout、Paint、Composited Layer等几个阶段。将Layer进行组合，生成纹理，使用OpenGL的接口向GPU提交渲染内容进行光栅化与合成，是在Flutter的C++层，使用的是Skia库。包括提交到GPU进程后，合成计算，显示屏幕的过程和iOS原生基本是类似的，因此性能也差不多。
- Flutter的主要优势，在于它能够同时运行于Android和iOS这两个平台。但是，苹果公司在WWDC 2019上推出SwiftUI和Preview后，Flutter 在界面编写和Hot Reload 上的优势会逐渐降低。

## 参考文章

- [iOS 保持界面流畅的技巧](https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)