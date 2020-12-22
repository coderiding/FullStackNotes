//
//  ViewController.m
//  LewBarChartDemo
//
//  Created by pljhonglu on 16/3/4.
//  Copyright © 2016年 pljhonglu. All rights reserved.
//

#import "ViewController.h"
#import "LewBarChart.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)


@interface ViewController ()
@property (nonatomic)LewBarChart *barChart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupBarChart];
}


- (void)setupBarChart{
    _barChart = [[LewBarChart alloc]initWithFrame:CGRectMake(0, 145, SCREEN_WIDTH, 200)];
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    double mult = 5 * 1000.f;
    
    for (int i = 0; i < 2; i++){
        double val = (double) (arc4random_uniform(mult) + 3.0);
        [yVals1 addObject:@(val)];
        
    }
    
    LewBarChartDataSet *set1 = [[LewBarChartDataSet alloc] initWithYValues:yVals1 label:@"报名人数"];
    [set1 setBarColor:[UIColor colorWithRed:77.0 / 255.0 green:186.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LewBarChartData *data = [[LewBarChartData alloc] initWithDataSets:dataSets];
    data.xLabels = @[@"项目名称1",@"项目名称2"];
    data.itemSpace = 1;
    _barChart.data = data;
    _barChart.displayAnimated = YES;
    
    _barChart.chartMargin = UIEdgeInsetsMake(20, 15, 45, 15);
    //    _barChart.showXAxis = NO;
    _barChart.showYAxis = true;
    _barChart.showNumber = YES;
    _barChart.legendView.alignment = LegendAlignmentHorizontal;
    
    [self.view addSubview:_barChart];
    [_barChart show];
    
    CGPoint legendCenter = CGPointMake(SCREEN_WIDTH-_barChart.legendView.bounds.size.width/2, -18);
    _barChart.legendView.center = legendCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
