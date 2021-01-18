```objectivec
- (void)handleWindowShowing {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    contentView.backgroundColor = UIColor.qd_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 UIWindow 的形式来展示
    [modalViewController showWithAnimated:YES completion:nil];
}
```