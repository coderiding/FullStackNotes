```HTML
    <a href="">空链接，当前页面跳转，刷新页面</a>
    <a href="//www.baidu.com" target="_blank">打开新窗口，跳转到百度</a>
    <a href="javascript:void(0)" >不跳转，网页上常用于button作用的a标签设置点击事件，阻止跳转</a>
    <a href="mailto:123@qq.com">发送邮件【mailto：会自动检测本机系统是否安装邮箱，如果有就会自动打开邮箱，没有则会提示用户选择邮箱或者没提示】</a>
    <a href="tel:123456789">一键拨打电话</a>
    <a href="sms:123456789">一键发送短信</a>

    <a href="#">空锚点，回到最顶端，不刷新页面</a>

    <a href="#app">跳转</a>
    <p id="app">锚点</p>

    <a href="#app">跳转</a>
    <a href="" name="app">跳转【这种方式只能用a标签的name属性定义才生效】</a>
```

A标签要有href才拥有跳转功能

1、跳转到一个网页
2、跳转到图片
3、跳转相对路径

参数
href 规定链接指向的页面的 URL

title 规定鼠标置于标签上的显示说明

target

_blank 表示新窗口打开，保留原窗口
_self 默认自身打开

![7dYHBe](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/7dYHBe.png)

---
注意：a标签是inline行内元素，占用的位置就是内容的位置，不会占用整块，如果想改变，就要将a标签的display:block，变成块元素


参考

http://www.fly63.com/article/detial/69   https://app.yinxiang.com/shard/s35/nl/9757212/f158e9a8-05d4-43f9-a717-6a1542b0a064

https://juejin.cn/post/6844904013566066702   https://app.yinxiang.com/shard/s35/nl/9757212/5760212a-67c6-404c-9275-6c048ec2f49a