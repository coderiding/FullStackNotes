将错误转换为可选值

你使用 try?来处理错误，将其转换为一个可选的值。如果在评估try?表达式时抛出错误，则表达式的值为nil。例如，在下面的代码中，x和y具有相同的值和行为。

```objectivec
func someThrowingFunction() throws -> Int {
    // ...
}
let x = try? someThrowingFunction()
let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
```

如果someThrowingFunction()抛出一个错误，x和y的值是nil。否则，x和y的值就是函数返回的值。请注意，x和y是一个可选的，无论someThrowingFunction()返回什么类型。这里函数返回的是一个整数，所以x和y是可选的整数。

当你想以同样的方式处理所有的错误时，使用try?可以让你写出简洁的错误处理代码。例如，下面的代码使用了几种方法来获取数据，如果所有方法都失败，则返回nil。

```objectivec
func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}
```