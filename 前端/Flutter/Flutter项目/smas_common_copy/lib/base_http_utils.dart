import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smas_common_copy/common_global.dart';
import 'package:smas_common_copy/config_reader.dart';
import 'package:smas_common_copy/generated/i18n.dart';
import 'package:http/io_client.dart';

class DioHttpUtils {
  BuildContext context;
  Options _options;
  String client_id = ConfigReader.getConfig()['main_client_id'];
  String client_secret = ConfigReader.getConfig()['main_client_secret'];
  static bool _certificateCheck(X509Certificate, String host, int port) => true;
  static Map<String, dynamic> headers;

  static Future<void> initDio() async {
    headers = {
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.connectionHeader: 'keep-alive',
      HttpHeaders.setCookieHeader: 'android framework request',
      'AndroidRequest': Global.isAndroid(),
      'DeviceInfo': Global.getDeviceUniqueId(),
      'PackageName': Global.getPackageInfo().packageName,
      'ApplicationId': Global.getPackageInfo().packageName,
      'X-Requested-With': 'XMLHttpRequest',
    };
  }

  static Dio getInstance() {
    Dio dio = new Dio(
      BaseOptions(baseUrl: ConfigReader.getConfig()['main_base_url']),
    );
    dio.options.headers = Map.from(headers ?? {});
    dio.options.headers[HttpHeaders.authorizationHeader] =
        Global.getPreference().getString(Global.KEY_TOKEN);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        if (!Global.isRelease) {
          print('url============${options.uri}');
          print("headers=============${options.headers}");
          print("params=============${options.queryParameters}");
        }
      },
      onResponse: (e) {
        if (!Global.isRelease) {
          print('response===============$e');
        }
      },
      onError: (e) {
        if (!Global.isRelease) {
          print('error==========$e');
        }
      },
    ));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };
    return dio;
  }

  Future refreshToken(String token) async {
    Response response = null;
    Map result = {};
    try {
      response = await getInstance().get('',
          queryParameters: {
            'grant_type': 'refresh_token',
            'refresh_token': token
          },
          options: new RequestOptions(
              baseUrl: ConfigReader.getConfig()['main_login_url'],
              headers: {
                HttpHeaders.authorizationHeader: 'Basic' +
                    base64Encode(utf8.encode('$client_id:$client_secret'))
              }));
    } catch (e) {
      DioError error = e;
      if (error.response.statusCode == 443 ||
          error.response.statusCode == 400) {}
    }
    if (response != null) {
      if (response.statusCode == 200) {
        result = response.data;
      }
    }
    return result;
  }

  DioHttpUtils([this.context]) {
    _options = Options(extra: {'context': context});
  }

  void checkStatusCode(int statusCode) {
    if (statusCode == 401 || statusCode == 403 || statusCode == 302) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(I18n.of(context).main_system_message),
              content: StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Text(I18n.of(context).main_token_expiry),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    backToLogin();
                  },
                  child: Text(I18n.of(context).main_update_yes),
                )
              ],
            );
          });
    }
  }

  void dismissDialog() {
    Navigator.of(context).pop();
  }

  void backToLogin() {
    Global.getPreference().clear();
    //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => ))
  }

  static void initInterceptor() {}

  static IOClient iOClientignoreCertificateClient() {
    var iOClient = new HttpClient()..badCertificateCallback = _certificateCheck;
    return new IOClient(iOClient);
  }
}
