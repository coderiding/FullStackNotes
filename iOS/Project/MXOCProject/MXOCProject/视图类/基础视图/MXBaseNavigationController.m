//
//  MXBaseNavigationController.m
//  MXOCProject
//
//  Created by coderiding on 2020/12/11.
//

#import "MXBaseNavigationController.h"
#import "UINavigationController+Statubar.h"

@interface MXBaseNavigationController ()

@end

@implementation MXBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaultNavigationBarApperance];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupDefaultNavigationBarApperance {
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    navigationBar.translucent = NO;
    navigationBar.tintColor = [UIColor whiteColor];
    
    [navigationBar setShadowImage:[UIImage new]];
    [navigationBar setBarStyle:UIBarStyleBlack];
    // 导航栏标题样式
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:18]}];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.topViewController preferredStatusBarStyle];
}

#pragma mark -

-(void)popself {
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [self createWhiteBtn];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
