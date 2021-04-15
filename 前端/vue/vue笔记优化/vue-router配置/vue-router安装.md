https://www.bilibili.com/video/av32792787/

https://router.vuejs.org/zh/installation.html

---
下载安装

1、直接下载vue-router文件，在开发的html页面中先导入vue.js和vue-router.js，注意先导入vue.js,因为vue-router.js有引入vue.js内的东西。

---
手动安装

2、如果是用webpack构建的模块化工程，通过 Vue.use() 明确地安装路由功能
```js
import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)
```