https://book.flutterchina.club/chapter7/inherited_widget.html   https://app.yinxiang.com/shard/s35/nl/9757212/b9bbfcb4-9efc-42f6-aa23-91acbcec4e6f

InheritedWidget是Flutter中非常重要的一个功能型组件，它提供了一种数据在widget树中从上到下传递、共享的方式，比如我们在应用的根widget中通过InheritedWidget共享了一个数据，那么我们便可以在任意子widget中来获取该共享的数据！

比如我们在应用的根widget中通过InheritedWidget共享了一个数据，那么我们便可以在任意子widget中来获取该共享的数据！

如Flutter SDK中正是通过InheritedWidget来共享应用主题（Theme）和Locale (当前语言环境)信息的。

InheritedWidget的在widget树中数据传递方向是从上到下的

```DART
class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({
    @required this.data,
    Widget child
  }) :super(child: child);
    
  final int data; //需要在子树中共享的数据，保存点击次数
    
  //定义一个便捷方法，方便子树中的widget获取共享数据  
  static ShareDataWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget  
  @override
  bool updateShouldNotify(ShareDataWidget old) {
    //如果返回true，则子树中依赖(build函数中有调用)本widget
    //的子widget的`state.didChangeDependencies`会被调用
    return old.data != data;
  }
}
```