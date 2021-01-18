```objectivec
- (void)handlePresentShowing {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    contentView.backgroundColor = UIColor.qd_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
  
    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 presentViewController 的形式展示时，animated 要传 NO，否则系统的动画会覆盖 QMUIModalPresentationAnimationStyle 的动画
    [self presentViewController:modalViewController animated:NO completion:NULL];
}
```