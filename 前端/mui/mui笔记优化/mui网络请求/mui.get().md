mui.get()方法和mui.post()方法类似，只不过是直接使用GET请求方式向服务器发送数据、且不处理timeout和异常（若需处理异常及超时，请使用mui.ajax()方法），使用方法： mui.get(url[,data][,success][,dataType])，如下为获得某服务器新闻列表的代码片段，服务器以json格式返回数据列表

```js
mui.get('http://server-name/list.php',{category:'news'},function(data){
		//获得服务器响应
		...
	},'json'
);
```

如上mui.get()方法和如下mui.ajax()方法效果是一致的：

```js
mui.ajax('http://server-name/list.php',{
	data:{
		category:'news'
	},
	dataType:'json',//服务器返回json格式数据
	type:'get',//HTTP请求类型
	success:function(data){
		//获得服务器响应
		...
	}
});
```