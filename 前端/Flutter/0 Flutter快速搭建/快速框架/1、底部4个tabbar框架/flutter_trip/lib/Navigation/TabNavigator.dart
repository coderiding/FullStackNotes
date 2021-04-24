import 'package:flutter/material.dart';
import 'package:flutter_trip/Pages/HomePageVC.dart';
import 'package:flutter_trip/Pages/MyPageVC.dart';
import 'package:flutter_trip/Pages/SearchPageVC.dart';
import 'package:flutter_trip/Pages/TravelPageVC.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorStatues createState() => _TabNavigatorStatues();

}

class _TabNavigatorStatues extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _pvc = new PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pvc,
        children: <Widget>[
          HomePageVC(),
          SearchPageVC(),
          TravelPageVC(),
          MyPageVC()
        ],
      ),
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _pvc.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });

          },
          type: BottomNavigationBarType.fixed,
          items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,color: _defaultColor),
              activeIcon: Icon(Icons.home,color: _activeColor,),
              label: '首页',),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,color: _defaultColor,),
              activeIcon: Icon(Icons.search,color: _activeColor,),
              label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.traffic,color: _defaultColor,),
          activeIcon: Icon(Icons.traffic,color: _activeColor,),
          label: '旅游'),
          BottomNavigationBarItem(icon: Icon(Icons.person,color: _defaultColor,),
          activeIcon: Icon(Icons.person,color: _activeColor,),
          label: '我的')
        ],
          
        )
    );
  }

}