```DART
//支持 Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载、超时

//pubspec.yaml 添加依赖
dependencies:
  dio: ^1.0.9

import 'package:dio/dio.dart';

//get请求
void getRequest() async {
    Dio dio = new Dio();
    var response = await dio.get("/test?id=12&name=chen");
    _content = response.data.toString();
}

void getRequest() async {
    Dio dio = new Dio();
    //get请求通过对象传递参数
    var response = await dio.get("/test"，data:{"id":12,"name":"chen"});
    _content = response.data.toString();
}

// post请求
void getRequest() async {
    Dio dio = new Dio();
    var response = await dio.get("/test"，data:{"id":12,"name":"chen"});
    _content = response.data.toString();
}
```