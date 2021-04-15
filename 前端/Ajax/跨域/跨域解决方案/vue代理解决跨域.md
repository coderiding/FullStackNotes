本地开发的时候，设置通过vue的代理，解决测试时候的跨域请求问题。

发布到线上环境后，通过nigix反向代理，来解决跨域请求的问题。

总结：在代码中，写好请求接口的地址，如果html的文件和接口不在同一个域名下，就需要在后台配置nigix反向代理，每次html中的请求，都通过nigix来请求，然后返回给网页。

参考

https://segmentfault.com/a/1190000037557209  https://app.yinxiang.com/shard/s35/nl/9757212/cd12868f-23f1-46f8-94b0-acedc05637f5

https://segmentfault.com/a/1190000023077301