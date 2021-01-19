```objectivec
UIView *view = [[UIView alloc] init];
view.frame = CGRectMake(17.5,122.5,340,105);
view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
view.layer.shadowColor = [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:0.07].CGColor;
view.layer.shadowOffset = CGSizeMake(0,1);
view.layer.shadowOpacity = 1;
view.layer.shadowRadius = 8;
view.layer.cornerRadius = 8;
```