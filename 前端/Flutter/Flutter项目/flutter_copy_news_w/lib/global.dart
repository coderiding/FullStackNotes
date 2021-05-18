import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'entitys/entitys.dart';

class Global {
  /// 用戶配置
  static UserLoginResponseEntity profile = UserLoginResponseEntity(accessToken: null);

  /// 是否是iOS
  static bool isIOS = Platform.isIOS;

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment('dart.vm.product');

  /// init
  static Future init() async {
    // 运行开始
    WidgetsFlutterBinding.ensureInitialized();
  }
}