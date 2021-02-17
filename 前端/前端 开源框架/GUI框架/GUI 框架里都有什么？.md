GUI 框架里都有什么？

GUI 框架的基本单元是控件，你熟悉的按钮、图片、文本框等等就是控件。

控件主要负责界面元素数据的存储和更新，这些原始数据都存储在控件的属性上，直接更新控件的属性就能够完成界面元素更新操作，控件的属性设置成不同的值会让界面元素呈现不同的外观。

控件之间的关系是由渲染树（Render Tree）这种抽象的树结构来记录的。渲染树关注的是界面的布局，控件在界面中的位置和大小都是由渲染树来确定。

基于渲染树，GUI 框架还会创建一个渲染层树（RenderLayer Tree），渲染层树由渲染层对象组成，根据 GUI 框架的优化条件来确定创建哪些渲染层对象，每次新创建一个渲染层对象就会去设置它的父对象和兄弟对象。渲染层对象创建完毕，接下来就需要将各渲染层对象里的控件按照渲染树布局生成 Bitmap，最后 GPU 就可以渲染 Bitmap 来让你看到界面了。

控件、渲染树、渲染层树之间的关系，如下图所示：
https://raw.githubusercontent.com/codeRiding/github_pic_0001/master/Xnip2020-04-03_09-57-03.jpg


图 2 控件、渲染树、渲染层树之间的关系
WebKit 和 Flutter 都是开源项目，我们可以通过它们的代码看到 GUI 框架具体是怎么实现控件、渲染树、渲染层树和生成 Bitmap 的。

WebKit 在 GUI 框架层面的效率并不低，单就渲染来说，它的性能一点也不弱于 Cocoa Touch 和 Flutter 框架。

使用 WebKit 的网页显示慢，主要是由于 CSS（Cascading Style Sheet） 和 JavaScript 资源加载方式导致的。
同时，解析时 HTML、CSS、JavaScript 需要兼容老版本，JavaScript 类型推断失败会重来，列表缺少重用机制等原因，导致 WebKit 框架的整体性能没有其他框架好。
开始的时候，Flutter 也是基于 Chrome 浏览器引擎的。后来，谷歌公司考虑到 Flutter 的性能，所以去掉了 HTML、CSS、JavaScript 的支持，而改用自家的 Dart 语言以甩掉历史包袱。关于这方面的细节，你可以查看Flutter 创始人 Eric 的采访视频来了解 。
https://zhuanlan.zhihu.com/p/52666477
这些年来，虽然 GUI 框架百家争鸣，但其渲染技术却一直很稳定。接下来，我就和你详细说说 GUI 框架中的渲染过程。