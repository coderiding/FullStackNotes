GUI框架

*在 iOS 开发时，默认使用的都是系统自带的 Cocoa Touch 框架，所以如果你还想进一步提高界面响应速度，赶超其他使用 Cocoa Touch 框架的 App 用户体验时，就要考虑使用其他的 GUI 框架来优化 App 界面的响应速度了。

* 现在流行的 GUI 框架除了 Cocoa Touch 外，还有 WebKit、Flutter、Texture（原名 AsyncDisplayKit）、Blink、Android GUI 等。其中，WebKit、Flutter、Texture 可以用于 iOS 开发。接下来，我就和你说说这三款 GUI 框架。

* 3种GUI框架比较图
https://raw.githubusercontent.com/codeRiding/github_pic_0001/master/Xnip2020-04-03_09-47-43.jpg

通过这个对比，我们可以发现，Texture 框架和 Cocoa Touch 框架，在使用的编程语言、渲染这两个方面，是完全一样的。其实，Texture 框架，正是建立在 Cocoa Touch 框架之上的。

我们再从这些框架使用的布局来看一下，Texture 和其他 GUI 框架一样都是使用的应用更加广泛的 FlexBox 布局。使用 FlexBox 布局的好处是，可以让 iOS 开发者用到前端先进的 W3C 标准响应式布局。目前， FlexBox 已经是布局的趋势，连 iOS 新推出的 UIStackView 布局方式，也是按照 FlexBox 布局思路来设计的。

另外，Texture 是这些框架中唯一使用异步节点计算的框架。使用异步节点计算，可以提高主线程的响应速度。所以，Texture 在节点计算上的效率要比其他框架高。

基于以上三个方面的原因，如果要从 Cocoa Touch 框架前移到其他的 GUI 框架，从学习成本、收益等角度考虑的话，转到 Texture 会是个不错的选择。

因此，我会和你重点分析一下 Texture 框架。因为现在的 GUI 技术已经非常成熟了，各种 GUI 框架的底层也大同小异，所以接下来我会先和你介绍 GUI 框架中的通用性内容，然后再与你讲述 Texture 的独特之处。