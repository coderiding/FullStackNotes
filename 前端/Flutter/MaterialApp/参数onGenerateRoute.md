需求：假设我们要开发一个电商APP，当用户没有登录时可以看店铺、商品等信息，但交易记录、购物车、用户个人信息等页面需要登录后才能看。为了实现上述功能，我们需要在打开每一个路由页前判断用户登录状态！如果每次打开路由前我们都需要去判断一下将会非常麻烦，那有什么更好的办法吗？答案是有！

---

MaterialApp有一个onGenerateRoute属性，它在打开命名路由时可能会被调用，之所以说可能，是因为当调用Navigator.pushNamed(...)打开命名路由时，

如果指定的路由名在路由表中已注册，则会调用路由表中的builder函数来生成路由组件；

如果路由表中没有注册，才会调用onGenerateRoute来生成路由。

#### 注意：如果需要这个方法生效，就要放弃使用路由表，是哪个界面放弃使用呢，那个登录界面吗

```DART
Route<dynamic> Function(RouteSettings settings)

MaterialApp(
  ... //省略无关代码
  onGenerateRoute:(RouteSettings settings){
	  return MaterialPageRoute(builder: (context){
		   String routeName = settings.name;
       // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
       // 引导用户登录；其它情况则正常打开路由。
     }
   );
  }
);
```