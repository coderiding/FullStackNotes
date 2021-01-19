```objectivec
//UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有标题的标题"
                                                                             message:@"学无止境，漫漫长路"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
```

```objectivec
UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"今天去谁家蹭饭呢"
                                                                             message:@"😄😄😄\n话说可以去好多好多妹纸家里蹭饭"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    UIAlertAction *home1Action = [UIAlertAction actionWithTitle:@"去小红家" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:home1Action];
    UIAlertAction *home2Action = [UIAlertAction actionWithTitle:@"去小兰家" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:home2Action];
    UIAlertAction *home3Action = [UIAlertAction actionWithTitle:@"去小花家" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:home3Action];
    UIAlertAction *home4Action = [UIAlertAction actionWithTitle:@"去小娇家" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:home4Action];
    
    //取消style:UIAlertActionStyleDefault
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消（回家）" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
```