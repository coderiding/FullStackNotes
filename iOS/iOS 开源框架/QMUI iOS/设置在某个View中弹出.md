```objectivec
- (void)handleShowInView {
    if (self.modalViewControllerForAddSubview) {
        [self.modalViewControllerForAddSubview hideInView:self.view animated:YES completion:nil];
    }
    
    CGRect modalRect = CGRectMake(40, self.qmui_navigationBarMaxYInViewCoordinator + 40, CGRectGetWidth(self.view.bounds) - 40 * 2, CGRectGetHeight(self.view.bounds) - self.qmui_navigationBarMaxYInViewCoordinator - 40 * 2);
    
    QMUIButton *button = [[QMUIButton alloc] init];
    button.tintColorAdjustsTitleAndImage = ButtonTintColor;
    button.titleLabel.font = UIFontMake(16);
    [button setTitle:@"进入下一个界面" forState:UIControlStateNormal];
    [button setImage:TableViewCellDisclosureIndicatorImage forState:UIControlStateNormal];
    button.spacingBetweenImageAndTitle = 4;
    button.imagePosition = QMUIButtonImagePositionRight;
    [button sizeToFit];
    button.qmui_tapBlock = ^(__kindof UIControl *sender) {
        [QMUIHelper.visibleViewController.navigationController pushViewController:QDModalPresentationViewController.new animated:YES];
    };
    [contentView addSubview:button];
    
    self.modalViewControllerForAddSubview = [[QMUIModalPresentationViewController alloc] init];
    self.modalViewControllerForAddSubview.contentView = contentView;
    self.modalViewControllerForAddSubview.view.frame = modalRect;// 为了展示，故意让浮层小于当前界面，以展示局部浮层的能力
    // 以 addSubview 的形式显示，此时需要retain住modalPresentationViewController，防止提前被释放
    [self.modalViewControllerForAddSubview showInView:self.view animated:YES completion:nil];
}
```