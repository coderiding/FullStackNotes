GUI框架：Texture

Texture 框架的基本单元，是基于 UIView 抽象的节点 ASDisplayNode。和 UIView 不同的是 ，ASDisplayNode 是线程安全的，可以在后台线程上并行实例化和配置整个层级结构。Texture 框架的开发语言，使用的是苹果公司自家的 Objective-C 和 Swift。

-------------------------------
Texture 里 Node 的异步绘制

Texture 最大的优势就是开发了线程安全的 ASDisplayNode，而且还能够很好的和 UIView 共生。这样的话，我们就可以在原有使用 UIView 开发的程序基础之上使用 Texture，而不用完全重构所有界面。

随着 CPU 多核技术的发展，界面渲染计算都在主线程完成，对于多核 CPU 来说确实是有些浪费。ASDisplayNode 是 UIView 和 CALayer 的抽象，能实现不在主线程执行视图的布局绘制和层级计算，充分发挥多核 CPU 的优势。

首先，我们来看看 Texture 最核心的线程安全节点 ASDisplayNode 是做什么的？

在 Cocoa Touch 框架里，当 CALayer 内容更新时会去找 CALayer 的 delegate，也就是 displayLayer: 方法。UIView 会实现 displayLayer: 这个 delegate 方法。UIView 里实现 drawRect: 这个 delegate 方法能够自定义 CALayer。

在 Texture 中，ASDisplayNode 替代了这个 delegate，解耦了 UIView 和 CALayer，并将 UIView 包装成 ASDisplayView，将 CALayer 包装成 ASDisplayLayer 供外部使用。

然后，我们再来看看ASDisplayNode 是如何进行异步绘制的？

ASDisplayLayer 是整个绘制的起点，绘制事件先在 displayBlock 设置好，然后 ASDisplayNode 调用 displayBlock 来进行异步绘制。整个过程分为三步。

第一步，得到 displayBlock。这个 Block 里有需要绘制的内容，对应的代码如下：

asyncdisplaykit_async_transaction_operation_block_t displayBlock = [self _displayBlockWithAsynchronous:asynchronously isCancelledBlock:isCancelledBlock rasterizing:NO];
其中，displayBlock 就是需要绘制的内容。

第二步，定义一个回调 completionBlock ，绘制完成后执行。代码如下：

asyncdisplaykit_async_transaction_operation_completion_block_t completionBlock = ^(id<NSObject> value, BOOL canceled){
  ASDisplayNodeCAssertMainThread();
  if (!canceled && !isCancelledBlock()) {
    // displayBlock 执行的是绘图操作，返回的类型是 UIImage
    UIImage *image = (UIImage *)value;
    BOOL stretchable = (NO == UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsZero));
    if (stretchable) {
      ASDisplayNodeSetResizableContents(layer, image);
    } else {
      layer.contentsScale = self.contentsScale;
      // 设置为 CALayer 的寄宿图
      layer.contents = (id)image.CGImage;
    }
    [self didDisplayAsyncLayer:self.asyncLayer];
    
    if (rasterizesSubtree) {
      ASDisplayNodePerformBlockOnEverySubnode(self, NO, ^(ASDisplayNode * _Nonnull node) {
        [node didDisplayAsyncLayer:node.asyncLayer];
      });
    }
  }
};
上面代码中，completionBlock 里就是绘制完成后需要去执行的事情，内容是完成 CALayer 寄宿图的设置。 value 是 displayBlock 返回的值，类型是 UIImage。displayBlock 用的是线程安全的 Core Graphics，所以你可以安心地把 displayBlock 放到后台线程去异步执行。

第三步，如果设置为异步展示，就先向上找到属性 asyncdisplaykit_parentTransactionContainer 为 YES 的 CALayer，获取 containerLayer 的 ASAsyncTransaction，然后将 displayBlock 添加到 ASAsyncTransaction 的调度队列里，根据 drawingPriority 优先级执行 displayBlock。具体代码如下：

if (asynchronously) {
  // 向上找到属性 asyncdisplaykit_parentTransactionContainer 为 YES 的 CALayer
  CALayer *containerLayer = layer.asyncdisplaykit_parentTransactionContainer ? : layer;
  
  // 获取 containerLayer 的 ASAsyncTransaction
  _ASAsyncTransaction *transaction = containerLayer.asyncdisplaykit_asyncTransaction;
  
  // 将 displayBlock 添加到 ASAsyncTransaction 的调度队列里
  [transaction addOperationWithBlock:displayBlock priority:self.drawingPriority queue:[_ASDisplayLayer displayQueue] completion:completionBlock];
} else {
  // 设置为不是异步就直接调用 displayBlock 进行绘制
  UIImage *contents = (UIImage *)displayBlock();
  completionBlock(contents, NO);
}
可以看到，displayBlock 被添加到 ASAsyncTransaction 里进行调度。这里，ASAsyncTransactionQueue 是 Texture 的调度队列。

通过上面这三步，Texture 就完成了 ASDisplayNode 的异步绘制。

小结
在今天这篇文章中，我和你介绍了目前可以用于 iOS 开发的主流 GUI 框架有哪些，这些框架里都有什么，以及它们的渲染流程是怎样的。

通过今天的介绍，你会发现在选择 GUI 框架时，渲染方面的区别并不大，而且渲染技术相对比较成熟。所以，我们需要在框架的易用性，以及与现有工程的兼容上做更多的考虑。

如果你想提高 App 的使用体验，让界面操作更流畅的话，我推荐你使用 Texture。Texture 易用性和兼容性都很好，同时 Texture 的学习成本与收益比也是最高的。而且，Texture 代码本身的质量很高，有很多值得学习的地方。