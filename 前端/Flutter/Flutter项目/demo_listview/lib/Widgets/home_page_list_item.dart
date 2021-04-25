import 'package:flutter/material.dart';

class HomePageListItem extends StatefulWidget {
  final int itemIndex;
  final String titleString;

  HomePageListItem({this.itemIndex, this.titleString});

  @override
  _HomePageListItem createState() => _HomePageListItem();
}

class _HomePageListItem extends State<HomePageListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, widget.itemIndex == 0 ? 8 : 4, 15, 4),
        decoration: BoxDecoration(
            color: Colors.white),
        child: GestureDetector(
            onTap: () {
              print('别点我' + '${widget.itemIndex}');
            },
            child: Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 0.5),
                    color: Colors.grey),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                            'https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/lpqgxF.png'
                        ),
                      )
                    ),
                    Text(
                      '你好',
                      style: TextStyle(backgroundColor: Colors.white),
                    )
                  ],
                ))));
  }
}
