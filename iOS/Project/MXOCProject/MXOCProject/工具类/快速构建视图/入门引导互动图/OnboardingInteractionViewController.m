//
//  OnboardingInteractionViewController.m
//  MXOCProject
//
//  Created by coderiding on 2020/12/17.
//

#import "OnboardingInteractionViewController.h"
#import "Slide.h"
#import <Masonry/Masonry.h>

@interface OnboardingInteractionViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation OnboardingInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBoardingData];
}

#pragma mark - 加载数据

- (void)loadBoardingData {
    
    Slide *b1 = [NSBundle init] bun;
    
    [self setupSubView];
}

#pragma mark - 加载子视图

- (void)setupSubView {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
    }
    return _pageControl;
}

@end
