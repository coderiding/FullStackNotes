### 纯化

不直接修改原对象，而是返回一个新对象的修改，我们称之为 “纯化” 的修改。

```DART
// reducer 是一个普通的 JavaScript 函数
// 它接收两个参数：state 和 action
// 前者为 Store 中存储的那棵 JavaScript 对象状态树，
// 后者即为我们在组件中 dispatch 的那个 Action。
// reducer 根据 action 的指示，对 state 进行对应的操作，然后返回操作后的 state，Redux Store 会自动保存这份新的 state。

reducer(state, action) {
  // 对 state 进行操作
  return newState;
}


// ...
const rootReducer = (state, action) => {
  switch (action.type) {
    case "ADD_TODO": {
      const { todos } = state;

      return {
        ...state,
        todos: [
          ...todos,
          {
            id: action.id,
            text: action.text,
            completed: false
          }
        ]
      };
    }
    default:
      return state;
  }
};

```

### appReducer

```DART
GSYState appReducer(GSYState state, action) {
  return GSYState(
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),

    ///通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: ThemeDataReducer(state.themeData, action),

    ///通过 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
    locale: LocaleReducer(state.locale, action),
    login: LoginReducer(state.login, action),
  );
}

```