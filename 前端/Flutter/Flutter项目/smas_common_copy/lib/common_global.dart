import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smas_common_copy/device_utils.dart';

class Global {
  static SharedPreferences _prefs;
  static String KEY_TOKEN = 'access_token';
  static PackageInfo _packageInfo;
  static String _deviceUniqueId;
  static String _isAndroid;

  static bool get isRelease => bool.fromEnvironment('dart.vm.product');

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    _packageInfo = await PackageInfo.fromPlatform();
    _deviceUniqueId = await DeviceUtils().getUniqueId();
    _isAndroid = defaultTargetPlatform == TargetPlatform.android ? 'true' : 'false';
  }

  static SharedPreferences getPreference() {
    return _prefs;
  }

  static String getToken() {
    return _prefs.getString(KEY_TOKEN);
  }

  static PackageInfo getPackageInfo() {
    return _packageInfo;
  }

  static String getDeviceUniqueId() {
    return _deviceUniqueId;
  }

  static String isAndroid() {
    return _isAndroid;
  }
}