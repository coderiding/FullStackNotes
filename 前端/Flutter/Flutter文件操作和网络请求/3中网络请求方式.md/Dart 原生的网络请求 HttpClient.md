```dart
import 'dart:convert';
import 'dart:io';

HttpClient httpClient = new HttpClient();
HttpClientRequest request = await httpClient.getUrl(uri);

//Get 请求、Post 请求、Delete 请求
Uri uri=Uri(scheme: "https", host: "flutterchina.club", queryParameters: {
    "userName":"chen",
    "password":"123456"
});

//设置请求的 header
request.headers.add("user-agent", "test");
request.headers.add("Authorization", "LKSJDLFJSDLKJSLKklsdj");

HttpClientResponse response = await request.close();
if (response.statusCode == HttpStatus.ok) {
      _content = await response.transform(Utf8Decoder()).join();
}
httpClient.close();
```