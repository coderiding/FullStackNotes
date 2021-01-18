```objectivec
NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
        
self.rulesL.attributedText = [[NSMutableAttributedString alloc] initWithData:[m.cancel_data.cancel_text dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
```