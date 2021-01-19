```objectivec
@property (strong, nonatomic)DVSwitch *switcher;

- (void)topButtonView {

    NSArray *itemArr = @[@"约见中",@"待评价",@"已完成"];
    self.switcher = [[DVSwitch alloc] initWithStringsArray:itemArr];
    self.switcher.layer.cornerRadius = 16;
    self.switcher.layer.masksToBounds = YES;
    
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.switcher.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.switcher.layer.shouldRasterize = YES;

    self.switcher.sliderOffset = 1.0;
    self.switcher.font = [UIFont systemFontOfSize:14];
    self.switcher.backgroundColor = [UIColor whiteColor];
    self.switcher.sliderColor = TRZXMainColor;
    self.switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    self.switcher.labelTextColorOutsideSlider = zideColor;
    //    self.navigationItem.titleView = self.switcher;
    [self.view addSubview:self.switcher];
    [self.switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(WIDTH(self.view)*0.80));
        make.height.equalTo(@(35));
    }];
    //    注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushZhuangTai) name:PushSunGoBack object:nil];
    zjself;
    __block MyExpertViewController *mySelf = self;

    [self.switcher setPressedHandler:^(NSUInteger index) {

        _status = [NSString stringWithFormat:@"%lu",(unsigned long)index+1];

        if (index == 0) {
            _cureentArray = nil;
            [sfself tableViewOne];
//            _switcherStr03 = @"0";
            _strUrl = @"0";
            [mySelf requestFindPageByStudent:@"1"];
            mySelf.zwLabel.textColor = [UIColor whiteColor];
            mySelf.zwLabel1.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel2.textColor = [UIColor lightGrayColor];

        } else if (index == 1){
            _cureentArray = nil;
            [sfself tableViewTwo];
//            _switcherStr03 = @"1";
            _strUrl = @"1";
            [mySelf requestFindPageByStudent:@"2"];
            mySelf.zwLabel.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel1.textColor = [UIColor whiteColor];
            mySelf.zwLabel2.textColor = [UIColor lightGrayColor];
            
        } else {
            _cureentArray = nil;
            [sfself tableViewStree];
//            _switcherStr03 = @"2";
            _strUrl = @"2";
            [mySelf requestFindPageByStudent:@"3"];
            mySelf.zwLabel.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel1.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel2.textColor = [UIColor whiteColor];
        }
    }];

    [self zhuangtaiview];
}

----------------------
//
//  TRZXDVSwitch.h
//  TRZXMyCustomer
//
//  Created by Rhino on 2017/2/27.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRZXDVSwitch : UIControl

@property (strong, nonatomic) NSArray *strings;
@property (strong, nonatomic) UIColor *backgroundColor; // defaults to gray
@property (strong, nonatomic) UIColor *sliderColor; // defaults to white
@property (strong, nonatomic) UIColor *labelTextColorInsideSlider; // defaults to black
@property (strong, nonatomic) UIColor *labelTextColorOutsideSlider; // defaults to white
@property (strong, nonatomic) UIFont *font; // default is nil
@property (nonatomic) CGFloat cornerRadius; // defaults to 12
@property (nonatomic) CGFloat sliderOffset; // slider offset from background, top, bottom, left, right
@property (strong, nonatomic) UIView *backgroundView;

+ (instancetype)switchWithStringsArray:(NSArray *)strings;
- (instancetype)initWithStringsArray:(NSArray *)strings;
- (instancetype)initWithAttributedStringsArray:(NSArray *)strings;

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated; // sets the index, also calls handler block

// This method sets handler block that is getting called after the switcher is done animating the transition

- (void)setPressedHandler:(void (^)(NSUInteger index))handler;

// This method sets handler block that is getting called right before the switcher starts animating the transition

- (void)setWillBePressedHandler:(void (^)(NSUInteger index))handler;

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated; // sets the index without calling the handler block

/////////add
- (void)changeLabelTextWithArrayString:(NSArray *)strings;

@end

------------

//
//  TRZXDVSwitch.m
//  TRZXMyCustomer
//
//  Created by Rhino on 2017/2/27.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "TRZXDVSwitch.h"

@interface TRZXDVSwitch ()

@property (strong, nonatomic) NSMutableArray *onTopLabels;
@property (strong, nonatomic) NSMutableArray *labels;

@property (strong, nonatomic) void (^handlerBlock)(NSUInteger index);
@property (strong, nonatomic) void (^willBePressedHandlerBlock)(NSUInteger index);

@property (strong, nonatomic) UIView *sliderView;

@property (nonatomic) NSInteger selectedIndex;

@end

@implementation TRZXDVSwitch

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [NSException raise:@"DVSwitchInitException" format:@"Init call is prohibited, use initWithStringsArray: method"];
    }
    
    return self;
}

+ (instancetype)switchWithStringsArray:(NSArray *)strings
{
    // to do
    return [[TRZXDVSwitch alloc] initWithStringsArray:strings];
}

- (instancetype)initWithStringsArray:(NSArray *)strings
{
    self = [super init];
    
    self.strings = strings;
    self.cornerRadius = 12.0f;
    self.sliderOffset = 1.0f;
    
    self.backgroundColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    self.sliderColor = [UIColor whiteColor];
    self.labelTextColorInsideSlider = [UIColor blackColor];
    self.labelTextColorOutsideSlider = [UIColor whiteColor];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.backgroundView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundView];
    
    self.labels = [[NSMutableArray alloc] init];
    
    for (int k = 0; k < [self.strings count]; k++) {
        
        NSString *string = self.strings[k];
        UILabel *label = [[UILabel alloc] init];
        label.tag = k;
        label.text = string;
        label.font = self.font;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.labelTextColorOutsideSlider;
        label.numberOfLines = 0;
        [self.backgroundView addSubview:label];
        [self.labels addObject:label];
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecognizerTap:)];
        [label addGestureRecognizer:rec];
        label.userInteractionEnabled = YES;
    }
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.backgroundColor = self.sliderColor;
    self.sliderView.clipsToBounds = YES;
    [self addSubview:self.sliderView];
    
    self.onTopLabels = [[NSMutableArray alloc] init];
    
    for (NSString *string in self.strings) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = string;
        label.font = self.font;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = self.labelTextColorInsideSlider;
        [self.sliderView addSubview:label];
        [self.onTopLabels addObject:label];
    }
    
    UIPanGestureRecognizer *sliderRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderMoved:)];
    [self.sliderView addGestureRecognizer:sliderRec];
    
    return self;
}

- (instancetype)initWithAttributedStringsArray:(NSArray *)strings {
    self = [super init];
    
    self.strings        = strings;
    self.cornerRadius   = 12.0f;
    self.sliderOffset   = 1.0f;
    
    self.backgroundColor    = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    self.sliderColor        = [UIColor whiteColor];
    self.labelTextColorInsideSlider     = [UIColor blackColor];
    self.labelTextColorOutsideSlider    = [UIColor whiteColor];
    
    self.backgroundView = [[UIView alloc] init];
    
    self.backgroundView.backgroundColor         = self.backgroundColor;
    self.backgroundView.userInteractionEnabled  = YES;
    [self addSubview:self.backgroundView];
    
    self.labels = [[NSMutableArray alloc] init];
    
    [self.strings enumerateObjectsUsingBlock:^(NSMutableAttributedString *str, NSUInteger idx, BOOL *stop) {
        
        [str addAttribute:NSForegroundColorAttributeName
                    value:self.labelTextColorOutsideSlider
                    range:NSMakeRange(0, str.length)];
        
        UILabel *label          = [[UILabel alloc] init];
        label.tag               = idx;
        label.attributedText    = str;
        label.textAlignment     = NSTextAlignmentCenter;
        
        [self.backgroundView addSubview:label];
        [self.labels addObject:label];
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleRecognizerTap:)];
        [label addGestureRecognizer:rec];
        label.userInteractionEnabled = YES;
    }];
    
    self.sliderView                 = [[UIView alloc] init];
    self.sliderView.backgroundColor = self.sliderColor;
    self.sliderView.clipsToBounds   = YES;
    [self addSubview:self.sliderView];
    
    self.onTopLabels = [[NSMutableArray alloc] init];
    
    [self.strings enumerateObjectsUsingBlock:^(NSMutableAttributedString *str, NSUInteger idx, BOOL *stop) {
        
        [str addAttribute:NSForegroundColorAttributeName
                    value:self.labelTextColorInsideSlider
                    range:NSMakeRange(0, str.length)];
        
        UILabel *label          = [[UILabel alloc] init];
        label.attributedText    = str;
        label.textAlignment     = NSTextAlignmentCenter;
        
        [self.sliderView addSubview:label];
        [self.onTopLabels addObject:label];
    }];
    
    UIPanGestureRecognizer *sliderRec = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(sliderMoved:)];
    [self.sliderView addGestureRecognizer:sliderRec];
    
    return self;
}

- (void)setPressedHandler:(void (^)(NSUInteger))handler
{
    self.handlerBlock = handler;
}

- (void)setWillBePressedHandler:(void (^)(NSUInteger))handler
{
    self.willBePressedHandlerBlock = handler;
}

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index > [self.strings count]) {
        return;
    }
    
    self.selectedIndex = index;
    
    if (animated) {
        
        [self animateChangeToIndex:index callHandler:YES];
        
    } else {
        
        [self changeToIndexWithoutAnimation:index callHandler:YES];
    }
}

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index > [self.strings count]) {
        return;
    }
    self.selectedIndex = index;
    
    if (animated) {
        
        [self animateChangeToIndex:index callHandler:NO];
        
    } else {
        
        [self changeToIndexWithoutAnimation:index callHandler:NO];
    }
}

- (void)layoutSubviews
{
    self.backgroundView.layer.cornerRadius = self.cornerRadius;
    self.sliderView.layer.cornerRadius = self.cornerRadius;
    
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.sliderView.backgroundColor = self.sliderColor;
    
    self.backgroundView.frame = [self convertRect:self.frame fromView:self.superview];
    
    self.backgroundView.layer.cornerRadius = self.cornerRadius;
    self.sliderView.layer.cornerRadius = self.cornerRadius;
    
    CGFloat sliderWidth = self.frame.size.width / [self.strings count];
    
    self.sliderView.frame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
    
    for (int i = 0; i < [self.labels count]; i++) {
        
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(i * sliderWidth, 0, sliderWidth, self.frame.size.height);
        if (self.font) {
            label.font = self.font;
        }
        label.textColor = self.labelTextColorOutsideSlider;
    }
    
    for (int j = 0; j < [self.onTopLabels count]; j++) {
        
        UILabel *label = self.onTopLabels[j];
        label.frame = CGRectMake([self.sliderView convertPoint:CGPointMake(j * sliderWidth, 0) fromView:self.backgroundView].x, - self.sliderOffset, sliderWidth, self.frame.size.height);
        if (self.font) {
            label.font = self.font;
        }
        label.textColor = self.labelTextColorInsideSlider;
    }
}

- (void)animateChangeToIndex:(NSUInteger)selectedIndex callHandler:(BOOL)callHandler
{
    
    if (self.willBePressedHandlerBlock) {
        self.willBePressedHandlerBlock(selectedIndex);
    }
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGFloat sliderWidth = self.frame.size.width / [self.strings count];
        
        CGRect oldFrame = self.sliderView.frame;
        CGRect newFrame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
        
        CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
        
        self.sliderView.frame = newFrame;
        
        for (UILabel *label in self.onTopLabels) {
            
            label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        
        if (self.handlerBlock && callHandler) {
            self.handlerBlock(selectedIndex);
        }
    }];
}

- (void)changeToIndexWithoutAnimation:(NSUInteger)selectedIndex callHandler:(BOOL)callHandler
{
    if (self.willBePressedHandlerBlock) {
        self.willBePressedHandlerBlock(selectedIndex);
    }
    
    CGFloat sliderWidth = self.frame.size.width / [self.strings count];
    
    CGRect oldFrame = self.sliderView.frame;
    CGRect newFrame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
    
    CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
    
    self.sliderView.frame = newFrame;
    
    for (UILabel *label in self.onTopLabels) {
        
        label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
    }
    
    if (self.handlerBlock && callHandler) {
        self.handlerBlock(selectedIndex);
    }
}

- (void)handleRecognizerTap:(UITapGestureRecognizer *)rec
{
    self.selectedIndex = rec.view.tag;
    [self animateChangeToIndex:self.selectedIndex callHandler:YES];
}

- (void)sliderMoved:(UIPanGestureRecognizer *)rec
{
    if (rec.state == UIGestureRecognizerStateChanged) {
        
        CGRect oldFrame = self.sliderView.frame;
        
        CGFloat minPos = 0 + self.sliderOffset;
        CGFloat maxPos = self.frame.size.width - self.sliderOffset - self.sliderView.frame.size.width;
        
        CGPoint center = rec.view.center;
        CGPoint translation = [rec translationInView:rec.view];
        
        center = CGPointMake(center.x + translation.x, center.y);
        rec.view.center = center;
        [rec setTranslation:CGPointZero inView:rec.view];
        
        if (self.sliderView.frame.origin.x < minPos) {
            
            self.sliderView.frame = CGRectMake(minPos, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
            
        } else if (self.sliderView.frame.origin.x > maxPos) {
            
            self.sliderView.frame = CGRectMake(maxPos, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
        }
        
        CGRect newFrame = self.sliderView.frame;
        CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
        
        for (UILabel *label in self.onTopLabels) {
            
            label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
        }
        
    } else if (rec.state == UIGestureRecognizerStateEnded || rec.state == UIGestureRecognizerStateCancelled || rec.state == UIGestureRecognizerStateFailed) {
        
        NSMutableArray *distances = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.strings count]; i++) {
            
            CGFloat possibleX = i * self.sliderView.frame.size.width;
            CGFloat distance = possibleX - self.sliderView.frame.origin.x;
            [distances addObject:@(fabs(distance))];
        }
        
        NSNumber *num = [distances valueForKeyPath:@"@min.doubleValue"];
        NSInteger index = [distances indexOfObject:num];
        
        if (self.willBePressedHandlerBlock) {
            self.willBePressedHandlerBlock(index);
        }
        
        CGFloat sliderWidth = self.frame.size.width / [self.strings count];
        CGFloat desiredX = sliderWidth * index + self.sliderOffset;
        
        if (self.sliderView.frame.origin.x != desiredX) {
            
            CGRect evenOlderFrame = self.sliderView.frame;
            
            CGFloat distance = desiredX - self.sliderView.frame.origin.x;
            CGFloat time = fabs(distance / 300);
            
            [UIView animateWithDuration:time animations:^{
                
                self.sliderView.frame = CGRectMake(desiredX, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
                
                CGRect newFrame = self.sliderView.frame;
                
                CGRect offRect = CGRectMake(newFrame.origin.x - evenOlderFrame.origin.x, newFrame.origin.y - evenOlderFrame.origin.y, 0, 0);
                
                for (UILabel *label in self.onTopLabels) {
                    
                    label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
                }
            } completion:^(BOOL finished) {
                
                self.selectedIndex = index;
                
                if (self.handlerBlock) {
                    self.handlerBlock(index);
                }
                
            }];
            
        } else {
            
            self.selectedIndex = index;
            
            if (self.handlerBlock) {
                self.handlerBlock(self.selectedIndex);
            }
        }
    }
}

- (void)changeLabelTextWithArrayString:(NSArray *)strings{
    self.strings = strings;
    for (int i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        [label setText:strings[i]];
        //        [label setNeedsDisplay];
    }
    for (int i = 0; i < self.onTopLabels.count; i++) {
        UILabel *label = self.onTopLabels[i];
        [label setText:strings[i]];
    }
    //    [self setNeedsDisplay];
}

@end
```