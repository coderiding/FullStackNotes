 ```
    UILabel *leftMobileTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];

    leftMobileTitleLab.text=@"联系商家";

    leftMobileTitleLab.textAlignment=NSTextAlignmentCenter;

    //创建富文本

    NSMutableAttributedString*attri1 = [[NSMutableAttributedString alloc]initWithString:@"联系商家"]; 
    //NSTextAttachment可以将要插入的图片作为特殊字符处理

    NSTextAttachment*attch1 = [[NSTextAttachment alloc]init];
    attch1.image= [UIImage imageNamed:@"contact"];
    attch1.bounds=CGRectMake(0, -5,20,20);
    NSAttributedString*string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    //将图片放在第一位
    [attri1 insertAttributedString:string1 atIndex:0];
    leftMobileTitleLab.attributedText= attri1;
```