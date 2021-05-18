```dart
final List<Middleware<GSYState>> middleware = [
  EpicMiddleware<GSYState>(loginEpic),
  EpicMiddleware<GSYState>(userInfoEpic),
  EpicMiddleware<GSYState>(oauthEpic),
  UserInfoMiddleware(),
  LoginMiddleware(),
];

```

* 拦截器顾名思义就是拦截消息是否再往下传递
* 可以看到 GSYGitHubApp 中设置了 5 个拦截器， 如果均满足其中的筛选条件，就可以进行后续的 UI 刷新操作
* 就比如第一个‘登录’，如果用户没登录，自然不用再往后了，按照 app 设计的逻辑，这时需要先跳转登录才行