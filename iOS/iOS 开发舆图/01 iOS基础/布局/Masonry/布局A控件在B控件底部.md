A控件在B控件底部，左边对齐，上下间隙为2

```objectivec
[textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.nameStackView.mas_left);
    make.top.equalTo(self.nameStackView.mas_bottom).offset(2);
    make.height.equalTo(@40);
    make.width.equalTo(@188);
}];
```