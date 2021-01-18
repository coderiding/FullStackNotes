```objectivec
--------------------单行的情况
NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ",m.orderStatusText] attributes:@{NSParagraphStyleAttributeName:paraStyle}];
l3.attributedText = attrText;
    
    
---------------------多行的情况
NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
paraStyle.alignment = NSTextAlignmentCenter;//对齐
paraStyle.firstLineHeadIndent = 10;
paraStyle.headIndent = 10;//行首缩进
paraStyle.tailIndent = -10;//行尾缩进
NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ",m.orderStatusText] attributes:@{NSParagraphStyleAttributeName:paraStyle}];
l3.attributedText = attrText;
```