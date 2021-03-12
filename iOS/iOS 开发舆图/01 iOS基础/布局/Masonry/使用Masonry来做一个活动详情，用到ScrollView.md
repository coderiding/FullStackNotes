# 使用Masonry来做一个活动详情，用到ScrollView


```
//
//  MXChongDanVC.m
//  xbb
//
//  Created by coderiding on 2020/5/20.
//  Copyright © 2020 xiaobangban. All rights reserved.
//

#import "MXChongDanVC.h"
#import "MXCDView1.h"
#import "MXCDView2.h"
#import <Masonry/Masonry.h>

@interface MXChongDanVC ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *topImageView;
@property(nonatomic,strong)UIView *awardContentView;
@property(nonatomic,strong)UIView *firstContentView;
@property(nonatomic,strong)UIView *secondContentView;
@property(nonatomic,assign)CGFloat totalHeight;

@property(nonatomic,strong)MXCDView2 *lastView2;
@end

@implementation MXChongDanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.totalHeight = 0;
    
    [self setupScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)setupScrollView {
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    // 其余的View
    [self setupTopImageView];

    [self setupFirstContentView];

    [self setupSecondContentView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    MXLog(@"secondContentView%@",self.secondContentView);
    self.scrollView.contentSize = CGSizeMake(kMXScreenWidth, self.totalHeight+200);
}

#pragma mark - 顶

- (void)setupTopImageView {
    
    [self.scrollView addSubview:self.topImageView];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.height.equalTo(@(0.753*[UIScreen mainScreen].bounds.size.width));
        
        self.totalHeight += 0.753*[UIScreen mainScreen].bounds.size.width;
    }];
}

#pragma mark - 第一

- (void)setupFirstContentView {
    
    for (NSInteger i = 0 ; i<18; i++) {
        MXCDView1 *sv = [MXCDView1 layoutXibView];
        [self.firstContentView addSubview:sv];
        [sv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@(i*36));
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(@(36));
            
            self.totalHeight += 36;
        }];
    }
    
    [self.scrollView addSubview:self.firstContentView];
    
    [self.firstContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(-18);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(10);
        //make.right.mas_equalTo(self.scrollView.mas_right).offset(-10);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width-20));
        make.height.mas_equalTo(@(36*18));
    }];
}

#pragma mark - 第二

- (UIView *)fView2 {
    UIView *v = [UIView new];
    
    UILabel *l1 = [UILabel new];
    l1.text = @"活动时间";
    
    UILabel *l2 = [UILabel new];
    l2.text = @"asdfsdfdskfjldsjfkdsjfkldsjklfdsjlfdjslkf";
    l2.preferredMaxLayoutWidth = (([UIScreen mainScreen].bounds.size.width-90));
    [l2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    l2.numberOfLines = 0;
    
    CGFloat h = [l2 sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-90, MAXFLOAT) ].height;
    
    [v addSubview:l1];
    [v addSubview:l2];
    
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v.mas_left).offset(10);
        make.centerY.equalTo(v.mas_centerY);
        make.width.equalTo(@60);
    }];
    
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(l1.mas_right).offset(10);
        make.right.equalTo(v.mas_right).offset(-10);
        make.centerY.equalTo(v.mas_centerY);
    }];
    
    return v;
}

- (void)setupSecondContentView {
    [self.scrollView addSubview:self.secondContentView];
    
    [self.secondContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstContentView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(10);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width-20));
    }];
    
    __block CGFloat secondVHeight = 0;
    for (NSInteger i = 0 ; i<19; i++) {
        UIView *v = [UIView new];
        v.frame = CGRectMake(10, secondVHeight, [UIScreen mainScreen].bounds.size.width-40,0);
        
        UILabel *l1 = [UILabel new];
        l1.text = @"活动时间";
        
        UILabel *l2 = [UILabel new];
        l2.text = @"活动时间";
        
        if (i==0) {
           l2.text = @"活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间";
        }else if (i==1){
            l2.text = @"活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间";
        }else if (i==2){
            l2.text = @"活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间活动时间";
        }
        
        l2.numberOfLines = 0;

        CGFloat l2h = [l2.text boundingRectWithSize:CGSizeMake(v.width-110, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:l2.font} context:nil].size.height;
        CGFloat h = l2h+16;
        
        [v addSubview:l1];
        [v addSubview:l2];
        
        l1.frame = CGRectMake(10, 0, 80, 20);
        l2.frame = CGRectMake(10+80+10, 0, v.width-110, l2h);
        
        v.frame = CGRectMake(10, secondVHeight, [UIScreen mainScreen].bounds.size.width-40, h);
        [self.secondContentView addSubview:v];
        
        self.totalHeight += h;
        secondVHeight += h;
    }
    
    [self.secondContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(secondVHeight));
    }];
}

#pragma mark - 懒加载

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.backgroundColor = [UIColor yellowColor];
    }
    return _topImageView;
}

- (UIView *)firstContentView {
    if (!_firstContentView) {
        _firstContentView = [UIView new];
        _firstContentView.backgroundColor = [UIColor whiteColor];
    }
    return _firstContentView;
}

- (UIView *)secondContentView {
    if (!_secondContentView) {
        _secondContentView = [UIView new];
        _secondContentView.backgroundColor = [UIColor whiteColor];
    }
    return _secondContentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = CGRectMake(0, 0, kMXScreenWidth, kMXScreenHeight);
        _scrollView.backgroundColor = [UIColor mx_hexStr:@"#C9F084"];
    }
    return _scrollView;
}

@end
```