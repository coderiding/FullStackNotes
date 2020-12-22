//
//  LewLegendView.m
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/2.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "LewLegendView.h"
#import "LewCommon.h"

#define LegendTextSize 10
#define RectWidth 7
#define Rect_TextMargin 5
#define LegendMargin 7
#define Margin 5

@interface LewLegendView ()

@end

@implementation LewLegendView

- (instancetype)initWithData:(NSArray<LewLegendViewData *> *)data{
    self = [super init];
    if (!self) return nil;
    
    self.data = data;
    
    return self;
}

- (instancetype)init{
    self = [super init];
    if (!self) return  nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)setData:(NSArray<LewLegendViewData *> *)data{
    _data = data;
    __block CGFloat textMaxWidth = 0;
    __block CGFloat textWidth = 0;
    [data enumerateObjectsUsingBlock:^(LewLegendViewData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *legendText = obj.label;
        CGSize size = [legendText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LegendTextSize]}];
        textWidth = textWidth+size.width;
        if (size.width>textMaxWidth) {
            textMaxWidth = size.width;
        }
    }];
    switch (_alignment) {
        case LegendAlignmentVertical:{
            CGRect bounds = CGRectMake(0, 0, Margin+RectWidth+Rect_TextMargin+textMaxWidth+Margin, Margin+(LegendTextSize+LegendMargin)*data.count-LegendMargin+Margin);
            self.bounds = bounds;
            break;
        }
        case LegendAlignmentHorizontal:{
            CGRect bounds = CGRectMake(0, 0, Margin+(RectWidth+Rect_TextMargin+LegendMargin)*data.count+textWidth-LegendMargin+Margin, Margin+LegendTextSize+Margin);
            self.bounds = bounds;
            break;
        }
    }

}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (_alignment) {
        case LegendAlignmentVertical:{
            [_data enumerateObjectsUsingBlock:^(LewLegendViewData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGContextSetFillColorWithColor(context, obj.color.CGColor);
                CGRect rect = CGRectMake(Margin ,Margin+idx*(LegendTextSize+LegendMargin)+(LegendTextSize-RectWidth)/2, RectWidth, RectWidth);//坐标
                CGContextFillRect(context, rect);
                
                [obj.label drawInRect:CGRectMake(Margin+RectWidth+Rect_TextMargin, Margin+idx*(LegendTextSize+LegendMargin)-2, self.bounds.size.width, LegendTextSize*2) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:LegendTextSize], NSForegroundColorAttributeName:[UIColor grayColor]}];
            }];
            break;
        }
        case LegendAlignmentHorizontal:{
            __block CGFloat x = Margin;

            [_data enumerateObjectsUsingBlock:^(LewLegendViewData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGContextSetFillColorWithColor(context, obj.color.CGColor);
                CGRect rect = CGRectMake(x ,Margin+(LegendTextSize-RectWidth)/2, RectWidth, RectWidth);//坐标
                CGContextFillRect(context, rect);

                CGSize size = [obj.label sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:LegendTextSize]}];
                x = x+RectWidth+Rect_TextMargin;

                [obj.label drawInRect:CGRectMake(x, Margin-2, size.width, self.bounds.size.height) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:LegendTextSize], NSForegroundColorAttributeName:[UIColor grayColor]}];
                x = x+size.width+LegendMargin;
            }];
            break;
        }
    }
//    [_data enumerateObjectsUsingBlock:^(LewLegendViewData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGRect rect = CGRectMake(Margin ,Margin+idx*(LegendTextSize+LabelMarginTop), LegendTextSize, LegendTextSize);//坐标
//        CGContextFillRect(context, rect);
//        
//        CGContextSetFillColorWithColor(context, LewGray.CGColor);//设置填充颜色
//        [obj.label drawInRect:CGRectMake(Margin+LegendTextSize+LabelMarginRight, Margin+idx*(LegendTextSize+LabelMarginTop)-1, self.bounds.size.width, LegendTextSize*2) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:LegendTextSize], NSForegroundColorAttributeName:obj.color}];
//    }];
}


@end

@implementation LewLegendViewData

@end