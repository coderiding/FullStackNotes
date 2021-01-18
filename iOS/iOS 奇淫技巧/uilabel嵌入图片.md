![https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/pTYor2.png](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/pTYor2.png)

```objectivec
NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
attachment.image = [UIImage imageNamed:@"MyIcon.png"];

NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];

NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@"My label text"];
[myString appendAttributedString:attachmentString];

myLabel.attributedText = myString;
```

### 让图片居中

```objectivec
- (NSAttributedString *)getProviderMoney {
    BOOL hasYiJia = self.m.subsidy_price_text.length > 0;
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = hasYiJia ? [UIImage imageNamed:@"icon_question"]:nil;
    attachment.bounds = CGRectMake(6, self.moneL.font.descender, attachment.image.size.width, attachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];

    NSString *mS = [NSString stringWithFormat:@"￥%.2f",self.m.provider_take_money];
    NSString *subSt = hasYiJia ? [NSString stringWithFormat:@"（%@）",self.m.subsidy_price_text]:@"";
    NSString *res = [NSString stringWithFormat:@"%@%@",mS,subSt];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:res];
    
    NSRange lastRange = NSMakeRange(mS.length, res.length-mS.length);
    
    [myString addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"PingFang SC" size: 13]
                    range:lastRange];
    [myString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor mx_hexStr:@"#9F9F9F"]
                    range:lastRange];
    
    [myString appendAttributedString:attachmentString];

    return myString;
}
```