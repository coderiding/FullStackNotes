表示和抛出错误

在Swift中，错误由符合Error协议的类型值表示。这个空协议表示一个类型可以用于错误处理。

Swift枚举特别适合于对一组相关的错误条件进行建模，相关的值允许传达有关错误性质的附加信息。例如，下面是如何表示在游戏内操作自动售货机的错误条件。

```objectivec
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}
```

抛出错误可以让你表明发生了意想不到的事情，正常的执行流程无法继续。你使用 throw 语句来抛出一个错误。例如，下面的代码抛出了一个错误，表明自动售货机需要额外的五个硬币。

```objectivec
throw VendingMachineError.insufficientFunds(coinsNeeded: 5)
```