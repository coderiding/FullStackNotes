import 'package:demo_listview/Widgets/home_page_list_item.dart';
import 'package:flutter/material.dart';

/*
  实现目标
  1、下拉刷新
  2、上拉加载更多
  3、根据请求的数据创建ListView的item个数
 */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        foregroundColor: Colors.red,
        title: Text('I am title wen'),
      ),
      backgroundColor: Colors.purple,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: _getListItemFromLocal(),
      ),
    );
  }

// 生产List item（根据本地写死的数据）
  List<Widget> _getListItemFromLocal() {
    List<Widget> items = [];
    for (var i = 0; i < 10; i++) {
      items.add(HomePageListItem(
        itemIndex: i,
        titleString: "$i",
      ));
    }
    return items;
  }

// 生产List item（根据网络请求的数据）
  List<Widget> _getListItemFromNetwork() {
    List<Widget> items = [];
    for (var i = 0; i < 10; i++) {
      items.add(HomePageListItem(
        itemIndex: i,
        titleString: "$i",
      ));
    }
    return items;
  }
}
