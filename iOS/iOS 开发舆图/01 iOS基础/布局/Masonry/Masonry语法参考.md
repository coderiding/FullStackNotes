```objectivec
// A的贴边：如果A在别人的里面，这样写，就是完全贴边
make.right.top.bottom.mas_equalTo(0);
make.top.bottom.mas_equalTo(0);//上下边距均为0

// A的X轴中心和Y轴中心
make.centerX.mas_equalTo(self.view.mas_centerX);//X轴中心对齐self.view的X轴中心。
make.centerY.equalTo(self);

// A的宽高
make.width.equalTo(@40);
make.height.equalTo(@40);
make.width.mas_equalTo(self.view.frame.size.width/3.0);//宽度为self.view的宽度1/3。

// A的左或右对齐B的左或右
make.right.mas_equalTo(redView.mas_left)//约束（greenView的）right对齐redView的left。
make.right.equalTo(self.phoneBtn.mas_left).offset(-20);
make.left.mas_equalTo(redView.mas_right)//约束（blueView的）left对齐redView的right。
make.left.mas_equalTo(redView.mas_right);
make.right.mas_equalTo(self.view).mas_offset(-10);// rightView 右边 = self.view 右边 - 10
make.left.mas_equalTo(self.letfView.mas_right).mas_offset(20);// rightView 左边 = leftView 右边 + 20
make.left.mas_equalTo(self.view).mas_offset(10);// leftView 左边 = self.view 左边 +10
	
// A的上边对齐别人
make.top.mas_equalTo(self.letfView);// rightView 上边 = leftView 上边（即上边对齐）
make.top.mas_equalTo(self.view).mas_offset(20);// leftView 上边 = self.view 上边 +20

// A距离上边距离，
// A的顶部对齐别人的底部
// 添加上边距约束（上边距 = 黑色view的下边框 + 偏移量20）
make.top.equalTo(blackView.mas_bottom).offset(20);

// A距离左边距离
// 添加左边距（左边距 = 父容器纵轴横轴中心 + 偏移量0）
make.left.equalTo(weakSelf.view.mas_centerX).offset(0);

// A在父视图内缩
// 添加右、下边距约束
make.bottom.and.right.mas_equalTo(-20);

//相对于父视图边距为10
UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(superview.mas_top).with.offset(padding.top); //with is an optional semantic filler
    make.left.equalTo(superview.mas_left).with.offset(padding.left);
    make.bottom.equalTo(superview.mas_bottom).with.offset(-padding.bottom);
    make.right.equalTo(superview.mas_right).with.offset(-padding.right);
}];

//相对于父视图边距为10简洁写法
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(superview).with.insets(padding);
}];

//这两个作用完全一样
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.greaterThanOrEqualTo(self.view);
    make.left.greaterThanOrEqualTo(self.view.mas_left);
}];

//.equalTo .lessThanOrEqualTo .greaterThanOrEqualTo使用NSNumber
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.greaterThanOrEqualTo(@200);
    make.width.lessThanOrEqualTo(@400);
    make.left.lessThanOrEqualTo(@10);
}];

//如果不用NSNumber可以用以前的数据结构，只需用mas_equalTo就行
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(42);
    make.height.mas_equalTo(20);
    make.size.mas_equalTo(CGSizeMake(50, 100));
    make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
    make.left.mas_equalTo(self.view).mas_offset(UIEdgeInsetsMake(10, 0, 10, 0));
}];

//也可以使用数组
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@[self.view.mas_height, superview.mas_height]);
    make.height.equalTo(@[self.view, superview]);
    make.left.equalTo(@[self.view, @100, superview.mas_right]);
}];

// priority的使用
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.greaterThanOrEqualTo(self.view.mas_left).with.priorityLow();
    make.top.equalTo(self.view.mas_top).with.priority(600);
}];

//同时创建多个约束
[self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    //让top,left,bottom,right都和self.view一样
    make.edges.equalTo(self.view);
    //edges
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5, 10, 15, 20));
    //size
    make.size.greaterThanOrEqualTo(self.view);
    make.size.equalTo(superview).sizeOffset(CGSizeMake(100, -50));
    //center
    make.center.equalTo(self.view);
    make.center.equalTo(self.view).centerOffset(CGPointMake(-5, 10));
    //chain
    make.left.right.and.bottom.equalTo(self.view);
    make.top.equalTo(self.view);
}];
```

### 注意事项

- 用mas_makeConstraints的那个view需要在addSubview之后才能用这个方法
- mas_equalTo适用数值元素，equalTo适合多属性的比如make.left.and.right.equalTo(self.view)
- 方法and和with只是为了可读性，返回自身，比如make.left.and.right.equalTo(self.view)和make.left.right.equalTo(self.view)是一样的。
- 因为iOS中原点在左上角所以注意使用offset时注意right和bottom用负数。