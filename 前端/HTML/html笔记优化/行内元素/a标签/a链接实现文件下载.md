在我们写项目的时候经常会遇到上传下载什么的，如果想不通过后台直接在html中下载文件的话，可以把文件路径给a标签的href属性即可。注意一点的是，如果文件是txt,png,jpg等格式，浏览器会直接打开，而不触发下载功能，这时需要我们给a标签添加一个“download”属性，例如：

```html
<a href="文件地址" download="文件名.txt">点击下载</a>
```

```html
    // 下载，href指示目标地址，download重命名下载文件
    <a href="//www.w3school.com.cn/i/w3school_logo_white.gif" download="w3logo">
        <img border="0" src="//www.w3school.com.cn/i/w3school_logo_white.gif" alt="W3School">
    </a>
```