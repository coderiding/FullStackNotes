```objectivec
-(void)dodoViews
{
    
    [self.view configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(self.view.bounds.size.width);
        layout.height = YGPointValue(self.view.bounds.size.height);
        layout.alignItems = YGAlignCenter;
    }];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor lightGrayColor];
    [contentView configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = true;
        // 4
        layout.flexDirection =  YGFlexDirectionRow;
        layout.width = YGPointValue(320);
        layout.height = YGPointValue(80);
        layout.marginTop = YGPointValue(100);
        
        layout.padding =  YGPointValue(10);//设置了全部子项目的填充值
    }];
    
    UIView *child1 = [[UIView alloc]init];
    child1.backgroundColor = [UIColor redColor];
    [child1 configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(80);
        layout.marginRight = YGPointValue(10);
    }];
    
    
    
    UIView *child2 = [[UIView alloc]init];
    child2.backgroundColor = [UIColor blueColor];
    [child2 configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(80);
        layout.flexGrow = 1;
        layout.height = YGPointValue(20);
        layout.alignSelf = YGAlignCenter;
        
    }];
    
    [contentView addSubview:child1];
    [contentView addSubview:child2];
    [self.view addSubview:contentView];
    [self.view.yoga applyLayoutPreservingOrigin:YES];

}
```