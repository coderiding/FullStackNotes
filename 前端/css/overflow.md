[](https://developer.mozilla.org/zh-CN/docs/Web/CSS/overflow)

overflow 定义当一个元素的内容太大而无法适应 块级格式化上下文 时候该做什么。

如果指定了两个关键字，第一个关键字应用于overflow-x，第二个关键字应用于overflow-y。否则，overflow-x和overflow-y都设置为相同的值。

为使 overflow 有效果，块级容器必须有一个指定的高度（height或者max-height）或者将white-space设置为nowrap。

---
visible效果
![xyWHru](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/xyWHru.png)

hidden效果
![VdseZq](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/VdseZq.png)

scroll效果
![h6YvN9](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/h6YvN9.png)

auto效果
![wM1fxt](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/wM1fxt.png)

auto和scoll区别

scroll; /* 始终显示滚动条 */ 
auto; /* 必要时显示滚动条 */ 


参考

https://developer.mozilla.org/zh-CN/docs/Web/CSS/overflow