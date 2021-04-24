---
title: iOS的阴影绘制及性能优化
tags:
  - 动画
  - 阴影
categories: 技术改变世界
abbrlink: 44524
date: 2017-07-28 09:15:18
---

今天来讲讲`iOS`开发过程中的阴影绘制及其潜在的绘图性能问题。虽然在开发过程中，我们使用阴影功能的机会不是很多，但是如果用了，有可能引起如卡顿等性能问题，所以，还是有必要来探究一下阴影的绘制过程，及如何提高阴影的绘制性能。

## 阴影绘制

阴影可以通过设置`layer`层的`shadowXXX`属性，就可以很方便的为`UIView`添加阴影效果，但是不同的设置方式可能产生性能方面的问题，下面介绍一下不同方式对性能的影响。

### 方式一

通过设置下面的4个属性，就可以添加阴影，这种方式可能产生性能问题，因为绘制阴影而不指定阴影路径，在绘制阴影过程中，就会产生大量的离屏渲染（`Offscreen-Rendered`），非常消耗性能，进而造成动画卡顿的问题。

**离屏渲染**

造成离屏渲染的原因很多，比如：遮罩、阴影、抗锯齿等等，而阴影造成离屏渲染的原因是：`iOS`会先绘制目标的阴影，然后绘制目标的本身，在没有指定阴影的绘制路径时，`iOS`视图在每次绘制前都会递归的精确计算每个子层阴影的路径，这会非常消耗性能，也是导致卡顿的根源。

所以，如果绘制的阴影不是很多的情况下，该方法不会消耗大量性能，绘制就会比较简单，代码量也少。

```objectivec
    // 设置阴影颜色
    self.imageView1.layer.shadowColor = [UIColor orangeColor].CGColor;
    // 设置阴影的偏移量，默认是（0， -3）
    self.imageView1.layer.shadowOffset = CGSizeMake(4, 4);
    // 设置阴影不透明度，默认是0
    self.imageView1.layer.shadowOpacity = 0.8;
    // 设置阴影的半径，默认是3
    self.imageView1.layer.shadowRadius = 4;
```

![Xnip2020-10-31_14-36-54](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_14-36-54.jpg)



### 方式二

为了减少因为没有设置`shadowPath`造成绘制阴影时大量重复绘制的问题，我们可以指定阴影的绘制路径，这样在绘制阴影时，就可以在多个`layer`层共享同一个路径的阴影，以此来提高性能，下面是苹果官方文档是解释：

<!-- more -->

```python
/* When non-null this path defines the outline used to construct the
 * layer's shadow instead of using the layer's composited alpha
 * channel. The path is rendered using the non-zero winding rule.
 * Specifying the path explicitly using this property will usually
 * improve rendering performance, as will sharing the same path
 * reference across multiple layers. Upon assignment the path is copied.
 * Defaults to null. Animatable. */

@property(nullable) CGPathRef shadowPath;
```

`shadowPath`的注释大意就是说如果不指定路径，就会使用`layer`层的`alpha`通道的混合，而如果指定阴影路径，就会在多个`layer`层之间共享同一路径，以此来提高性能。

有关什么是`layer`层的混合，可以这样理解：`iOS`在渲染每一帧时，都会计算每一个像素的颜色，如果上层`layer`不透明，就只取上层`layer`的颜色；而如果上层`layer`存在透明度时（alpha通道），则需要混合每一层的颜色来计算最终的颜色。如果`layer`越多，计算量就越大，也就比较耗性能。所以，在开发中，要尽量减少视图的透明层。

具体代码示例，具体是功能就是绘制一个边框阴影：



```objectivec
    _imageView.layer.shadowColor = [UIColor yellowColor].CGColor;//shadowColor阴影颜色
    _imageView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _imageView.layer.shadowOpacity = 1;//阴影透明度，默认0
    _imageView.layer.shadowRadius = 3;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = _imageView.bounds.size.width;
    float height = _imageView.bounds.size.height;
    float x = _imageView.bounds.origin.x;
    float y = _imageView.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = _imageView.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];  
    //设置阴影路径  
    _imageView.layer.shadowPath = path.CGPath;
```

![Xnip2020-10-31_14-37-22](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_14-37-22.jpg)

------

综上，以后开发过程中，如果用到阴影效果，在视图图层不是很多，阴影视图计算量少的情况下，可以直接设置阴影，但是如果图层较多，阴影的计算量较大，则要考虑使用`path`的方式。（本文主要参考互联网，版本归原作者所有）

**参考资料**

[绘制阴影引发的 iOS 绘图性能问题总结](https://link.jianshu.com?t=http://blog.csdn.net/zixiweimi/article/details/39889623)

[离屏渲染学习笔记](https://link.jianshu.com?t=http://foggry.com/blog/2015/05/06/chi-ping-xuan-ran-xue-xi-bi-ji/?utm_source=tuicool&utm_medium=referral)