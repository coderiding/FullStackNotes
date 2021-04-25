```dart
//通过拦截器，我们可以在请求之前或响应之后做一些统一的预处理。例如我们发起请求前查看我们请求的参数和头部，响应的时候，我们可以查看返回来的数据。

Dio dio = new Dio();
// 添加拦截器
if (Config.DEBUG) {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options){
            print("\n================== 请求数据 ==========================");
            print("url = ${options.uri.toString()}");
            print("headers = ${options.headers}");
            print("params = ${options.data}");
        },
        onResponse: (Response response){
            print("\n================== 响应数据 ==========================");
            print("code = ${response.statusCode}");
            print("data = ${response.data}");
            print("\n");
        },
        onError: (DioError e){
            print("\n================== 错误响应数据 ======================");
            print("type = ${e.type}");
            print("message = ${e.message}");
            print("stackTrace = ${e.stackTrace}");
            print("\n");
        }
    ));
}

//移除拦截器
dio.interceptor.request.onSend=null;
dio.interceptor.response.onSuccess=null;
dio.interceptor.response.onError=null;
```