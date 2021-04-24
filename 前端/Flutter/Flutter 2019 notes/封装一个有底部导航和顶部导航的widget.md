```Dart
class RootScene extends StatefulWidget {
  // mx:这里是固定写法
  @override
  State<StatefulWidget> createState() => RootSceneState();
}

class RootSceneState extends State<RootScene> {
  int currentSelectTabIndex = 0;
  bool isFinishSetup = false;
  
  // mx：底部tabbar点击的图片
  List<Image> tabNormalImages = [
    Image.asset('img/tab_bookshelf_n.png'),
    Image.asset('img/tab_bookstore_n.png'),
    Image.asset('img/tab_me_n.png'),
  ];

  List<Image> tabSelectedImages = [
    Image.asset('img/tab_bookshelf_p.png'),
    Image.asset('img/tab_bookstore_p.png'),
    Image.asset('img/tab_me_p.png'),
  ];

  @override
  Widget build(BuildContext context) {
    if (!isFinishSetup) {
      return Container();
    }

    // mx：这里的Scaffold就写了body和底部导航条bottomNavigationBar
    return Scaffold(
      // mx：首页app需要显示的内容，放到body里面
      body: IndexedStack(
        // mx：首页app的子widget
        children: <Widget>[
          // mx：子widget-1，按顺序展示
          BookshelfScene(),
          // mx：子widget-2，按顺序展示
          HomeScene(),
          // mx：子widget-3，按顺序展示
          MeScene(),
        ],
        // mx：显示内容是哪个tab的内容，可能和底部导航条的可以不一样，已实验过可以不一样
        index: currentSelectTabIndex,
      ),
      
      // mx：底部的tabbar导航条
      bottomNavigationBar: CupertinoTabBar(
        // mx：底部的tabbar导航条背景色
        backgroundColor: Colors.white,
        activeColor: SQColor.primary,
        // mx:这里总共3个tab，使用了系统默认的封装的tab，还可以使用自定义的tab
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: getTabIconImage(0), title: Text('书架')),
          BottomNavigationBarItem(icon: getTabIconImage(1), title: Text('书城')),
          BottomNavigationBarItem(icon: getTabIconImage(2), title: Text('我的')),
        ],
        // mx：底部的tabbar导航条当前选中的tab的index，通过改变这个，可以设置app启动时默认选中哪个tab
        currentIndex: currentSelectTabIndex,
        // mx：底部的tabbar导航条的tab被选中，每次点击需要调用setState方法才会刷新数据
        onTap: (index) {
          setState(() {
            currentSelectTabIndex = index;
          });
        },
      ),
    );
  }

  // mx:初始化数据用的，必须通过initState方法
  @override
  void initState() {
    super.initState();

    loadAppData();

    // eventBus有什么用呢
    eventBus.on(EventUserLogin, (arg) {
      setState(() {});
    });

    eventBus.on(EventUserLogout, (arg) {
      setState(() {});
    });

    eventBus.on(EventToggleTabBarIndex, (arg) {
      setState(() {
        currentSelectTabIndex = arg;
      });
    });
  }

  void loadAppData() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      isFinishSetup = true;
    });
  }

  // mx:返回值是Image
  Image getTabIconImage(int index) {
    if (index == currentSelectTabIndex) 
    {
      return tabSelectedImages[index];
    } else {
      return tabNormalImages[index];
    }
  }

  // mx：销毁数据用的，为什么super.dispose();要放在最后呢
  @override
  void dispose() {
    eventBus.off(EventUserLogin);
    eventBus.off(EventUserLogout);
    eventBus.off(EventToggleTabBarIndex);

    super.dispose();
  }

}
```