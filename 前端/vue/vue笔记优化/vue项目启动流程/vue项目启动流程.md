index.html-->main.js-->App.vue-->router/index.js

总结：html->main.js->app.vue->index.js

---
1、index.html的内容比较简单，主要是提供一个div给vue挂载。

```HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width, minimal-ui, viewport-fit=cover" />//适应手机屏幕

    <title>首页title</title>
  </head>
  <body>
    <div id="app"></div>
    <!-- built files will be auto injected -->
  </body>
</html>
```

---

2、main.js主要是引入vue、App、router模块，创建一个vue对象，并把App.vue模版的内容挂载到index.html的id为app的div标签下，并绑定一个路由配置。

```JS
import Vue from 'vue'    /*引入vue框架*/
import App from './App'     /*引入根组件*/
import router from './router'    /*引入路由设置*/
import store from './store'    /*引入根状态管理集文件*/
Vue.config.productionTip = false    /*关闭生产模式下给出的提示*/

//定义根组件，用render读取一个.vue文件，$mount渲染替换index.html中的占位
new Vue({
el:'#app',
router,
store,
render:h=>h(App),
}).$mount('#app');
``` 

---

3、App.vue ---根组件

---

4、路由配置。在router文件夹下，有一个index.js文件，即为路由配置文件。由下图见,文件中配置了一个路由，在访问路径/的时候，会把Home模版的内容放置到上面的router-view中。

用户在浏览器中访问的路由是/，router插件就会加载home.vue文件，同理/about就是加载about.vue文件。用加载的home.vue文件或者about.vue文件去替换App.vue文件中的 router-view 占位符。

```JS
import Vue from 'vue';
import Router from 'vue-router';
import Home from 'views/home'
import About from 'views/about'
Vue.use(Router);
export default new Router({
    base:'/'
    routes:[
        {
            path:'/',
            name:'home',
            component:Home
        },
        {
            path:'/about'
            name:'about',
            component:About
        }
    ]
});
```


参考

https://juejin.cn/post/6854573213146578952  https://app.yinxiang.com/shard/s35/nl/9757212/6427be18-7b16-4143-a736-c158b3474686
