import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlertDialog(BuildContext context,title,contenText,positiveSelected,negativeSelected,{bool showCancel = true,bool canDismiss = false}) {
  Widget cancelButton = Visibility(
      visible: showCancel,
      child: TextButton(
        child: Text('取消'),
        onPressed: (){
          negativeSelected();
        },
      )
  );

  Widget confirmButton = TextButton(
      onPressed: (){
        positiveSelected();
      },
      child: Text('確認'),
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(contenText),
    actions: [
      cancelButton,
      confirmButton,
    ],
  );

  showDialog(
    barrierDismissible: canDismiss,
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showLoadingDialog(BuildContext context,{String msg = '加載中，請稍後...'}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                  child: Text(msg),
                )
              ],
            ),
          ),
        );
      }
  );
}

