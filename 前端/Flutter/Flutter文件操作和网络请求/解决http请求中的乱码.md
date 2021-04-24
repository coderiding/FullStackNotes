```dart
import 'package:flutter_trip/model/home_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

class HomeDao {

  // fetch 方法名
  static Future<HomeModel> fetch() async {
    final response = await http.get(HOME_URL);
    if (response.statusCode == 200) {
      // 解决http请求中的乱码
      Utf8Decoder utf8 = Utf8Decoder();
      var result = json.decode(utf8.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    }
  }
}
```