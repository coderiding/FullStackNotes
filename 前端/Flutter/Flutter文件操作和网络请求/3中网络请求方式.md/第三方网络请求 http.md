```dart
//pubspec.yaml 添加依赖
http: '>=0.11.3+12'

import 'package:http/http.dart' as http;

//get请求
void getRequest() async {
    var client = http.Client();
    http.Response response = await client.get(url_2);
    _content = response.body;
}

//post请求
void postRequest() async {
    var params = Map<String, String>();
    params["username"] = "hellonews";
    params["password"] = "123456";

    var client = http.Client();
    var response = await client.post(url_post, body: params);
    _content = response.body;
}
