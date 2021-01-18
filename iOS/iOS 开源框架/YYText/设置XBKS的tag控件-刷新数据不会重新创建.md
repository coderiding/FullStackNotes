```objectivec
@property (nonatomic,strong)YYTextView *tagTextView;

- (void)layoutTagTextView:(NSArray*)tagArray tagColor:(NSArray*)tagColorArray {
 
    if (tagArray.count != tagColorArray.count ) {
        return;
    }
    
    if (tagArray.count < 1) {
        return;
    }
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSArray *tags = tagArray;
    NSArray *tagFillColors = tagColorArray;

    UIFont *font = [UIFont boldSystemFontOfSize:11];
    for (int i = 0; i < tags.count; i++) {
       NSString *tag = tags[i];
       UIColor *tagStrokeColor = tagFillColors[i];
       UIColor *tagFillColor = tagFillColors[i];
       
       // mx：第一步:创建一个为string的tag
       NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
       // mx：前后为tag添加空隙
       [tagText yy_insertString:@"   " atIndex:0];
       [tagText yy_appendString:@"   "];
       tagText.yy_font = font;
       tagText.yy_color = [UIColor whiteColor];
       [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
       
       // mx：第二步：创建一个border
       YYTextBorder *border = [YYTextBorder new];
       // mx:YYTextBorder的宽度
       border.strokeWidth = 0;
       // mx：YYTextBorder的边框颜色
       //border.strokeColor = tagStrokeColor;
       // mx：YYTextBorder的背景填充颜色
       border.fillColor = tagFillColor;
       // mx：为什么这里圆角设置成这么大呢
       border.cornerRadius = 100; // a huge value
       // mx:路径的连接点形状, kCGLineJoinMiter(默认全部连接),kCGLineJoinRound(圆形连接),kCGLineJoinBevel(斜角连接)
       border.lineJoin = kCGLineJoinBevel;
       // mx：border内边距
       border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -5.5);
       
       // mx:第三步：给目标string的tag设置border属性
       [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
       // mx：总的字符串属性加上tag的字符串属性
       [text appendAttributedString:tagText];
    }
   
    // mx：总的字符串包裹方式
    text.yy_lineBreakMode = NSLineBreakByWordWrapping;
   
    if (self.tagTextView) {
        self.tagTextView.attributedText = text;
    }else{
        YYTextView *textView = [YYTextView new];
        textView.attributedText = text;
        textView.textContainerInset = UIEdgeInsetsMake(8, -8, 8, -8);
        textView.scrollIndicatorInsets = textView.contentInset;

        self.tagTextView = textView;
    }
    
    [self.topSecondSuperView addSubview:self.tagTextView];
    [self.tagTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameStackView.mas_left);
        make.top.equalTo(self.nameStackView.mas_bottom).offset(1);
        make.height.equalTo(@40);
        make.width.equalTo(@188);
    }];
}
```