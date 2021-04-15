mui.post()方法是对mui.ajax()的一个简化方法，直接使用POST请求方式向服务器发送数据、且不处理timeout和异常（若需处理异常及超时，请使用mui.ajax()方法），使用方法： mui.post(url[,data][,success][,dataType])，如上登录鉴权代码换成mui.post()后，代码更为简洁，如下：

```js
mui.post('http://server-name/login.php',{
		username:'username',
		password:'password'
	},function(data){
		//服务器返回响应，根据响应结果，分析是否登录成功；
		...
	},'json'
);
```