# 换肤：DKNightVersion

使用：[https://github.com/draveness/DKNightVersion/](https://github.com/draveness/DKNightVersion/)
百度网盘备份：
1585967854

- [使用DKNightVersion实现夜间模式 - 简书](https://www.notion.so/%E7%99%BE%E5%BA%A6%E7%BD%91%E7%9B%98-1588819004) 链接:[https://pan.baidu.com/s/1dYGvWsGKw3sdmUvszyeYCg](https://pan.baidu.com/s/1dYGvWsGKw3sdmUvszyeYCg) 密码:tq7k
- [(13条消息)DKNightVersion框架的原理和使用_移动开发_weixin_35755389的博客-CSDN博客](https://www.notion.so/%E7%99%BE%E5%BA%A6%E7%BD%91%E7%9B%98-1588819602) 链接:[https://pan.baidu.com/s/1Uj8WexQ44V5jRAjROAztyg](https://pan.baidu.com/s/1Uj8WexQ44V5jRAjROAztyg) 密码:qe6s

```
pod "DKNightVersion"
#import <DKNightVersion/DKNightVersion.h>

//Checkout DKColorTable.txt file in your project, which locates in Pods/DKNightVersion/Resources/DKNightVersion.txt.

NORMAL   NIGHT
#ffffff  #343434 BG
#aaaaaa  #313131 SEP
//You can also create another colour table file, and specify it with DKColorTable.

A, set color picker like this with DKColorPickerWithKey, which generates a DKColorPicker block

self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
//After the current theme version change to DKThemeVersionNight, the view background colour would switch to #343434.

[DKNightVersionManager nightFalling];
Alternatively, you could change the theme version by manager's property themeVersion which is a string

DKNightVersionManager *manager = [DKNightVersionManager sharedInstance];
manager.themeVersion = DKThemeVersionNormal;

```

---

[https://github.com/draveness/analyze/blob/master/contents/DKNightVersion/成熟的夜间模式解决方案.md](https://github.com/draveness/analyze/blob/master/contents/DKNightVersion/%E6%88%90%E7%86%9F%E7%9A%84%E5%A4%9C%E9%97%B4%E6%A8%A1%E5%BC%8F%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.md)

[https://github.com/draveness/DKNightVersion/](https://github.com/draveness/DKNightVersion/)

[https://github.com/draveness/DKNightVersion/issues](https://github.com/draveness/DKNightVersion/issues)

- 【mx：】思路
- 有一个DKImagePicker
- 有一个DKColorPicker
- 1.给常用需要换肤的控件，添加picker属性，这个属性可以是DKImagePicker或者DKColorPicker，具体看控件需要什么，这个属性包含主题的颜色，可以有n中颜色，或者包含图片，各种主题下的图片

---

- 有一个DKImagePicker
- 在需要更新主题图片的时候，调用这个类，读取配置表中的当前主题图片，进行更新主题图片
- picker里面有一个键值对，key存放要操作的sel，value存放的是picker对象

---

- 有一个DKColorPicker
- 在需要更新主题颜色的时候，调用这个类，读取配置表中的当前主题色，进行更新主题
- picker里面有一个键值对，key存放要操作的sel，value存放的是picker对象

---

- 有一个DKAlphaPicker
- 在需要更新主题透明度的时候，调用这个类，读取配置表中的主题透明度，更新主题
- picker里面有一个键值对，key存放要操作的sel，value存放的是picker对象

---

- 第一步：调用DKNightVersionManager类的setThemeVersion触发改变主题，当前的主题名字已经通过NSUserDefaults设置改变，然后发出通知DKNightVersionThemeChangingNotification
- 第二步：有接收DKNightVersionThemeChangingNotification通知的地方有：NSObject+Night 这个分类，这个分类收到通知，调用night_updateColor更新主题，night_updateColor会遍历pickers属性，执行里面的key，就是sel，里面的value就是主题type，然后控件就会执行sel方法，重设主题色或图片。通过type就可以取出属性值；具体的取值过程是，遍历pickers舒心个，执行里面的key，就是sel，然后sel里面会通过picker对象，往这个对象传入主题版本，从而得到要的属性值，然后赋值给控件。下面的代码就是一个sel，里面就是通过给picker对象传入self.dk_manager.themeVersion获取属性值，赋值给控件的highlightedTextColor
- (void)dk_setHighlightedTextColorPicker:(DKColorPicker)picker {
objc_setAssociatedObject(self, @selector(dk_highlightedTextColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
self.highlightedTextColor = picker(self.dk_manager.themeVersion);
[self.pickers setValue:[picker copy] forKey:@"setHighlightedTextColor:"];
}
- 【重写night_updateColor更新方法】这是NSObject+Night分类收到通知后，需要用super继承父类的更新方法，有通过NSObject+Night分类的，override更新方法的，比如UISearchBar+Keyboard分类，修改键盘弹出时候的UI主题，一旦切换主题，NSObject+Night分类会收到通知，UISearchBar+Keyboard重写了NSObject+Night分类中的更新方法，所以会使用UISearchBar+Keyboard中的更新方法。类似这种情况还有UITextField+Keyboard分类、UITextView+Keyboard分类，参考下面的代码
- (void)night_updateColor {
[super night_updateColor];
if (self.dk_manager.supportsKeyboard && [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
#ifdef __IPHONE_7_0
self.keyboardAppearance = UIKeyboardAppearanceDark;
#else
self.keyboardAppearance = UIKeyboardAppearanceAlert;
#endif
} else {
self.keyboardAppearance = UIKeyboardAppearanceDefault;
}
}
- 【重写night_updateColor更新方法】这是NSObject+Night分类收到通知后，不需要用super继承父类的更新方法，在UIButton+Night分类，因为UIButton需要修改图片和文字颜色，像这种情况还有UIImageView+Night分类，参考下面的UIImageView+Night分类代码，还可以参考UIButton+Night分类
- (void)night_updateColor {
[self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
if ([key isEqualToString:@"setAlpha:"]) {
DKAlphaPicker picker = (DKAlphaPicker)obj;
CGFloat alpha = picker(self.dk_manager.themeVersion);
[UIView animateWithDuration:DKNightVersionAnimationDuration
animations:^{
((void (*)(id, SEL, CGFloat))objc_msgSend)(self, NSSelectorFromString(key), alpha);
}];
} else {
SEL sel = NSSelectorFromString(key);
DKColorPicker picker = (DKColorPicker)obj;
UIColor *resultColor = picker(self.dk_manager.themeVersion);
[UIView animateWithDuration:DKNightVersionAnimationDuration
animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
[self performSelector:sel withObject:resultColor];
#pragma clang diagnostic pop
}];

    ```
      }

    ```

    }];
    }

---

- mx： NSObject+Night配置的是通知自动更新主题的代码，全部是针对color修改，如果要修改image，需要手动配置update代码，通过在分类NSObject+Night写update代码，主要是为了节省代码量

这个库可以实现我们当前的大多数的需求，目前这个库还不能比较方便的解决富文本的不同主题的不同样式问题，我们可以参照它的实现给需要使用富文本的控件添加DKNightVersionThemeChangingNotification监听，从而根据不同的Theme做出不同的展现，这个思路当然也可以拓展到其他地方，虽然会造成比较强的耦合关系，如不同主题下的不同样式的展现等等。
鉴于当前Theme的管理方式，而且DKColorPicker用DKColorPickerWithKey()以外的其他方法创建传入的数值并非动态的，所以以后增加Theme时可能会比较棘手。作者不推荐我们手动创建DKColorPicker,而推荐使用DKColorTable.txt 来进行主题管理， 这样DKColorPicker中包含的色值由DKColorTable.txt中的配置决定，这样会更加方便。
它不仅仅支持原生的backgroundColor，tintColor等属性，可以给自定义的控件添加一个你想要的的color/image属性，例如pressedColor，在不同的主题做出不同的展现。
这个库的一个比较好的实现我觉得是把Block当做一个属性赋值给对象而不是存储一个数组或字典，然后根据其他变量的变化做出响应的一个思路。
使用的时候我们自己新建一个theme_color_table.txt文件，然后在appdelegate调用[[DKColorTable sharedColorTable] setFile:@"theme_color_table.txt"]; 注意如果使用系统自带的编辑软件编辑theme_color_table.txt 的话，可能会出现空格导致崩溃而且一般看不出来，最好用专用的文字编辑软件去添加新的配置。

作者：HiIgor
链接：[https://www.jianshu.com/p/bae45500366b](https://www.jianshu.com/p/bae45500366b)
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。