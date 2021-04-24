Navigator是一个路由管理的组件，它提供了打开和退出路由页方法。Navigator通过一个栈来管理活动路由集合。

### 管理路由栈常用的两个方法

* Future push(BuildContext context, Route route)
将给定的路由入栈（即打开新的页面），返回值是一个Future对象，用以接收新路由出栈（即关闭）时的返回数据。

push方法
返回Future对象

* bool pop(BuildContext context, [ result ])
将栈顶路由出栈，result为页面关闭时返回给上一个页面的数据。

pop方法
返回上一个页面的数据到result


---
还有Navigator.replace、Navigator.popUntil