# LewBarChart
iOS 柱状图，支持多个 Y  轴坐标

## 效果图

![效果图](https://github.com/pljhonglu/LewBarChart/blob/master/images/default.png)

## 使用方法

```
_barChart = [[LewBarChart alloc]initWithFrame:CGRectMake(0, 145, SCREEN_WIDTH, 200)];

// 生成数据
NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
double mult = 5 * 1000.f;
for (int i = 0; i < 5; i++){
   double val = (double) (arc4random_uniform(mult) + 3.0);
   [yVals1 addObject:@(val)];
   
   val = (double) (arc4random_uniform(mult) + 3.0);
   [yVals2 addObject:@(val)];
}
    
LewBarChartDataSet *set1 = [[LewBarChartDataSet alloc] initWithYValues:yVals1 label:@"报名人数"];
[set1 setBarColor:[UIColor colorWithRed:77.0 / 255.0 green:186.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]];
LewBarChartDataSet *set2 = [[LewBarChartDataSet alloc] initWithYValues:yVals2 label:@"实到人数"];
[set2 setBarColor:[UIColor colorWithRed:245.0 / 255.0 green:94.0 / 255.0 blue:78.0 / 255.0 alpha:1.0f]];
    
NSMutableArray *dataSets = [[NSMutableArray alloc] init];
[dataSets addObject:set1];
[dataSets addObject:set2];
    
LewBarChartData *data = [[LewBarChartData alloc] initWithDataSets:dataSets];
data.xLabels = @[@"项目名称1",@"项目名称2",@"项目名称3",@"项目名称4",@"项目名称5"];
data.itemSpace = 6;

// 设置柱状图
_barChart.data = data;
_barChart.displayAnimated = YES;
_barChart.chartMargin = UIEdgeInsetsMake(20, 15, 45, 15);
_barChart.showYAxis = NO;
_barChart.showNumber = YES;
_barChart.legendView.alignment = LegendAlignmentHorizontal;
    
[self.view addSubview:_barChart];
[_barChart show];
    
// 设置图例位置
CGPoint legendCenter = CGPointMake(SCREEN_WIDTH-_barChart.legendView.bounds.size.width/2, -18);
_barChart.legendView.center = legendCenter;
```

## License | 许可

This code is distributed under the terms of the MIT license.  
代码使用 MIT license 许可发布.


