https://www.jianshu.com/p/9a2de4c806ca

https://app.yinxiang.com/shard/s35/nl/9757212/0023eff1-b04b-4e20-9dec-f4014b63313b

```Row({
Key key,
MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,//将子Widget放置在什么位置
MainAxisAlignment.start，从左边开始布局
MainAxisAlignment.end，从右边开始布局
MainAxisAlignment.center，从中间开始布局
MainAxisAlignment.spaceBetween，相邻两个widget之间的距离相等
MainAxisAlignment.spaceAround，子widget平均分配空间，最左最又的组件离边的边距，为两个widget边距的一半，具体请自行设置查看效果
MainAxisAlignment.spaceEvenly，子widget平均分配空间，包括最左最右的widget离边的空间
MainAxisSize mainAxisSize = MainAxisSize.max,//设置Row在主轴上应该占据多少空间
CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,//子元素应该如何沿着横轴放置，默认中间对齐
CrossAxisAlignment.satrt//设置子元素上边对齐
CrossAxisAlignment.end//设置子元素下边对齐
CrossAxisAlignment.stretch//每个子元素的上下对齐Row的上下边，相当于是拉伸操作
CrossAxisAlignment.baseline,//相当于CrossAxisAlignment.start,但是需要配合textBaseline，不然会报错
TextDirection textDirection,//设置子widget的左右显示方位，只有在crossAxisAlignment为start、end的时候起作用；
VerticalDirection verticalDirection = VerticalDirection.down,//设置垂直方向上的方向，通常用于Column中,在Row中使用的话，会影响子widget是上边距对齐，还是下边距对齐，跟 CrossAxisAlignment.end， CrossAxisAlignment.start相互影响，选择使用
TextBaseline textBaseline,//配合CrossAxisAlignment.baseline一起使用
List<Widget> children = const <Widget>[],//存放一组子widget
}
```
