```jsx
你可以在 if 语句和 for 循环的代码块中使用 JSX，
1、将 JSX 赋值给变量
2、把 JSX 当作参数传入
3、以及从函数中返回 JSX

function getGreeting(user) {
  if (user) {
    return <h1>Hello, {formatName(user)}!</h1>;
  }
  return <h1>Hello, Stranger.</h1>;
}
```