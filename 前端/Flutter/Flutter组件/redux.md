 flutter-redux 具备除了redux的所有能力之外，针对UI层专门提供了StoreProvider、StoreConnector、StoreBuilder等相应的操作组件，这大大简化了我们在flutter中使用redux的成本。

<img src='https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/TgIkgU.png' alt='TgIkgU'/>


### 
使用 redux 管理 flutter 应用数据
https://riskers.github.io/flutter-notebook/advanced/redux.html  https://app.yinxiang.com/shard/s35/nl/9757212/e93db346-ae95-487d-ba93-1867d7a04845


Widget 绑定 Store 中的 state
Widget 触发某个 Action
Reducer 根据某个 Action 触发更新 state
更新 Store 中 state 绑定的 Widget

Redux 主要由三个部分组成：Store，Action，Reducer

Action 用于定义数据变化的行为（至少在语义上我们应该定义明确的行为）
Reducer 用于根据 Action 来产生新的状态
Store 用于存储和管理 state

使用 StoreConnector 它会将更新后的数据 callback 给你

中间件类似拦截器。比如当前是添加用户动作，但是我想在添加用户这操作的前面再做一步其他的动作，这时候就可以使用中间件middleware，实现 MiddlewareClass 该类就行。

https://zhuanlan.zhihu.com/p/55587462

### 介绍中间件

https://blog.csdn.net/xcf111/article/details/93930135   https://app.yinxiang.com/shard/s35/nl/9757212/ec46eecb-6dd1-49e6-9804-17ead2896999


### 获取 state
```DART
// 所有的数据都会包在state里面，就是创建store时的initstate中
StoreProvider.of(context).state.
```

https://jszoo.com/detail/20#heading-0

### 使用场景1

用户退出登录，触发sotre.dispatch，触发的是LogoutAction，最后实际上就是到了_logoutResult这个方法

```dart
store.dispatch(LogoutAction(context));

class LogoutAction {
  final BuildContext context;

  LogoutAction(this.context);
}

final LoginReducer = combineReducers<bool?>([
  TypedReducer<bool?, LoginSuccessAction>(_loginResult) ,
  TypedReducer<bool?, LogoutAction>(_logoutResult),
]);

bool? _logoutResult(bool? result, LogoutAction action) {
  return true;
}