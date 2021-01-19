```objectivec
UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //取消:style:UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    //了解更多:style:UIAlertActionStyleDestructive
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"了解更多" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:moreAction];
    //原来如此:style:UIAlertActionStyleDefault
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"打给商家" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
```

```objectivec
UIAlertAction *alertAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
}];
```