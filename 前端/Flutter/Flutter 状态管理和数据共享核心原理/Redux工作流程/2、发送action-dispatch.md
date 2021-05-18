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