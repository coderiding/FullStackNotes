```dart
//  头部添加 token 验证
headers["Authorization"] = "token lskjdlklsjkdklsjd333";
option.headers = headers;
///超时
option.connectTimeout = 15000;

try {
    Response response = await dio.request(url, data: params, options: option);
} on DioError catch (e) {
    // 请求错误处理
}
```