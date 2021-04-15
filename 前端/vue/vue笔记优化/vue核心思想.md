### 数据驱动

---
数据改变，找到vue的Directives，Directives对view的dom封装，通知view改变
![pq9TRn](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/pq9TRn.png)

最右侧的图，有一份数据a.b,在给vue实例化的过程中，会给这份数据通过es5的objectDefineProtict属性添加了一个getter和setter，同时vue.js会对模板做编译，
![6Ryi9G](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/6Ryi9G.png)

总结：原理是vue通过Directives指令，对Dom做一层封装。当数据发生变化，会通知指令去修改对应的Dom。数据驱动Dom变化，Dom是数据的一种自然映射。

---
view改变，通过vue的dom listeners，通知数据改变
![vennnz](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/vennnz.png)

vue.js还会对操作进行监听，当我修改视图时，vue.js监听到这些变化，才会改变数据。

总结：上面的两个过程就形成了数据的双向绑定。

### 组件化