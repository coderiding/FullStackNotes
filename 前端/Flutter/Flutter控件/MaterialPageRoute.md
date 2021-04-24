```dart
MaterialPageRoute(builder: (context) {
    CommonModel mode = bannerList[index];
    return WebView(url: mode.url,title: mode.title,hideAppBar: mode.hideAppBar,);
})

// 写法2
// 没有大括号，用箭头函数直接代替，适合只有一句表达式的情况
MaterialPageRoute(builder: (context) => 
    return WebView(url: mode.url,title: mode.title,hideAppBar: mode.hideAppBar,);
)
```                                        