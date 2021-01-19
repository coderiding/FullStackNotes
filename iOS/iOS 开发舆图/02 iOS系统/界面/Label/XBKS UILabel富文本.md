```objectivec
- (void)decorationDataL {
    NSString *str = @"03/2020";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:18.0f]
                    range:NSMakeRange(0, str.length)];
    
    NSRange fRange = NSMakeRange(0, 2);
    NSRange lRange = NSMakeRange(str.length-5, 5);
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor qmui_colorWithHexString:@"#41C822"]
                    range:fRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor qmui_colorWithHexString:@"#313133"]
                    range:lRange];
    
    self.dateL.attributedText = attrStr;
}

- (void)decorationOrderCountL {
    NSString *str = @"378单";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange fRange = NSMakeRange(0, str.length-1);
    NSRange lRange = NSMakeRange(str.length-1, 1);
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:18.0f]
                    range:fRange];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15.0f]
                    range:lRange];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor qmui_colorWithHexString:@"#36BCFF"]
                    range:fRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor qmui_colorWithHexString:@"#313133"]
                    range:lRange];
    
    self.orderCountL.attributedText = attrStr;
}

- (void)decorationIncomeL {
    NSString *str = @"200000元";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange fRange = NSMakeRange(0, str.length-1);
    NSRange lRange = NSMakeRange(str.length-1, 1);
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:18.0f]
                    range:fRange];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15.0f]
                    range:lRange];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor qmui_colorWithHexString:@"#FF6600"]
                    range:fRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor qmui_colorWithHexString:@"#313133"]
                    range:lRange];
    
    self.incomeL.attributedText = attrStr;
}
```