import 'package:flutter/material.dart';

class SearchPageVC extends StatefulWidget {
  @override
  _SearchPageVCStatues createState() => _SearchPageVCStatues();

}

class _SearchPageVCStatues extends State<SearchPageVC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('搜索'),
      ),
    );
  }

}