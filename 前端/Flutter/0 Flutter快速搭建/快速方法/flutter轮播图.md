```dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePageVC extends StatefulWidget {
  @override
  _HomePageVC createState() => _HomePageVC();

}

class _HomePageVC extends State<HomePageVC> {
  List _imageURL = ['https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/VFLCQW.png',
  'https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/dELDsF.png',
  'https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/6xnaif.png'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
            )
          ],
        ),
      ),
    );
  }

}
```