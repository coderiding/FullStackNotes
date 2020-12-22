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

#define CHART_MARGIN 50

@interface DVPieChart ()

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
        
        // M_PI是180，那么end就是360度，start是0度
        end = start + M_PI * 2;

        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];

        //添加一根线到圆心
        [path addLineToPoint:center];
        [path fill];
        
    } else {

        for (int i = 0; i < self.dataArray.count; i++) {
            
            DVFoodPieModel *model = self.dataArray[i];
            CGFloat percent = model.rate;
            UIColor *color = model.color ? model.color : [UIColor redColor];
            
            // start就是上一个的end
            start = end;
            
            // 饼状的比例*360，就是占了一个圆的比例
            angle = percent * M_PI * 2;
            // 结束角度=angle就是从比例转换来的，加上start，如果是第一个，那start就是0，如果是第二个，那start就是第一个的end
            end = start + angle;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
            
            [color set];
            
            //添加一根线到圆心
            [path addLineToPoint:center];
            [path fill];
            
            // 获取弧度的中心角度，就是圆弧中心点的角度是具体的一个读数，比如0到180，那90度就是radianCenter
            CGFloat radianCenter = (start + end) * 0.5;
            
            // 获取指引线的起点，就是那条折线
            CGFloat lineStartX = self.frame.size.width * 0.5 + radius * cos(radianCenter);
            CGFloat lineStartY = self.frame.size.height * 0.5 + radius * sin(radianCenter);
            
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
    
    centerView.nameLabel.attributedText = [self getAttributeTitle];
    
    [self addSubview:centerView];
}

- (NSMutableAttributedString *)getAttributeTitle {

    NSString *r1 = @"1400\n订单收入";
    NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithString:r1];

    [att1 addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithRed:44/255.0 green:44/255.0 blue:45/255.0 alpha:1.0]
                  range:NSMakeRange(0, r1.length-4)];
    [att1 addAttribute:NSFontAttributeName
                 value:[UIFont fontWithName:@"PingFangSC-Regular" size: 15]
                range:NSMakeRange(0, r1.length-4)];

    [att1 addAttribute:NSForegroundColorAttributeName
                  value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
                  range:NSMakeRange(r1.length-4, 4)];
    [att1 addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"PingFangSC-Regular" size: 12]
                  range:NSMakeRange(r1.length-4, 4)];

    return att1;
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
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.绘制路径
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
    
    // 指引线下面的title
    [number drawInRect:CGRectMake(titleX, titleY, titleWidth, titleHeight) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14],NSForegroundColorAttributeName: [UIColor colorWithRed:44/255.0 green:44/255.0 blue:45/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraph}];
    
    // 指引线上面的数字
    [name drawInRect:CGRectMake(numberX, numberY, numberWidth, numberHeight) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:11], NSForegroundColorAttributeName:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:69/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraph}];

}

@end

