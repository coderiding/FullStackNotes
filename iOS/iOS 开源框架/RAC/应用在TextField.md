```objectivec
//对于textFild的文字更改监听也有更简单的写法
[[self.textFild rac_textSignal] subscribeNext:^(id x) {
    NSLog(@"%@",x);
}];

//实现了一个功能，即监听了textFild的UIControlEventEditingChanged事件，当事件发生时实现方法NSLog
[[self.textFild rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x){
    NSLog(@"change");
}];
```