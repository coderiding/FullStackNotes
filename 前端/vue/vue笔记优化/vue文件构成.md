由三部分组成
```HTML
<template></template>
<script></script>
<style></style>


<template></template>通常建立我们要用的网页界面

<script></script>则是跟数据打交道，面向逻辑

<style></style>主要是负责template></template>标签中的样式
```

---
注意：

* template(模版)中只能包含一个父节点，即顶层的div只能有一个（例如上图，父节点为#app的div,没有其他兄弟节点）。<router-view></router-view>是子路由视图，后面的路由页面都显示在此处。
  
* 对于script标签，vue通常用es6来写，然后用export default导出，内部可以包含数据data、生命周期(mounted等)，方法(methods)等。

* 样式是通过style标签<style></style>包裹，默认作用域是全局的，如需定义作用域在该组件下起作用，需在标签上加上scoped(<style scoped></style>)。