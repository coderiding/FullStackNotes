import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';

class DeviceUtils {
  Future<String> getUniqueId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    }else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }
}