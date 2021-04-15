用来设置如何处理元素中的 空白的。

white-space: normal; 不保留空格，适配容器换行，遇到br换行。
white-space: nowrap; 文本不会换行，文本会在在同一行上继续，直到遇到 <br> 标签为止。
white-space: pre; 保持源码中的空格，有几个空格算几个空格显示，同时换行只认源码中的换行和<br/>标签。
white-space: pre-wrap; 保留空格，并且除了碰到源码中的换行和<br/>会换行外，还会自适应容器的边界进行换行。
white-space: pre-line; 合并空格，换行和white-space:pre-wrap一样，遇到源码中的换行和<br/>会换行，碰到容器的边界也会换行。
white-space: break-spaces; 与 pre-wrap的行为相同

white-space: inherit; 规定应该从父元素继承 white-space 属性的值。
white-space: initial;
white-space: unset;

### 效果

---
pre效果（pre在没有碰到源码换行和<br/>的时候是不换行了，不会去自适应容器换行，看图中，white space位置没有换行）
![cQ9mRd](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/cQ9mRd.png)

---
pre-wrap效果（与pre的区别，就在于会自适应容器换行）
![vRzThO](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/vRzThO.png)

---
pre-line(与pre-wrap的区别就是，会合并文本中的空格)
![dpRICD](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/dpRICD.png)

参考

https://developer.mozilla.org/zh-CN/docs/Web/CSS/white-space

https://www.w3school.com.cn/cssref/pr_text_white-space.asp

https://blog.csdn.net/qq_33706382/article/details/78328188  https://app.yinxiang.com/shard/s35/nl/9757212/d7832f52-eea5-4803-b43b-9677bcf4d3c0

![gtiVeZ](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/gtiVeZ.png)