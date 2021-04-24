import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/webview.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBox;

  const SalesBox({Key key, @required this.salesBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: _items(context),
    );
  }
  
  _items(BuildContext context) {
    if (salesBox == null) return null;
    List<Widget> items = [];
    items.add(_doubleItem(context, salesBox.bigCard1, salesBox.bigCard2, true, false));
    items.add(_doubleItem(context, salesBox.smallCard1, salesBox.smallCard2, false, false));
    items.add(_doubleItem(context, salesBox.smallCard3, salesBox.smallCard4, false, true));

    return Column(
      children: <Widget>[
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.8,color: Color(0xfff2f2f2)))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.network(salesBox.icon,
                height: 15,
                fit: BoxFit.fill,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(colors: [Color(0xffff4e63),Color(0xffff6cc9)],
                  begin: Alignment.centerLeft,// 从左到右线性渐变
                  end: Alignment.centerRight)
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                        WebView(url: salesBox.moreUrl,title: '更多活动',)
                      )
                    );
                  },
                  child: Text(
                    '获取更多福利 >',
                    style: TextStyle(color: Colors.white,fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0,1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1,2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2,3),
        )
      ],
    );
  }

  Widget _doubleItem(BuildContext context,CommonModel leftCard,CommonModel rightCard,bool big,bool last) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _item(context, leftCard, true, last,big),
        _item(context, rightCard, false, last,big)
      ],
    );

  }

  Widget _item(BuildContext context,CommonModel model,bool left,bool last,bool big) {
    BorderSide borderSide = BorderSide(width: 0.8,color: Color(0xfff2f2f2));
    return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    WebView(url: model.url,title:model.title,statusBarColor: model.statusBarColor,hideAppBar: model.hideAppBar,)
                )
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(right: left? borderSide:BorderSide.none)
            ),
            child: Image.network(
              model.icon,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width/2-10,// 屏幕宽度
              height: big?129:60,
            ),
          )
    );
  }

}