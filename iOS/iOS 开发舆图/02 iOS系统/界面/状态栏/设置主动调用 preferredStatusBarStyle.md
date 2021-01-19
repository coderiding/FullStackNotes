```objectivec
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 必须放在 viewDidAppear: 方法里面才起效果（自动调用 preferredStatusBarStyle）
    // 放在 viewWillAppear: 方法里面不起效果
    [self setNeedsStatusBarAppearanceUpdate];
}
```