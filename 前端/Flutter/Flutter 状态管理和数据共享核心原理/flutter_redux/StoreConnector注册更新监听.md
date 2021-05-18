StoreConnector 组件就是用来关联Store 与当前组件，当Store 发生改变的时候，接受 新的 State 

注册更新监听

* 在需要 Store 中数据的地方/页面，通过 StoreConnector 进行注册

```dart
class DemoUseStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///通过 StoreConnector 关联 GSYState 中的 User
    return new StoreConnector<GSYState, User>(
      ///通过 converter 将 GSYState 中的 userInfo返回
      converter: (store) => store.state.userInfo,
      ///在 userInfo 中返回实际渲染的控件
      builder: (context, userInfo) {
        return new Text(
          userInfo.name,
          style: Theme.of(context).textTheme.headline4,
        );
      },
    );
  }
}
```