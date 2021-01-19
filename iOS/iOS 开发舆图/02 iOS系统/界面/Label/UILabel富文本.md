```objectivec
NSString *str = @"人生若只如初见，何事秋风悲画扇。\n等闲变却故人心，却道故人心易变。\n骊山语罢清宵半，泪雨霖铃终不怨。\n何如薄幸锦衣郎，比翼连枝当日愿。";
NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];

// 富文本字体
[attrStr addAttribute:NSFontAttributeName 
                value:[UIFont systemFontOfSize:30.0f] 
                range:NSMakeRange(0, 3)];

// 富文本颜色
[attrStr addAttribute:NSForegroundColorAttributeName
                value:[UIColor redColor]
                range:NSMakeRange(17, 7)];

// 富文本下划线
[attrStr addAttribute:NSUnderlineStyleAttributeName
                value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                range:NSMakeRange(8, 7)];
                
// 富文本段落
NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//行间距
paragraph.lineSpacing = 10;
//段落间距
paragraph.paragraphSpacing = 20;
//对齐方式
paragraph.alignment = NSTextAlignmentLeft;
//指定段落开始的缩进像素
paragraph.firstLineHeadIndent = 30;
//调整全部文字的缩进像素
paragraph.headIndent = 10;

[attrStr addAttribute:NSParagraphStyleAttributeName
                value:paragraph
                range:NSMakeRange(0, [str length])];

// 富文本添加到容器内
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 200, 0)];
label.backgroundColor = [UIColor lightGrayColor];
//自动换行
label.numberOfLines = 0;
//设置label的富文本
label.attributedText = attrStr;
//label高度自适应，设置sizeToFit之后是可以取出label的高度的，这样做label高度自适应。
[label sizeToFit];
[self.view addSubview:label];

CGFloat height = label.frame.size.height;
NSLog(@"height = %f",height);
```