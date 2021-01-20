您使用defer语句在代码执行离开当前代码块之前执行一组语句。这条语句可以让你做任何必要的清理工作，不管执行是如何离开当前代码块的--不管它是因为抛出了一个错误还是因为返回或break等语句而离开。例如，你可以使用defer语句来确保文件描述符被关闭，手动分配的内存被释放。

defer 语句推迟执行，直到退出当前的作用域。该语句由 defer 关键字和稍后要执行的语句组成。推迟语句不能包含任何会将控制权从语句中转移出去的代码，例如break或return语句，或者通过抛出错误。推迟动作的执行顺序与它们在源代码中的编写顺序相反。也就是说，第一个defer语句中的代码最后执行，第二个defer语句中的代码次之，以此类推。按源代码顺序最后一条defer语句先执行。

```objectivec
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // Work with the file.
        }
        // close(file) is called here, at the end of the scope.
    }
}
```

上面的例子使用了defer语句来确保open(_:)函数有对应的close(_:)的调用。

即使不涉及错误处理代码，也可以使用defer语句。