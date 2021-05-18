```DART
//定义
final List<Middleware<GSYState>> middleware = [
  EpicMiddleware<GSYState>(loginEpic),
  EpicMiddleware<GSYState>(userInfoEpic) ,
  EpicMiddleware<GSYState>(oauthEpic),
  UserInfoMiddleware() ,
  LoginMiddleware(),
];

//实现
class LoginMiddleware implements MiddlewareClass<GSYState> {
  @override
  void call(Store<GSYState> store, dynamic action, NextDispatcher next) {
    if (action is LogoutAction) {
      UserDao.clearAll(store);
      CookieManager().clearCookies();
      SqlManager.close();
      NavigatorUtils.goLogin(action.context);
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}