使用抛出函数传播错误。

为了表明一个函数、方法或初始化器可以抛出一个错误，你可以在函数声明中的参数后面写上throws关键字。一个标有throws的函数被称为抛出函数。如果函数指定了返回类型，你可以在返回箭头（->）之前写上throws关键字。

```objectivec
func canThrowErrors() throws -> String
func cannotThrowErrors() -> String
```

一个抛出函数会将它内部抛出的错误传播到它所调用的作用域。

注

只有抛出函数可以传播错误。任何在非抛出函数内部抛出的错误必须在函数内部处理。

在下面的例子中，VendingMachine类有一个vend(itemNamed:)方法，如果所请求的物品不可用、缺货或费用超过了当前存入的金额，该方法会抛出一个适当的VendingMachineError。

```objectivec
struct Item {
    var price: Int
    var count: Int
}
class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        coinsDeposited -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        print("Dispensing \(name)")
    }
}
```

vend(itemNamed:)方法的实现使用了guard语句，如果任何一个购买零食的要求没有得到满足，就会提前退出该方法并抛出适当的错误。因为抛出语句会立即转移程序控制权，所以只有在满足所有这些要求的情况下，才会对一个物品进行售卖。

因为 vend(itemNamed:)方法会传播任何它抛出的错误，所以任何调用该方法的代码必须处理这些错误--使用do-catch语句、try?或try!--或者继续传播它们。例如，下面例子中的buyFavoriteSnack(person:vendingMachine:)也是一个抛出函数， vend(itemNamed:)方法抛出的任何错误都会传播到调用buyFavoriteSnack(person:vendingMachine:)函数的地方。

```objectivec
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
`
```

在这个例子中，buyFavoriteSnack(person: vendingMachine:)函数通过调用vend(itemNamed:)方法查找给定的人最喜欢的零食，并试图为他们购买。因为 vend(itemNamed:)方法可能会抛出一个错误，所以在调用该方法时，前面会有 try 关键字。

抛出初始化器可以像抛出函数一样传播错误。例如，下面列表中 PurchasedSnack 结构的初始化器作为初始化过程的一部分调用了一个抛出函数，它通过向其调用者传播错误来处理所遇到的任何错误。

```objectivec
struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}
```