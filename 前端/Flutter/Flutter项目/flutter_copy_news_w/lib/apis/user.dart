import 'package:flutter/material.dart';
import 'package:flutter_copy_news_w/entitys/entitys.dart';
import 'package:flutter_copy_news_w/utils/http.dart';

class UserApi {
  /// 登錄
  static Future<UserLoginResponseEntity> login({
    @required BuildContext context,
    UserLoginRequestEntity params,
  }) async {
    var response =
        await HttpUtil().post('/user/login', context: context, params: params);
    return UserLoginResponseEntity.fromJson(response);
  }

  /// 登出
  static Future<void> logout({
    @required BuildContext context,
  }) async {
    var response = await HttpUtil().post('/user/logout', context: context);
  }
}
