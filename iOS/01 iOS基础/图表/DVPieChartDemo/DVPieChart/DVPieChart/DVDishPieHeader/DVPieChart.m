//
//  DVPieChart.m
//  DVPieChart
//
//  Created by SmithDavid on 2018/2/26.
//  Copyright © 2018年 SmithDavid. All rights reserved.
//

#import "DVPieChart.h"
#import "DVFoodPieModel.h"
#import "DVPieCenterView.h"

#define COLOR_ARRAY @[\
[UIColor colorWithRed:251/255.0 green:166.9/255.0 blue:96.5/255.0 alpha:1],\
[UIColor colorWithRed:151.9/255.0 green:188/255.0 blue:95.8/255.0 alpha:1],\
[UIColor colorWithRed:245/255.0 green:94/255.0 blue:102/255.0 alpha:1],\
[UIColor colorWithRed:29/255.0 green:140/255.0 blue:140/255.0 alpha:1],\
[UIColor colorWithRed:121/255.0 green:113/255.0 blue:199/255.0 alpha:1],\
[UIColor colorWithRed:16/255.0 green:149/255.0 blue:224/255.0 alpha:1]\
]

#define CHART_MARGIN 50

@interface DVPieChart ()
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *colorArray;
@end

@implementation DVPieChart

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)draw {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    
    CGFloat min = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width;
    
    CGPoint center =  CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = min * 0.5 - CHART_MARGIN;
    CGFloat start = 0;
    CGFloat angle = 0;
    CGFloat end = start;
    
    if (self.dataArray.count == 0) {
        
        end = start + M_PI * 2;
        
        UIColor *color = COLOR_ARRAY.firstObject;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
        
        [color set];
        
        //添加一根线到圆心
        [path addLineToPoint:center];
        [path fill];
        
    } else {
        
        NSMutableArray *pointArray = [NSMutableArray array];
        NSMutableArray *centerArray = [NSMutableArray array];
        
        self.modelArray = [NSMutableArray array];
        self.colorArray = [NSMutableArray array];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            DVFoodPieModel *model = self.dataArray[i];
            CGFloat percent = model.rate;
            UIColor *color = COLOR_ARRAY[i];
            
            start = end;
            
            angle = percent * M_PI * 2;
            
            end = start + angle;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
            
            [color set];
            
            //添加一根线到圆心
            [path addLineToPoint:center];
            [path fill];
            
            // 获取弧度的中心角度
            CGFloat radianCenter = (start + end) * 0.5;
            
            // 获取指引线的起点
            CGFloat lineStartX = self.frame.size.width * 0.5 + radius * cos(radianCenter);
            CGFloat lineStartY = self.frame.size.height * 0.5 + radius * sin(radianCenter);
            
            CGPoint point = CGPointMake(lineStartX, lineStartY);
            
            if (i <= self.dataArray.count / 2 - 1) {
                [pointArray insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
                [centerArray insertObject:[NSNumber numberWithFloat:radianCenter] atIndex:0];
                [self.modelArray insertObject:model atIndex:0];
                [self.colorArray insertObject:color atIndex:0];
            } else {
                [pointArray addObject:[NSValue valueWithCGPoint:point]];
                [centerArray addObject:[NSNumber numberWithFloat:radianCenter]];
                [self.modelArray addObject:model];
                [self.colorArray addObject:color];
            }
            
            // 绘出指引线
            [self addLineWithColor:color X:lineStartX Y:lineStartY name:model.name number:[NSString stringWithFormat:@"%.2f%%", model.rate * 100] radianCenter:radianCenter];
        }
    }
    
    // 在中心添加label
    DVPieCenterView *centerView = [[DVPieCenterView alloc] init];
    centerView.frame = CGRectMake(0, 0, 80, 80);
    
    CGRect frame = centerView.frame;
    frame.origin = CGPointMake(self.frame.size.width * 0.5 - frame.size.width * 0.5, self.frame.size.height * 0.5 - frame.size.width * 0.5);
    centerView.frame = frame;
    
    centerView.nameLabel.text = self.title;
    
    [self addSubview:centerView];
}


// 绘画指引线
- (void)addLineWithColor:(UIColor *)color X:(CGFloat)x Y:(CGFloat)y name:(NSString *)name number:(NSString *)number radianCenter:(CGFloat)radianCenter {
    
    // 指引线的折点
    CGFloat breakPointX = x + 10 * cos(radianCenter);
    CGFloat breakPointY = y + 10 * sin(radianCenter);
    
    // 指引线的终点
    CGFloat endX;
    CGFloat endY;
    
    // 数字的frame
    CGFloat numberWidth = 80.f;
    CGFloat numberHeight = 15.f;
    
    CGFloat numberX = breakPointX;
    CGFloat numberY = breakPointY - numberHeight;
    
    
    // title的frame
    CGFloat titleWidth = numberWidth;
    CGFloat titleHeight = numberHeight;
    
    CGFloat titleX = breakPointX;
    CGFloat titleY = breakPointY + 2;
    
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    paragraph.alignment = NSTextAlignmentRight;
    
    if (x > self.frame.size.width * 0.5) {
        
        endX = breakPointX + numberWidth;
        endY = breakPointY;
        
    } else {
        
        endX = breakPointX - numberWidth;
        endY = breakPointY;
        
        paragraph.alignment = NSTextAlignmentLeft;
        
        numberX = endX;
        titleX = endX;
    }
    
    // 绘制指引线
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.绘制路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(x, y)];
    
    [path addLineToPoint:CGPointMake(breakPointX, breakPointY)];
    
    [path addLineToPoint:CGPointMake(endX, endY)];
    
    CGContextSetLineWidth(ctx, 1);
    
    //设置颜色
    [color set];
    
    //3.把绘制的内容添加到上下文当中
    CGContextAddPath(ctx, path.CGPath);
    //4.把上下文的内容显示到View上(渲染到View的layer)(stroke fill)
    CGContextStrokePath(ctx);
    
    CGFloat point = -5;
    if (x > self.frame.size.width * 0.5) {
        point = 0;
    }
    
    UIColor *strColor = color;
    //指引线上面的数字
    [name drawInRect:CGRectMake(numberX, numberY, numberWidth, numberHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:strColor,NSParagraphStyleAttributeName:paragraph}];
    
    // 指引线下面的title
    [number drawInRect:CGRectMake(titleX, titleY, titleWidth, titleHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:strColor,NSParagraphStyleAttributeName:paragraph}];
}

@end

