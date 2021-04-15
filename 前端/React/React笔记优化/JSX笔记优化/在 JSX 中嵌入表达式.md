```jsx
在下面的例子中，我们声明了一个名为 name 的变量，然后在 JSX 中使用它，并将它包裹在大括号中：

const name = 'Josh Perez';
const element = <h1>Hello, {name}</h1>;

ReactDOM.render(
  element,
  document.getElementById('root')
);
```



```jsx
在下面的示例中，我们将调用 JavaScript 函数 formatName(user) 的结果，并将结果嵌入到 <h1> 元素中。

function formatName(user) {
  return user.firstName + ' ' + user.lastName;
}

const user = {
  firstName: 'Harper',
  lastName: 'Perez'
};

const element = (
  <h1>
    Hello, {formatName(user)}!
  </h1>
);

ReactDOM.render(
  element,
  document.getElementById('root')
);
```