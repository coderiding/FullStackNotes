//
//  LewLegendView.h
//  NetEaseLocalActivities
//
//  Created by pljhonglu on 16/2/2.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LegendAlignment) {
    LegendAlignmentVertical = 0,
    LegendAlignmentHorizontal,
};

@class LewLegendViewData;
@interface LewLegendView : UIView
@property (nonatomic, assign)LegendAlignment alignment;
@property (nonatomic, strong)NSArray<LewLegendViewData *> *data;

- (instancetype)initWithData:(NSArray<LewLegendViewData *> *)data;
@end

@interface LewLegendViewData : NSObject
@property (nonatomic, strong)NSString *label;
@property (nonatomic, strong)UIColor *color;
@end