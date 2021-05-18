import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:smas_acs_copy/models/qr_result.dart';
import 'package:smas_acs_copy/models/worker.dart';
import 'package:smas_common_copy/base_http_utils.dart';
import 'package:smas_common_copy/common_global.dart';
import 'package:smas_common_copy/config_reader.dart';

class AcsHttpUtils {
  Dio dio;
  BuildContext context;
  String androidRequest;

  AcsHttpUtils([this.context]) {

  }

  void addHeaders() {
    if (dio == null) {
      dio = new Dio(BaseOptions(
        baseUrl: ConfigReader.getConfig()['acs_api_url'],
      ));
    }
    initInterceptor();

    dio.options.headers = {
      HttpHeaders.acceptHeader: '*/*',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.connectionHeader: 'keep-alive',
      HttpHeaders.setCookieHeader: 'android framework request',
      'AndroidRequest': Global.isAndroid(),
      'DeviceInfo': Global.getDeviceUniqueId(),
      'PackageName': Global.getPackageInfo().packageName,
      'ApplicationId': Global.getPackageInfo().packageName,
      'X-Requested-With': 'XMLHttpRequest',
      HttpHeaders.authorizationHeader: Global.getToken()
    };
  }

  void initInterceptor() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        if (!Global.isRelease) {
          print('url========${options.uri}');
          print('headers======${options.headers}');
          print('params=======${options.queryParameters}');
        }
      },
      onResponse: (e) {
        if (!Global.isRelease) {
          print('response=====$e');
        }
      },
      onError: (e) {
        if (!Global.isRelease) {
          print('error=====$e');
        }
      },

    ));
  }

  void dismissDialog() {
    Navigator.of(context).pop();
  }

  Future<QrResult> saveAttendance(
      String smartCardId,
      String chineseName,
      String englishName,
      String siteId,
      String connectionId) async
  {
    var result;
    try {
      result = await dio.post('/attendance/save',queryParameters: {
        'smart_card_id':smartCardId,
        'chinese_name':chineseName,
        'english_name':englishName,
        'site_id':siteId,
        'connection_id':connectionId
      });
    }catch (e) {
      DioError error = e;
      DioHttpUtils(context).checkStatusCode(error.response.statusCode);
    }
    return QrResult.fromJson(result.data);
  }

  Future<Worker> getWorkerInfo(String smartCardId,String siteId) async {
    var result;
    try {
      result = await dio.get('/worker/get_by_id',queryParameters: {
        'card_holder_id':smartCardId.substring(0,9),
        'site_id':siteId,
      });
    }catch (e) {
      DioError error = e;
      DioHttpUtils(context).checkStatusCode(error.response.statusCode);
    }
    return Worker.fromJson(result.data);
  }

  Future<List> getSite() async {
    Response response = null;
    List sieteList = [];
    try {
      response = await dio.get('/site/list_by_user');
    }catch (e) {
      DioError error = e;
      DioHttpUtils(context).checkStatusCode(error.response.statusCode);
    }

    if (response != null) {
      if (response.statusCode == 200) {
        sieteList = response.data;
      }
    }
    return sieteList;
  }

  Future<List> getConnection(String siteId) async {
    Response response = null;
    List siteList = [];
    try {
      response = await dio.get('mobile_connection/list_active_by_site',queryParameters: {
        'site_id':siteId,
      });
    }catch (e) {
      DioError error = e;
      DioHttpUtils(context).checkStatusCode(error.response.statusCode);
    }

    if (response != null) {
      if (response.statusCode == 200) {
        siteList = response.data;
      }
    }
    return siteList;
  }
}