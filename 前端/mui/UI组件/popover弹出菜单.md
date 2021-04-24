mui框架内置了弹出菜单插件，弹出菜单显示内容不限，但必须包裹在一个含`.mui-popover`类的div中，如下即为一个弹出菜单内容：

```html
<div id="popover" class="mui-popover">
  <ul class="mui-table-view">
    <li class="mui-table-view-cell"><a href="#">Item1</a></li>
    <li class="mui-table-view-cell"><a href="#">Item2</a></li>
    <li class="mui-table-view-cell"><a href="#">Item3</a></li>
    <li class="mui-table-view-cell"><a href="#">Item4</a></li>
    <li class="mui-table-view-cell"><a href="#">Item5</a></li>
  </ul>
</div>
```

要显示、隐藏如上菜单，mui推荐使用锚点方式，例如：

```html
<a href="#popover" id="openPopover" class="mui-btn mui-btn-primary mui-btn-block">打开弹出菜单</a>
```

点击如上定义的按钮，即可显示弹出菜单，再次点击弹出菜单之外的其他区域，均可关闭弹出菜单；这种使用方式最为简洁。

若希望通过js的方式控制弹出菜单，则通过如下一个方法即可：

```html
mui('.bottomPopover').popover(status[,anchor]);
```

- **[status](https://dev.dcloud.net.cn/mui/ui/#on-events-selector-data-handler)**
- **'show'**
    - 显示popover
- **'hide'**
    - 隐藏popover
- **'toggle'**
    - 自动识别处理显示隐藏状态

```html
mui('.bottomPopover').popover('toggle');//show hide toggle
```

- **[[anchor]](https://dev.dcloud.net.cn/mui/ui/#on-events-selector-data-handler)**
- **anchorElement**
    - 锚点元素

```html
//传入toggle参数，用户也无需关心当前是显示还是隐藏状态，mui会自动识别处理；
mui('.mui-popover').popover('toggle',document.getElementById("openPopover"));
```

### **扩展阅读**

问答社区话题讨论： [popover](https://ask.dcloud.net.cn/topic/popover)

### **汶在代码中的使用例子**

```html
<!--调用弹出框-->
mui("#popover").popover('toggle');
<!--弹出框-->
<div id="popover" class="mui-popover errorPop">
    <!--弹出框第一行内容，是一个div，是提示文字-->
  <div id="tipsLabel" style="margin-top: 10%;text-align: center;color: red; "></div>
    <!--弹出框第二行内容，是一个div，是底部提示文字-->
  <div id="tipsLabelbottom" style="color: gray; margin:20px;"></div>
    <!--分隔线-->
  <div style="height: 1px; background-color: lightgray;margin:5px 0"></div>
    <!--底部按钮-->
  <div id="okButton" class="myCenter" style="color:#00A8E7;margin:10px 0">我知道了</div>
</div>
```