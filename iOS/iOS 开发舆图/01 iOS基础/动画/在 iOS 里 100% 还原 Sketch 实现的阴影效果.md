---
title: 在 iOS 里 100% 还原 Sketch 实现的阴影效果
tags:
  - 动画
  - 阴影
  - 贝塞尔
categories: 技术改变世界
abbrlink: 27202
date: 2016-04-26 09:15:18
---

* 还原不了设计师视觉稿的开发者不是一个合格的页面仔。Sketch 是 APP 设计的神器，大部分设计师都选择它作为 APP 界面的设计工具。在 Sketch 里设置一个阴影，效果图和参数如下：

![Xnip2020-10-31_14-12-04](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_14-12-04.jpg)

（Sketch 里的效果）

![Xnip2020-10-31_14-12-36](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_14-12-36.jpg)

（Sketch 里的阴影参数）



<!-- more -->

### 开发实现
* 在 iOS 里实现阴影的方式是使用 UIView 的 layer 属性。layer 里与阴影有关的设置是以下几个属性：

```
shadowPath
shadowColor
shadowOpacity
shadowOffset
shadowRadius
```

* 与 Sketch 里阴影参数的对应关系是：
```
shadowPath ~> 阴影的范围
shadowColor ~> 阴影的颜色
shadowOpacity ~> 阴影的透明度
shadowOffset ~> X 和 Y
shadowRadius ~> 阴影的模糊
```

![Xnip2020-10-31_14-13-26](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_14-13-26.jpg)

（layer 属性和 Sketch 阴影的对应关系）

* 根据上图的对应关系，在代码里实现就是（shadowView 的大小是 100x100）：

```
let layer = shadowView.layer
// spread 对应 Sketch 里阴影的 “扩展”，值是 10
let spread: CGFloat = 10
var rect = CGRect(x: 0, y: 0, width: 100, height: 100);
rect = rect.insetBy(dx: -spread, dy: -spread)

layer.shadowPath = UIBezierPath(rect: rect).cgPath
// 颜色是黑色（ #000000 ）
layer.shadowColor = UIColor.black.cgColor
// alpha 50
layer.shadowOpacity = 0.5
// X: 0  Y: 10
layer.shadowOffset = CGSize(width: 0, height: 10)
// 对应 Sketch 里阴影的 “模糊” 的设置，值是 20 / 2 = 10
layer.shadowRadius = 10
```

以上代码运行的效果如下：

![Xnip2020-10-31_14-14-08](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-10-31_14-14-08.jpg)

（实现效果）

* 100% 还原了 Sketch 的设计，完美了。值得一提的是：layer 阴影和圆角是可以共存的，而且阴影路径也需要考虑圆角的值。为了使用方便，为 CALayer 添加一个设置阴影的扩展：

```

extension CALayer {
    func skt_setShadow(color: UIColor? = .black,
                       alpha: CGFloat = 0.5,
                       x: CGFloat = 0, y: CGFloat = 2,
                       blur: CGFloat = 4,
                       spread: CGFloat = 0) {
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur * 0.5
        shadowColor = color?.cgColor
        shadowOpacity = Float(alpha)

        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        shadowPath = path.cgPath
    }
}
```

* 复制代码使用很简单，传入的值和 Sketch 里的阴影参数一样就行：

```
layer.skt_setShadow(color: .black, alpha: 0.5,
                    x: 0, y: 10, 
                    blur: 20, 
                    spread: 10)

```