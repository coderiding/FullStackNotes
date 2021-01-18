```objectivec
NSMutableAttributedString *text = [NSMutableAttributedString new];
UIFont *font = [UIFont systemFontOfSize:16];
NSMutableAttributedString *attachment = nil;
	
// UIImage attachment
UIImage *image = [UIImage imageNamed:@"dribbble64_imageio"];
attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
[text appendAttributedString: attachment];
	
// UIView attachment
UISwitch *switcher = [UISwitch new];
[switcher sizeToFit];
attachment = [NSMutableAttributedString yy_attachmentStringWithContent:switcher contentMode:UIViewContentModeBottom attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
[text appendAttributedString: attachment];
	
// CALayer attachment
CASharpLayer *layer = [CASharpLayer layer];
layer.path = ...
attachment = [NSMutableAttributedString yy_attachmentStringWithContent:layer contentMode:UIViewContentModeBottom attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
[text appendAttributedString: attachment];

YYLabel *label = [YYLabel new];
label.attributedText = text;
label.textContainerInset = UIEdgeInsetsMake(8, -8, 8, -8);
label.textAlignment = NSTextAlignmentCenter;
label.preferredMaxLayoutWidth = WIDTH;
[label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
```