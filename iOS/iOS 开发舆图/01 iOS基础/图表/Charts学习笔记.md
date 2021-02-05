https://github.com/danielgindi/Charts

### 影片教学

* [Swift中的图表-使用iOS图表设置基本折线图（Alex Nagy）](https://www.youtube.com/watch?v=mWhwe_tLNE8&list=PL_csAAO9PQ8bjzg-wxEff1Fr0Y5W1hrum&index=5)里面讲了一个简单的曲线图案例，
* [安卓文档说明](https://weeklycoding.com/mpandroidchart/)
* [Cocoadocs说明](http://cocoadocs.org/docsets/Charts/)
* 步骤如下：
  * 第一步：先创建LinerChartView
  * 第二步：然后自定义一组数据，
  * 第三步：针对LinerChartView的实例对象，设置x轴、y轴，右边x轴的样式，文字大小，粗细，颜色等；
  * 第四步：接着定一个一个dataset，就是针对数据的一个设置，传入事先定义好的数据，还有一个图表的名字，对这个dataset可以设置图表的样式，比如有没有填充，填充颜色，填充透明度，曲线颜色，曲线过度效果，曲线的粗细。
  * 第五步：将第四步做好的dataset赋值给LinerChartView的data属性上

### 参数
* LineChartModeCubicBezier 会产生回流
* LineChartModeHorizontalBezier 不会产生回流
```
set.cubicIntensity = 0;//阻止回流参数
[set setCircleRadius:3];//圆点大小
[set setCircleColor:UIColor.redColor];// 圆点颜色
set.lineWidth = 2.0;
[set setColor:[UIColor redColor]];//折线颜色
set.highlightEnabled = NO;//不显示十字线
set.drawValuesEnabled = NO;//不显示数值NO
set.drawCirclesEnabled = YES;//画点
set.drawFilledEnabled = YES;//是否开启绘制阶梯样式的折线图NO
set.drawCirclesEnabled = NO;//是否绘制拐点NO
```

### 各种图

* PieChart 对应饼状图
* CandleStickChart 对应炒股的图表
* BubbleChart 气泡图
* RadarChart 雷达图
* LineChart 折线图
* BarChat柱状图也称为条形图
* ScatterChart正方形，三角形，圆形图表，小点

### 自定义图表

* 可以检查图例的位置属性，如果不满意，则必须立即编写自己的图例。https://github.com/danielgindi/Charts/issues/1128

### 说明


* 组成数据源的格式类是ChartDataEntry
* 常见问题参考 https://stackoverflow.com/questions/tagged/ios-charts

  * 搜索饼图https://stackoverflow.com/search?q=%5Bios-charts%5D+pie
