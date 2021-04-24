1、最外层stack，因为最后自定义的导航栏要叠加
2、第二层放MediaQuery.removePadding，因为要移除多余的像素，顶部iphonex空隙
3、第三层要放NotificationLister，因为要监听元素的滚动
4、第4层要放ListView，因为这个Widget可以滚动
5、第5层放轮播图

```DART
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
                          title: Text('哈哈'),
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
                decoration: BoxDecoration(color: Colors.white),
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
```