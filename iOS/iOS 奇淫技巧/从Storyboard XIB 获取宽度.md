- sb 创建的 view 在viewDidload中会先返回sb 当前的约束,一直到viewDidAppear才会对 view 根据屏幕大小重新布局

解决

### 从控制器中

```objectivec
// 方法1
在viewDidAppear获取

// 方法2
[self.view setNeedsLayout];   
[self.view layoutIfNeeded];

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self requestTypeData]; 

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self setupPictureDotView:self.picView];
}

// 方法3：控制器中获取真实的尺寸
- (void)viewDidLayoutSubviews {
    CGFloat width = _frequencyBgImage.frame.size.width;
    CGFloat height = _frequencyBgImage.frame.size.height;
    NSLog(@"width : %f  height : %f ",width,height);
}
```

### 从xib中

```objectivec
// 方法1，注意，从awakeFromNib拿出的宽度是不正确的
- (void)layoutSubviews {
	 [super layoutSubviews];
		//在这里拿到自己的宽度是正确的

 }

// 先添加视图，后面在上面的方法中重新设置尺寸
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.operateView = [OrderListCellOperateView loadOperateViewByType:1];
    self.operateView.frame = CGRectZero;
    [self.operateSuperView addSubview:self.operateView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.operateView.frame = CGRectMake(0, 0, self.operateSuperView.width, self.operateSuperView.height);
}
```