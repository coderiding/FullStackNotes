```objectivec
self.view.userInteractionEnabled = YES;

UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];  
[[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
    LxDBAnyVar(tap);
}];

[self.view addGestureRecognizer:tap];
```