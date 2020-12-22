//
//  LewBarChart.m
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/1.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "LewBarChart.h"
#import "LewBar.h"
#import "LewLegendView.h"
#import "LewCommon.h"

#define XLabelMarginTop 5
#define YLabelMarginRight 5
#define XAxisMarginLeft 10
#define XAxisMarginRight 10
#define YAxisMarginTop 10
#define LegendTextSize 10

@interface LewBarChart ()
@property (nonatomic, strong)NSMutableArray<LewBar *> *bars;
@property (nonatomic, strong, readwrite)LewLegendView *legendView;

@end
@implementation LewBarChart

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _chartMargin = UIEdgeInsetsMake(30, 30, 30, 30);
        _showXAxis = YES;
        _showYAxis = YES;
        
        self.backgroundColor = [UIColor clearColor];
        _bars = [NSMutableArray array];
    }
    return self;
}

-(void)show{
    
    CGFloat groupCount = [_data.dataSets[0].yValues count];
    CGFloat itemCount = [_data.dataSets count];
    
    CGFloat groupWidth = (self.bounds.size.width - _chartMargin.left - _chartMargin.right + _data.groupSpace) / groupCount - _data.groupSpace;
    CGFloat barHeight = self.bounds.size.height - _chartMargin.top - _chartMargin.bottom;
    
    CGFloat barWidth = (groupWidth+_data.itemSpace)/itemCount - _data.itemSpace;
    barWidth = 24;
    
    for (int i = 0; i<_data.dataSets.count; i++) {
        LewBarChartDataSet *dataset = _data.dataSets[i];
        
        for (int j = 0; j<dataset.yValues.count; j++) {
            
            CGFloat bar_x = _chartMargin.left + j*(groupWidth+_data.groupSpace) + i*(barWidth+_data.itemSpace);
            LewBar *bar = [[LewBar alloc]initWithFrame:CGRectMake(bar_x, _chartMargin.top, barWidth, barHeight)];
            
            NSNumber *yValue = dataset.yValues[j];
            bar.barProgress = isnan(yValue.floatValue/_data.yMaxNum)? 0:(yValue.floatValue/_data.yMaxNum);
            bar.barColor = dataset.barColor;
            bar.backgroundColor = dataset.BarbackGroudColor;
            if (_showNumber) {
                bar.barText = yValue.stringValue;
            }
            bar.displayAnimated = _displayAnimated;
            [_bars addObject:bar];
            [self addSubview:bar];
        }
    }
    
    if (_data.isGrouped) {
        [self setupLegendView];
    }
}

- (void)setupLegendView{
    NSMutableArray *array = [NSMutableArray array];
    [_data.dataSets enumerateObjectsUsingBlock:^(LewBarChartDataSet * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LewLegendViewData *data = [LewLegendViewData new];
        data.color = obj.barColor;
        data.label = obj.label;
        [array addObject:data];
    }];
    
    self.legendView.data = array;
    if (CGPointEqualToPoint(_legendView.center, CGPointZero)) {
        _legendView.center = CGPointMake(self.bounds.size.width-_legendView.bounds.size.width/2, _legendView.bounds.size.height/2);
    }
}

- (LewLegendView *)legendView{
    if (!_legendView) {
        _legendView = [[LewLegendView alloc]init];
        [self addSubview:_legendView];
    }
    return _legendView;
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘 X 轴数据
    if (_data.xLabels) {
        NSUInteger xLabelCount = _data.xLabels.count;
        CGFloat xLabelWidth = (self.bounds.size.width - _chartMargin.left - _chartMargin.right + _data.groupSpace) / xLabelCount - _data.groupSpace;
        CGFloat xLabelHeight = _chartMargin.bottom-XLabelMarginTop;
        UIFont  *font = [UIFont systemFontOfSize:_data.xLabelFontSize];//设置
        [_data.xLabels enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = CGRectMake(_chartMargin.left+idx*(xLabelWidth+_data.groupSpace), self.bounds.size.height-_chartMargin.bottom+XLabelMarginTop, xLabelWidth, xLabelHeight);
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            style.alignment = NSTextAlignmentCenter;
            [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:_data.xLabelTextColor} context:nil];

        }];
    }
    // 绘 Y 轴数据
    if (_data. yLabels) {
        NSUInteger yLabelCount = _data.yLabels.count;
        CGFloat yLabelWidth = _chartMargin.left-XAxisMarginLeft;
        CGFloat yLabelHeight = _data.yLabelFontSize;
        
        CGFloat yLabelSpace = (self.bounds.size.height-_chartMargin.top-_chartMargin.bottom+YAxisMarginTop-(yLabelCount*yLabelHeight))/(yLabelCount-1);
        
        UIFont  *font = [UIFont systemFontOfSize:_data.yLabelFontSize];//设置
        [_data.yLabels enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = CGRectMake(0, _chartMargin.top-YAxisMarginTop+idx*(yLabelHeight+yLabelSpace), yLabelWidth-YLabelMarginRight, yLabelHeight);

            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentRight;
            [obj drawWithRect:rect options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName: _data.yLabelTextColor} context:nil];
        }];
    }
    // 绘 x/y 坐标轴
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor); //设置线的颜色为灰色
    
    if (_showYAxis) {
        CGContextMoveToPoint(context, _chartMargin.left-XAxisMarginLeft-0.5, _chartMargin.top-YAxisMarginTop); //设置线的起始点
        CGContextAddLineToPoint(context, _chartMargin.left-XAxisMarginLeft, self.bounds.size.height-_chartMargin.bottom+0.5); //设置线中间的一个点
        CGContextStrokePath(context);//直接把所有的点连起来
    }
    if (_showXAxis) {
        CGContextMoveToPoint(context, _chartMargin.left-XAxisMarginLeft, self.bounds.size.height-_chartMargin.bottom+0.5); //设置线的起始点
        CGContextAddLineToPoint(context, self.bounds.size.width-_chartMargin.right+XAxisMarginRight, self.bounds.size.height-_chartMargin.bottom+0.5); //设置线中间的一个点
        CGContextStrokePath(context);//直接把所有的点连起来
    }
    
}

@end

