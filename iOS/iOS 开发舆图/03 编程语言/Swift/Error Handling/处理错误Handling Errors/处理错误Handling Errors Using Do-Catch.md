使用Do-Catch处理错误

您使用do-catch语句通过运行代码块来处理错误。如果do子句中的代码抛出了一个错误，则将其与catch子句进行匹配，以确定其中哪个子句可以处理该错误。

下面是do-catch语句的一般形式。

```objectivec
do {
    try expression
    statements
} catch pattern 1 {
    statements
} catch pattern 2 where condition {
    statements
} catch pattern 3, pattern 4 where condition {
    statements
} catch {
    statements
}
```

你在 catch 后面写一个模式来说明该子句可以处理什么错误。如果 catch 子句没有模式，则该子句会匹配任何错误，并将错误绑定到一个名为 error 的本地常量。关于模式匹配的更多信息，请参阅模式。

例如，以下代码针对VendingMachineError枚举的所有三种情况进行匹配。(WEN:do里面的try抛出错误，就会进入到catch匹配)

```objectivec
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}
// Prints "Insufficient funds. Please insert an additional 2 coins."
```

在上面的例子中，buyFavoriteSnack(person:vendingMachine:)函数是在try表达式中调用的，因为它可能会抛出一个错误。如果抛出一个错误，执行会立即转移到捕捉子句，子句决定是否允许继续传播。如果没有匹配的模式，错误就会被最后的 catch 子句捕获，并被绑定到一个本地错误常量中。如果没有抛出错误，do语句中的其余语句就会被执行。

捕捉子句不必处理do子句中的代码可能抛出的每一个错误。如果没有一个捕获子句处理错误，错误就会传播到周围的作用域。但是，传播的错误必须由某个周围的作用域来处理。在一个非抛出函数中，一个包围的do-catch语句必须处理错误。在抛出函数中，必须由包围的do-catch语句或调用者来处理错误。如果错误没有被处理就传播到顶层作用域，你会得到一个运行时错误。

例如，上面的例子可以写成任何不是VendingMachineError的错误都会被调用函数捕获。

```objectivec
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Couldn't buy that from the vending machine.")
    }
}
do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}
// Prints "Couldn't buy that from the vending machine."
// 汶：抛出错误后，判断是否为VendingMachineError类型，如果是，就打印Couldn't buy that from the vending machine.
// 如果不是VendingMachineError类型，就打印Unexpected non-vending-machine-related error: \(error)
```

在nourish(with:)函数中，如果vend(itemNamed:)抛出的错误是VendingMachineError枚举的情况之一，nourish(with:)会通过打印一条消息来处理这个错误。否则，nourish(with:)会将错误传播到它的调用站点。然后，这个错误会被一般的 catch 子句捕获。

另一种捕获多个相关错误的方法是在 catch 后列出它们，用逗号分隔。例如

```objectivec
func eat(item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock {
        print("Invalid selection, out of stock, or not enough money.")
    }
}
```

eat(item:)函数列出了要捕获的自动售货机错误，其错误文本对应于该列表中的项目。如果列出的三个错误中的任何一个被抛出，这个 catch 子句会通过打印一条消息来处理它们。任何其他错误都会传播到周围的作用域，包括以后可能添加的任何自动售货机错误。