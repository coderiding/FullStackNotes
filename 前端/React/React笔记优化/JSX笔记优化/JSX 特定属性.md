```jsx
对于字符串值使用引号

const element = <div tabIndex="0"></div>;
```

```jsx
对于表达式使用大括号，不要在大括号外面加上引号

const element = <img src={user.avatarUrl}></img>;
```

对于同一属性不能同时使用这两种符号（引号、大括号）。