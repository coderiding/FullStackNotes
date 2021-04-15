```jsx
假如一个标签里面没有内容，你可以使用 /> 来闭合标签，就像 XML 语法一样：

const element = <img src={user.avatarUrl} />;
```

```jsx
JSX 标签里能够包含很多子元素:

const element = (
  <div>
    <h1>Hello!</h1>
    <h2>Good to see you here.</h2>
  </div>
);
```