跨页面数据共享问题,如多页面购物车数据

子组件通信问题



### 别人的疑惑可能也是我的疑惑

这个问题困扰了很多年了,从15年就开始学习,一直没搞懂redux到底解决什么问题,为什么要用它,我觉得它好烦啊,怎么就那么难懂了.今年都20年了,我又回过头来再看redux,结果还是没看懂,那么多层层叠叠多东西又必要吗?
如果要解决跨页面共享问题, 定一个LocalStorage不就好了吗,
如果要解决子组件通信问题,定一个全局变量,再定一个监听不就好了吗?为什么一定要弄那么多复杂多api,太复杂了吧,想吐槽很久了.
到底还要做什么非他不可?

### 
store 就是数据的唯一真相来源，不管是获取数据状态还是修改数据状态，都是通过store来实现

（store就是一个JS状态树）需要建一个全局 JavaScript 对象状态树，然后所有的状态的改变都是通过修改这一状态树，进而将修改后的新状态传给相应的组件并触发重新渲染来完成我们的目的。

### 

更新 store 状态

更新 Store 的状态有且仅有一种方式：

那就是调用 dispatch 函数，传递一个 action 给这个函数

```DART
// type 是必须的 其它内容都是可选的,如这里的text可选
// 一个 action 包含动作的类型，以及更新状态需要的数据
// 下面大括号内部的就是一个action
dispatch({ type: 'ADD_TODO', text: '我是一只小小小图雀' })
```

### Action Creators（动作创建器）
```DART
// 方便调用
// 都存放在actions文件夹
dispatch(addTodo('我是一只小小小图雀'))

// 定义
let nextTodoId = 0;

const addTodo = text => ({
  type: "ADD_TODO",
  id: nextTodoId++,
  text
});
```

### reducers 响应 dispatch 的 Action


参考

http://react-china.org/t/redux/11616

https://jasonslyvia.github.io/a-cartoon-intro-to-redux-cn/

https://www.infoq.cn/article/9abcwvioiccvmio5xdxy

https://juejin.cn/post/6844904021187117069  https://app.yinxiang.com/shard/s35/nl/9757212/50d3ee8d-a2d4-4779-bf31-f19c8d6c6191