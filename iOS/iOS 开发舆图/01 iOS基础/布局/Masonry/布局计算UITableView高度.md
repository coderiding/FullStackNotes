```objectivec
//主要是UILabel的高度会有变化，所以这里主要是说说label变化时如何处理，设置UILabel的时候注意要设置preferredMaxLayoutWidth这个宽度，还有ContentHuggingPriority为UILayoutPriorityRequried

CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 10 * 2;

textLabel = [UILabel new];
textLabel.numberOfLines = 0;
textLabel.preferredMaxLayoutWidth = maxWidth;
[self.contentView addSubview:textLabel];

[textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(statusView.mas_bottom).with.offset(10);
    make.left.equalTo(self.contentView).with.offset(10);
    make.right.equalTo(self.contentView).with.offset(-10);
    make.bottom.equalTo(self.contentView).with.offset(-10);
}];

[_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
```