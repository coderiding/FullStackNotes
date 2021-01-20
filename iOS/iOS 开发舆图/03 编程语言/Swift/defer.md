`defer` 语句用于在退出当前作用域之前执行代码。

`defer` 语句形式如下：

```objectivec
defer {
    statements
}
```

在 `defer` 语句中的语句无论程序控制如何转移都会被执行。在某些情况下，例如，手动管理资源时，比如关闭文件描述符，或者即使抛出了错误也需要执行一些操作时，就可以使用 `defer` 语句。

如果多个 `defer` 语句出现在同一作用域内，那么它们执行的顺序与出现的顺序相反。给定作用域中的第一个 `defer`语句，会在最后执行，这意味着代码中最靠后的 `defer` 语句中引用的资源可以被其他 `defer` 语句清理掉。

```objectivec
func f() {
    defer { print("First") }
    defer { print("Second") }
    defer { print("Third") }
}
f()
// 打印“Third”
// 打印“Second”
// 打印“First”
```

`defer` 语句中的语句无法将控制权转移到 `defer` 语句外部。

> defer 语句语法

**defer-statement**