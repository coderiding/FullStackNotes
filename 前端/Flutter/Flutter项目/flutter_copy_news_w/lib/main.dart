import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_copy_news_w/provider/app.dart';
import 'package:provider/provider.dart';

import 'global.dart';

// 是否开发环境
bool get isInDebugMode {
  return false;
}

// 上报异常函数
Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  if (isInDebugMode) {
    print(stackTrace);
  } else {
    // Sentrty
  }
}

Future<Null> main() async {
  // 捕获并上报 Flutter 异常
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode == true) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // 捕获并上报 Dart异常
  runZonedGuarded(() async {
    await Global.init();
    runApp(
      MultiProvider(
        child: Consumer<AppState>(builder: (context, appState, _) {
          if (appState.isGrayFilter) {
            return ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.color),
              child: NewsApp(),
            );
          } else {
            return NewsApp();
          }
        }),
      ),
    );
  }, (Object error, StackTrace stack) {
    _reportError(error, stack);
  });
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'w.copy.news',
      debugShowCheckedModeBanner: false,
    );
  }
}
