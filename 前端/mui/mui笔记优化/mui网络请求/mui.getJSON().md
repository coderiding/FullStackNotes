mui.getJSON()方法是在mui.get()方法基础上的更进一步简化，限定返回json格式的数据，其它参数和mui.get()方法一致，使用方法： mui.get(url[,data][,success])，如上获得新闻列表的代码换成mui.getJSON()方法后，更为简洁，如下：

```js
mui.getJSON('http://server-name/list.php',{category:'news'},function(data){
		//获得服务器响应
		...
	}
);
```