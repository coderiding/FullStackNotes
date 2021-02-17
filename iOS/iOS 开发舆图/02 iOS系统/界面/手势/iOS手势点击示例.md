# iOS手势点击示例

```
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBeginDate:)];
self.beginView.userInteractionEnabled = YES;
[self.beginView addGestureRecognizer:tap];


UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeEndDate:)];
self.endView.userInteractionEnabled = YES;
[self.endView addGestureRecognizer:tap2];

- (void)changeBeginDate:(UITapGestureRecognizer *)recognizer {

}

- (void)changeEndDate:(UITapGestureRecognizer *)recognizer {

}
```

## 点击手势
```
addGesture(ss: #selector(tapLocation), v: locateImageV) 

func addGesture(ss:Selector,v:UIView) 
{ 
   let t = UITapGestureRecognizer(target:self, action:ss) 
   t.numberOfTapsRequired = 1 
   t.numberOfTouchesRequired = 1 
   v.addGestureRecognizer(t) 
} 

@objc public func tapLocation(){ 
    
} 
```

## 给UIView添加点击事件
```
//The setup code (in viewDidLoad in your view controller)
UITapGestureRecognizer *singleFingerTap =  [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSingleTap:)]; 

[self.view addGestureRecognizer:singleFingerTap];



// The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

  CGPoint location = [recognizer locationInView:[recognizer.view superview]];

  //Do stuff here...
}
```