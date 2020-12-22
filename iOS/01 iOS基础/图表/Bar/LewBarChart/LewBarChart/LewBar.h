//
//  LewBar.h
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/1.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LewBar : UIView{
    CAShapeLayer *_backgroundLayer; //背景层
    UIBezierPath *_backgroundPath; //背景赛贝尔路径
    CAShapeLayer *_barLayer; //柱状层
    UIBezierPath *_barPath; //柱状赛贝尔路径
    CATextLayer *_textLayer; //数值文字显示层
}
@property (nonatomic, strong)UIColor *backgroundColor;//背景色
@property (nonatomic, strong)UIColor *barColor;//柱的颜色

@property (nonatomic, strong)UIColor *labelTextColor;
@property (nonatomic, strong)UIFont *labelFont;

@property (nonatomic, assign)float barProgress;//柱子长度 0-1之间
@property (nonatomic, assign) CGFloat barRadius;

@property (nonatomic, strong)NSString *barText;//数值
@property (nonatomic, strong)NSString *barTitle;//标题

@property (nonatomic, assign)BOOL displayAnimated;

@end
