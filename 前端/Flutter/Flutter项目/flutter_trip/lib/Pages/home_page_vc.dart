import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/home_model.dart';
const APPBAR_SCROLL_OFFSET = 100;

class HomePageVC extends StatefulWidget {
  @override
  _HomePageVC createState() => _HomePageVC();

}

class _HomePageVC extends State<HomePageVC> {
  List _imageURL = ['https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/VFLCQW.png',
  'https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/dELDsF.png',
  'https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/6xnaif.png'];

  double appBarAlpha = 0;
  String resultString = "";


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        resultString = json.encode(model.config);
      });
    } catch (e) {
      setState(() {
        resultString = e.toString();
      });
    }
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
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child:NotificationListener(
                  onNotification: (scrollNotification){
                    if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                      _scroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 160,
                        child: Swiper(
                          onTap: (index){
                            print(index);
                          },
                          itemCount:_imageURL.length,
                          itemBuilder: (BuildContext context,int index){
                            return Image.network(
                              _imageURL[index],
                              fit: BoxFit.fill,
                            );
                          },
                          autoplay: true,
                          pagination: SwiperPagination(

                          ),
                        ),
                      ),
                      Container(
                        height: 800,
                        child: ListTile(
                          title: Text(resultString),
                        ),
                      )
                    ],
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
    );
  }

}