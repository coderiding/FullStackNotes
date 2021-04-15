通过export方式导出，在导入时要加{ }，export default则不需要

```js
var name1="李四";
var name2="张三";
export { name1 ,name2 }
```

```js
import { name1 , name2 } from "/.a.js" //路径根据你的实际情况填写
export default {
  data () {
    return { }
  },
  created:function(){//create:打开文件默认执行的方法
    alert(name1)//可以弹出来“李四”
    alert(name2)//可以弹出来“张三”
  }
 }
```


参考

https://blog.csdn.net/harry5508/article/details/84025146