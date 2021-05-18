### 方式1
```
Navigator.of(context).pop();

Navigator.pop(context);

Navigator.of(context).pop(); //直接做退出操作
Navigator.of(context).maybePop(); //若为栈中最后一个页面不做退出操作
```