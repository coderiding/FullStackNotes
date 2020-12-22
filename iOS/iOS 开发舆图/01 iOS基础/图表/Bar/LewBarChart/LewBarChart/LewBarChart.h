//
//  LewBarChart.h
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/1.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LewBarChartData.h"
#import "LewLegendView.h"

@interface LewBarChart : UIView
// 便于修改其位置
@property (nonatomic, strong, readonly)LewLegendView *legendView;

// 中间图标区域(不包含坐标轴)的边距
@property (nonatomic, assign)UIEdgeInsets chartMargin;

@property (nonatomic, strong)LewBarChartData *data;

// 柱形顶部是否显示数值
@property (nonatomic, assign)BOOL showNumber;

// 是否显示Y轴
@property (nonatomic, assign)BOOL showYAxis;
@property (nonatomic, assign)BOOL showXAxis;

@property (nonatomic, assign)BOOL displayAnimated;

- (void)show;//显示柱状图

@end
