import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';
const APPBAR_SCROLL_OFFSET = 100;

class HomePageVC extends StatefulWidget {
  @override
  _HomePageVCState createState() => _HomePageVCState();

}

class _HomePageVCState extends State<HomePageVC> {
  double appBarAlpha = 0;
  String resultString = "";
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

   Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        bannerList = model.bannerList;
        gridNavModel = model.gridNav;
        salesBoxModel = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  _scroll(offset) {
    double alpha = offset/APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    }else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(isLoading: _loading,
        child: Scaffold(
          body: Center(
              child: Stack(
                children: <Widget>[
                  MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: NotificationListener(
                          onNotification: (scrollNotification){
                            if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                              _scroll(scrollNotification.metrics.pixels);
                            }
                          },
                          child: _listView,
                        ),
                      )
                  ),
                  Opacity(
                    opacity: appBarAlpha,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(color: Colors.green),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('首页'),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        )
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        Container(
          height: 160,
          child: Swiper(
            onTap: (index){
              print(index);
            },
            itemCount:bannerList.length,
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                onTap: (){
                  print(Scaffold.of(context));
                  print(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        CommonModel mode = bannerList[index];
                        return WebView(url: mode.url,title: mode.title,hideAppBar: mode.hideAppBar,);
                      })
                  );
                },
                child: Image.network(
                  bannerList[index].icon,
                  fit: BoxFit.fill,
                ),
              );
            },
            autoplay: true,
            pagination: SwiperPagination(

            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: LocalNav(localNavList: localNavList,),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: GridNav(gridNavModel: gridNavModel,),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: SubNav(subNavList: subNavList,),
        ),
        SalesBox(salesBox: salesBoxModel,),
        Container(
          height: 800,
          child: ListTile(
            title: Text(resultString),
          ),
        )
      ],
    );
  }

}