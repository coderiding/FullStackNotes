为了在功能和性能间取得更好的平衡，mui.ajax目前实现逻辑如下：

* App端，跨域情况下，使用plus.net.XMLHttpRequest
* App端，WKWebview环境，使用plus.net.XMLHttpRequest
* 其它情况，默认使用window.XMLHttpRequest

> 注意：plus.net.XMLHttpRequest 必须在 plus ready 事件触发后才能使用。

为适应iOS13起苹果公司将UIWebview列为私有API的问题，从HBuilderX 2.2.5+版本已将iOS上默认内核由UIWebview调整为WKWebview。但WKWebview有更严格的跨域限制，普通xhr或ajax联网会报错：Script error.filename:lineno:0错误；此时必须使用plus.net.XMLHttpRequest，详见：https://ask.dcloud.net.cn/article/36348，所以在WKWebview下，请务必在plus ready后再调用mui.ajax，同时注意也无法再使用浏览器的xhr及jquery的ajax。