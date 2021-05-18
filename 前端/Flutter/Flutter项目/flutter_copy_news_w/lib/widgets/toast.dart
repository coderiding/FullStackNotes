import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_copy_news_w/utils/utils.dart';

Future<bool> toastInfo({
  @required String msg,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
}) async {
  return await Fluttertoast.showToast(
    msg:msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIos: 1,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: wSetFontSize(16)
  );
}