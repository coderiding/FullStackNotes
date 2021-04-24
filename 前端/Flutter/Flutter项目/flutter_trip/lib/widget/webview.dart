import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
const CATCH_URLS = ['m.ctrip.com','m.ctrip.com/','m.ctrip.com/html5','m.ctrip.com/html5/','forcelogin/'];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;
  bool exiting = false;

  @override
  _WebViewState createState() => _WebViewState();

  WebView({
    this.url,
    this.statusBarColor,
    this.title,
    this.hideAppBar,
    this.backForbid = false
  });
}

class _WebViewState extends State<WebView> {
  final webviewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChange;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  @override
  void initState() {
    super.initState();
    webviewReference.close();
    _onUrlChange = webviewReference.onUrlChanged.listen((String url) {

    });

    _onStateChanged = webviewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if (isToMain(state.url)&&!widget.exiting) {
            if (widget.backForbid) {
              webviewReference.launch(widget.url);
            }else{
              Navigator.pop(context);
              widget.exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });

    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  bool isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if(url?.endsWith(value)??false){
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    // 在页面销毁之前调用
    webviewReference.dispose();
    _onUrlChange.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }

    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff'+statusBarColorStr)),backButtonColor),
          Expanded(child: WebviewScaffold(
            url: widget.url,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: Center(
                child: Text('Waiting...'),
              ),
            ),
          ))
        ],
      ),
    );
  }

  _appBar(Color backgroundColor,Color backButtonColor) {
    if(widget.hideAppBar??false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      color: backgroundColor,
      child: FractionallySizedBox(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('我不玩了');
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned (
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title??'',
                  style: TextStyle(
                    color: backButtonColor,
                    fontSize: 20
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
