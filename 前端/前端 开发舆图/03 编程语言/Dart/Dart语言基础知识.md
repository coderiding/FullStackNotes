## Dart基础知识

### Dart的示例

* [Dart的示例008-加号按钮](https://gitee.com/erliucxy/codes/yg3wqdmhaenuj56pbszv139)
* [Dart的示例007-演示runes16BitCodeUnits和32](https://gitee.com/erliucxy/codes/9plmtnbg1837uzqvdwyc086)
* [Dart的示例006-卡片列表增加删除](https://gitee.com/erliucxy/codes/snal1zb3m46q97twgvrx089)
* [Dart的示例005-分页指示器](https://gitee.com/erliucxy/codes/fusp3el50mnw4tkgvx91c26)
* [Dart的示例004-菜单](https://gitee.com/erliucxy/codes/7x12f85rw0klhyqusemtz77)
* [Dart的示例003-列表展开](https://gitee.com/erliucxy/codes/vjf7n6pqcgy8szetrambo61)
* [Dart的示例002-顶部tabbar](https://gitee.com/erliucxy/codes/dzy1h0r2xe5wbpjq6ifso39)
* [Dart的示例001-一个widget](https://gitee.com/erliucxy/codes/d16fgbhj2u4wrplnxak8m63)

### Dart的一个重要的程序2019.2.13

* 一个数字字面量。数字字面量是编译时常量
* $variableName (or ${expression})
* 字符串插值：在字符串字面量中引用变量或者表达式。 详情请参考：  Strings 。 
* main()
* Dart 程序执行的入口方法，每个程序都   需要   一个这样的方法。 详情请参考：  main() 方法 。 

### Dart线程模型及异常捕获

**Dart单线程模型**
* Dart和JavaScript不同，它们都是单线程模型
* 微任务队列的执行优先级高于事件队列
* Dart 在单线程中是以消息循环机制来运行的，其中包含两个任务队列，一个是“微任务队列” microtask queue，另一个叫做“事件队列” event queue。
* 一个任务中的异常是不会影响其它任务执行的。
* 单线程工作顺序
* http://ww1.sinaimg.cn/large/006Akqprgy1g05y886j7bj30d30e2dg8.jpg

---

**单线程工作顺序**
* Dart 在单线程中是以消息循环机制来运行的，其中包含两个任务队列，一个是 “ 微任务队列 ” microtask queue ，另一个叫做 “ 事件队列 ” event queue 。从图中可以发现，微任务队列的执行优先级高于事件队列。 
* 现在我们来介绍一下Dart 线程运行过程，如上图中所示，入口函数 main() 执行完后，消息循环机制便启动了。首先会按照先进先出的顺序逐个执行微任务队列中的任务，当所有微任务队列执行完后便开始执行事件队列中的任务，事件任务执行完毕后再去执行微任务，如此循环往复，生生不息。 
* 在 Dart 中，所有的外部事件任务都在事件队列中，如 IO 、计时器、点击、以及绘制事件等，而微任务通常来源于 Dart 内部，并且微任务非常少，之所以如此，是因为微任务队列优先级高，如果微任务太多，执行时间总和就越久，事件队列任务的延迟也就越久，对于 GUI 应用来说最直观的表现就是比较卡，所以必须得保证微任务队列不会太长。值得注意的是，我们可以通过 Future.microtask(…) 方法向微任务队列插入一个任务。 
* 在事件循环中，当某个任务发生异常并没有被捕获时，程序并不会退出，而直接导致的结果是当前任务 的后续代码就不会被执行了，也就是说一个任务中的异常是不会影响其它任务执行的。 

### Dart的symbols

* 一个  Symbol  object 代表 Dart 程序中声明的操作符或者标识符。 你也许从来不会用到 Symbol ，但是该功能对于通过名字来引用标识符的情况 是非常有价值的，特别是混淆后的代码， 标识符的名字被混淆了，但是 Symbol 的名字不会改变。 
* Symbol 字面量定义是编译时常量。 
* 关于 symbols 的详情，请参考  Dart:mirrors - reflection 。 
* 使用 Symbol 字面量来获取标识符的 symbol 对象，也就是在标识符 前面添加一个   #   符号： 

```dart
#radix 
#bar 
```

### Dart的String

* Strings（字符串）2019.2.13
* Dart 字符串是 UTF-16 编码的字符序列。 可以使用单引号或者双引号来创建字符串： 

```dart
var s1 = 'Single quotes work well for string literals.' ; 
var s2 = "Double quotes work just as well." ; 
var s3 = 'It\'s easy to escape the string delimiter.' ; 
var s4 = "It's even easier to use the other delimiter." ;
```

* 可以在字符串中使用表达式，用法是这样的：   ${expression } 。如果表达式是一个比赛服，可以省略 {} 。 如果表达式的结果为一个对象，则 Dart 会调用对象的   toString()   函数来获取一个字符串。 

```dart
var s = 'string interpolation' ; 

assert ( 'Dart has $s, which is very handy.' == 
       'Dart has string interpolation, ' + 
       'which is very handy.' ); 
assert ( 'That deserves all caps. ' + 
       '${s.toUpperCase()} is very handy!' == 
       'That deserves all caps. ' + 
       'STRING INTERPOLATION is very handy!' ); 
```

* 注意：   ==   操作符判断两个对象的内容是否一样。 如果两个字符串包含一样的字符编码序列， 则他们是相等的。 

---

**可以在字符串中使用表达式，用法是这样的： ${expression}**

```dart
var s = 'string interpolation' ; 

assert ( 'Dart has $s, which is very handy.' == 
       'Dart has string interpolation, ' + 
       'which is very handy.' ); 
assert ( 'That deserves all caps. ' + 
       '${s.toUpperCase()} is very handy!' == 
       'That deserves all caps. ' + 
       'STRING INTERPOLATION is very handy!' ); 
```

---

**使用三个单引号或者双引号也可以 创建多行字符串对象：**

```dart
var s1 = ''' You can create multi-line strings like this one. ''' ; 
var s2 = """This is also a multi-line string.""" ; 
```

---

**通过提供一个 r 前缀可以创建一个 “原始 raw” 字符串：**

```dart
var s = r"In a raw string, even \n isn't special." ; 
```

* 参考  Runes   来了解如何在字符串 中表达 Unicode 字符。 

---

**字符串字面量是编译时常量， 带有字符串插值的字符串定义，若干插值表达式引用的为编译时常量则其结果也是编译时常量。**

```dart
// These work in a const string. 
const aConstNum = 0 ; 
const aConstBool = true ; 
const aConstString = 'a constant string' ; 

// These do NOT work in a const string. 
var aNum = 0 ; 
var aBool = true ; 
var aString = 'a string' ; 
const aConstList = const [ 1 , 2 , 3 ]; 

const validConstString = '$aConstNum $aConstBool $aConstString' ; 
// const invalidConstString = '$aNum $aBool $aString $aConstList'; 
```

---

**可以使用 + 操作符来把多个字符串链接为一个，也可以把多个 字符串放到一起来实现同样的功能：**

```dart
var s1 = 'String ' 'concatenation' 
         " works even over line breaks." ; 
assert (s1 == 'String concatenation works even over ' 
             'line breaks.' ); 

var s2 = 'The + operator ' 
         + 'works, as well.' ; 
assert (s2 == 'The + operator works, as well.' ); 
```

### Dart的runes代表字符串的utf32code

* Unicode 为每一个字符、标点符号、表情符号等都定义了 一个唯一的数值。 由于 Dart 字符串是 UTF-16 code units 字符序列， 所以在字符串中表达 32-bit Unicode 值就需要 新的语法了。 
* 通常使用   \uXXXX   的方式来表示 Unicode code point ， 这里的 XXXX 是 4 个 16 进制的数。 例如，心形符号 ( ♥ ) 是   \u2665 。 对于非 4 个数值的情况， 把编码值放到大括号中即可。 例如，笑脸 emoji ( 😆 ) 是   \u{1f600} 。 

### Dart的metadata元数据

* 使用元数据给你的代码添加其他额外信息。 元数据注解是以@字符开头，后面是一个编译时常量 ( 例如deprecated ) 或者调用一个常量构造函数。 
* 有三个注解所有的 Dart 代码都可以使用：@deprecated 、@override 和  @proxy 。
* 关于   @override 和   @proxy   示例请参考  Extending a class 。 
* 使用元数据给你的代码添加其他额外信息。
* 元数据可以在 library 、 class 、 typedef 、 type parameter 、 constructor 、 factory 、 function 、 field 、 parameter 、或者 variable 声明之前使用，也可以在 import 或者 export 指令之前使用。 使用反射可以在运行时获取元数据信息。
* 下面是使用@deprecated的 示例： 

```dart
class Television { 
  /// _Deprecated: Use [turnOn] instead._ 
  @deprecated 
  void activate() { 
    turnOn(); 
  } 

  /// Turns the TV's power on. 
  void turnOn() { 
    print( 'on!' ); 
  } 
} 
```

* 你还可以定义自己的元数据注解。
* 下面的示例定义了一个带有两个参数的 @todo 注解： 

```dart
library todo; 

class todo { 
  final String who; 
  final String what; 

  const todo( this .who, this .what); 
} 
```

* 使用 @todo 注解的示例： 

```dart
import 'todo.Dart' ; 

@todo( 'seth' , 'make this do something' ) 
void doSomething() { 
  print( 'do something' ); 
} 
```

### Dart的LibrariesAndVisibility库和可见性-怎么导入库

**Using libraries（使用库）**

* 使用import来指定一个库如何使用另外一个库。
* 例如， Dart web 应用通常使用Dart:html库，然后可以这样导入库： import 'Dart:html' ; 
* import必须参数为库的URI。对于内置的库，URI 使用特殊的Dart:scheme。对于其他的库，你可以使用文件系统路径或者package:  scheme 。package: scheme 指定的库通过包管理器来提供， 例如 pub 工具。 
* 注意： URI代表 uniform resource identifier 。URLs  (uniform resource locators) 是一种常见的 URI 。 

```dart
import 'Dart:io' ; 
import 'package:mylib/mylib.Dart' ; 
import 'package:utils/utils.Dart' ; 
```

---

**Specifying a library prefix（指定库前缀）**
* 如果你导入的两个库具有冲突的标识符， 则你可以使用库的前缀来区分。
* 如果你导入的两个库具有冲突的标识符， 则你可以使用库的前缀来区分。 例如，如果 library1 和 library2 都有一个名字为 Element 的类， 你可以这样使用： 

```dart
import 'package:lib1/lib1.Dart' ; 
import 'package:lib2/lib2.Dart' as lib2; 
// ... 
Element element1 = new Element ();           // Uses Element from lib1. 
lib2. Element element2 = new lib2. Element (); // Uses Element from lib2. 
```

---

**Importing only part of a library（导入库的一部分）**
* 如果你只使用库的一部分功能，则可以选择需要导入的 内容
* 如果你只使用库的一部分功能，则可以选择需要导入的 内容。例如： 

```dart
// Import only foo. 
import 'package:lib1/lib1.Dart' show foo; 

// Import all names EXCEPT foo. 
import 'package:lib2/lib2.Dart' hide foo; 
```

---

**Lazily loading a library（延迟载入库）**
* Deferred loading  ( 也称之为  lazy loading ) 可以让应用在需要的时候再加载库。 
* 下面是一些使用延迟加载库的场景： 
	•	减少 APP 的启动时间。 
	•	执行 A/B 测试，例如 尝试各种算法的 不同实现。 
	•	加载很少使用的功能，例如可选的屏幕和对话框。 
* 要延迟加载一个库，需要先使用 deferred as 来 导入： import 'package:deferred/hello.Dart' deferred as hello; 
* 当需要使用的时候，使用库标识符调用   loadLibrary()   函数来加载库： 

```dart
greet() async { 
  await hello.loadLibrary(); 
  hello.printGreeting(); 
} 
```

* 在前面的代码， 使用   await   关键字暂停代码执行一直到库加载完成。 关于   async   和   await   的更多信息请参考  异步支持 。 
* 在一个库上你可以多次调用   loadLibrary()   函数。 但是该库只是载入一次。 
* 使用延迟加载库的时候，请注意一下问题： 
	* 延迟加载库的常量在导入的时候是不可用的。 只有当库加载完毕的时候，库中常量才可以使用。 
	* 在导入文件的时候无法使用延迟库中的类型。 如果你需要使用类型，则考虑把接口类型移动到另外一个库中， 让两个库都分别导入这个接口库。 
	* Dart 隐含的把   loadLibrary()   函数导入到使用   deferred as  的命名空间   中。   loadLibrary() 方法返回一个  Future 。 

---

**Implementing libraries（实现库）**
* 参考创建库来了解如何创建一个库并发布。 

### Dart的generics泛型

* 如果你查看 List 类型的 API 文档， 则可以看到 实际的类型定义为 List< E >。 这个 <…> 声明 list 是一个 泛型 (或者 参数化) 类型。 通常情况下，使用一个字母来代表类型参数， 例如 E, T, S, K, 和 V 等。
* Why use generics?（为何使用泛型）
* 在 Dart 中类型是可选的，你可以选择不用泛型。 有些情况下你可能想使用类型来表明你的意图， 不管是使用泛型还是 具体类型。 
* 例如，如果你希望一个 list 只包含字符串对象，你可以 定义为   List< String >  ( 代表 “list of string”) 。这样你、 你的同事、以及所使用的工具 ( IDE 以及 检查模式的 Dart VM ) 可以帮助你检查你的代码是否把非字符串类型对象给放到 这个 list 中了。下面是一个示例： 

```dart
var names = new List < String >(); 
names.addAll([ 'Seth' , 'Kathy' , 'Lars' ]); 
// ... 
names.add( 42 ); // Fails in checked mode (succeeds in production mode). 
```

* 使用泛型的原因是减少重复的代码
* 另外一个使用泛型的原因是减少重复的代码。 泛型可以在多种类型之间定义同一个实现， 同时还可以继续使用检查模式和静态分析工具提供的代码分析功能。 例如，你创建一个保存缓存对象 的接口： 

```dart
abstract class Obj

ectCache { 
  Object getByKey( String key); 
  setByKey( String key, Object value); 
} 
```

* 后来你发现你需要一个用来缓存字符串的实现， 则你又定义另外一个接口： 

```dart
abstract class StringCache { 
  String getByKey( String key); 
  setByKey( String key, String value); 
} 
```

* 然后，你又需要一个用来缓存数字的实现， 在后来，你又需要另外一个类型的缓存实现，等等。。。 
* 泛型可以避免这种重复的代码。 你只需要创建一个接口即可： 

```dart
abstract class Cache < T > { 
  T getByKey( String key); 
  setByKey( String key, T value); 
} 
```

* 在上面的代码中， T 是一个备用类型。这是一个类型占位符， 在开发者调用该接口的时候会指定具体类型。 

---

**Using collection literals（使用集合字面量）**
* List 和 map 字面量也是可以参数化的。 参数化定义 list 需要在中括号之前 添加   < type >   ， 定义 map 需要在大括号之前 添加   < keyType  , valueType > 。 如果你需要更加安全的类型检查，则可以使用 参数化定义。下面是一些示例： 
```dart
var names = < String >[ 'Seth' , 'Kathy' , 'Lars' ]; 
var pages = < String , String >{ 
  'index.html' : 'Homepage' , 
  'robots.txt' : 'Hints for web robots' , 
  'humans.txt' : 'We are people, not machines' 
}; 
```

---

**Using parameterized types with constructors（在构造函数中使用泛型）**
* 在调用构造函数的时候， 在类名字后面使用尖括号(<...>)来指定 泛型类型
* 在调用构造函数的时候， 在类名字后面使用尖括号 ( <...> ) 来指定 泛型类型。例如： 

```dart
var names = new List < String >(); 
names.addAll([ 'Seth' , 'Kathy' , 'Lars' ]); 
var nameSet = new Set < String >.from(names); 
```

* 下面代码创建了一个 key 为 integer ， value 为 View 类型 的 map ： 

```dart
var views = new Map < int , View >(); 
```

---

**Generic collections and the types they contain**
* Dart 的泛型类型是固化的，在运行时有也 可以判断具体的类型。例如在运行时（甚至是成产模式） 也可以检测集合里面的对象类型： 

```dart
var names = new List < String >(); 
names.addAll([ 'Seth' , 'Kathy' , 'Lars' ]); 
print(names is List < String >); // true 
```

* 注意   is   表达式只是判断集合的类型，而不是集合里面具体对象的类型。 在成产模式， List< String > 变量可以包含 非字符串类型对象。对于这种情况， 你可以选择分别判断每个对象的类型或者 处理类型转换异常 ( 参考  Exceptions ) 。 
* 注意：  Java 中的泛型信息是编译时的，泛型信息在运行时是不纯在的。 在 Java 中你可以测试一个对象是否为 List ， 但是你无法测试一个对象是否为   List< String > 。 

---

**Restricting the parameterized type（限制泛型类型）**
* 当使用泛型类型的时候，你 可能想限制泛型的具体类型。

```dart
// T must be SomeBaseClass or one of its descendants. 
class Foo < T extends SomeBaseClass > {...} 
class Extender extends SomeBaseClass {...} 

void main() { 
  // It's OK to use SomeBaseClass or any of its subclasses inside <>. 
  var someBaseClassFoo = new Foo < SomeBaseClass >(); 
  var extenderFoo = new Foo < Extender >(); 

  // It's also OK to use no <> at all. 
  var foo = new Foo (); 

  // Specifying any non-SomeBaseClass type results in a warning and, in 
  // checked mode, a runtime error. 
  // var objectFoo = new Foo<Object>(); 
} 
```

---

**Using generic methods（使用泛型函数）**
* 一开始，泛型只能在 Dart 类中使用。 新的语法也支持在函数和方法上使用泛型了。 

```dart
T first <T> ( List < T > ts) { 
  // ...Do some initial work or error checking, then... 
  T tmp ?= ts[ 0 ]; 
  // ...Do some additional checking or processing... 
  return tmp; 
}
```

* 这里的   first  (  < T > ) 泛型可以在如下地方使用 参数   T   ： 
	* 函数的返回值类型 ( T ). 
	* 参数的类型 ( List< T > ). 
	* 局部变量的类型 ( T tmp ). 
* 版本说明：  在 Dart SDK 1.21.   开始可以使用泛型函数。 
* 如果你使用了泛型函数，则需要  设置 SDK 版本号为 1.21 或者更高版本。 
* 关于泛型的更多信息，请参考  Dart 的可选 类型   和  使用泛型函数 。 

### Dart的Functions方法

* Dart 是一个真正的面向对象语言，方法也是对象并且具有一种 类型，  Function 。 这意味着，方法可以赋值给变量，也可以当做其他方法的参数。 也可以把 Dart 类的实例当做方法来调用。 详情请参考  Callable classes 。 
* 方法的示例：

```dart
bool isNoble( int atomicNumber) { 
  return _nobleGases[atomicNumber] != null ; 
} 
```

* 可以选择忽略类型定义示例

```dart
isNoble(atomicNumber) { 
  return _nobleGases[atomicNumber] != null ; 
} 
```

* 只有一个表达式的方法，你可以选择 使用缩写语法来定义：

```dart
bool isNoble( int atomicNumber) => _nobleGases[atomicNumber] != null ; 
```

* => expr 语法是 { return expr; } 形式的缩写
* 这个   => expr   语法是   { return expr ; }   形式的缩写。 =>   形式 有时候也称之为   胖箭头   语法。 
* 注意：   在箭头 (=>) 和冒号 (;) 之间只能使用一个   表达式  – 不能使用   语句。 例如：你不能使用  if statement ，但是可以 使用条件表达式  conditional expression 。 

---

**参数类型**
* 方法可以有两种类型的参数：必需的和可选的。 必需的参数在参数列表前面， 后面是可选参数。 

**Optional parameters（可选参数）**
* 数可以是命名参数或者基于位置的参数，但是这两种参数不能同时当做可选参数。 

**Optional named parameters（可选命名参数）**
* 调用方法的时候，你可以使用这种形式   paramName : value   来指定命名参数。例如： enableFlags(bold: true , hidden: false ); 
* 在定义方法的时候，使用   {param1 , param2 , …}   的形式来指定命名参数： 

```dart
/// Sets the [bold] and [hidden] flags to the values 
/// you specify. 
enableFlags({ bool bold, bool hidden}) { 
  // ... 
} 
```

**Optional positional parameters（可选位置参数）**
* 把一些方法的参数放到   []   中就变成可选 位置参数了： 
```dart
String say( String from, String msg, [ String device]) { 
  var result = '$from says $msg' ; 
  if (device != null ) { 
    result = '$result with a $device' ; 
  } 
  return result; 
} 
```

* 下面是不使用可选参数调用上面方法 的示例： 
```dart
assert (say( 'Bob' , 'Howdy' ) == 'Bob says Howdy' ); 
```

* 下面是使用可选参数调用上面方法的示例： 
```dart
assert (say( 'Bob' , 'Howdy' , 'smoke signal' ) == 
    'Bob says Howdy with a smoke signal' ); 
```

**Default parameter values（默认参数值）**
* 在定义方法的时候，可以使用   =   来定义可选参数的默认值。 默认值只能是编译时常量。 如果没有提供默认值，则默认值为   null 。 
* 设置可选参数默认值的示例：

```dart
/// Sets the [bold] and [hidden] flags to the values you 
/// specify, defaulting to false. 
void enableFlags({ bool bold = false , bool hidden = false }) { 
  // ... 
} 

// bold will be true; hidden will be false. 
enableFlags(bold: true ); 
```

* 版本问题：   就版本代码可能需要使用一个冒号 ( : ) 而不是   =   来设置参数默认值。 原因在于 Dart SDK 1.21 之前的版本，命名参数只支持   : 。   :   设置命名默认参数值在以后版本中将不能使用， 所以我们推荐你   使用   =   来设置默认值， 并   指定 Dart SDK 版本为 1.21 或者更高的版本。 
* 显示了如何设置位置参数的默认值：

```dart
String say( String from, String msg, 
    [ String device = 'carrier pigeon' , String mood]) { 
  var result = '$from says $msg' ; 
  if (device != null ) { 
    result = '$result with a $device' ; 
  } 
  if (mood != null ) { 
    result = '$result (in a $mood mood)' ; 
  } 
  return result; 
} 

assert (say( 'Bob' , 'Howdy' ) == 
    'Bob says Howdy with a carrier pigeon' ); 
```

* 使用 list 或者 map 作为默认值
* 还可以使用 list 或者 map 作为默认值。 下面的示例定义了一个方法   doStuff() ， 并分别为   list   和   gifts   参数指定了 默认值。 

```dart
void doStuff( 
    { List < int > list = const [ 1 , 2 , 3 ], 
    Map < String , String > gifts = const { 
      'first' : 'paper' , 
      'second' : 'cotton' , 
      'third' : 'leather' 
    }}) { 
  print( 'list:  $list' ); 
  print( 'gifts: $gifts' ); 
} 
```

---

**The main() function（入口函数）**
* 每个应用都需要有个顶级的   main()   入口方法才能执行。   main()   方法的返回值为   void   并且有个可选的   List< String >   参数。 
* 一个 web 应用的 main() 方法

```dart
void main() { 
  querySelector( "#sample_text_id" ) 
    ..text = "Click me!" 
    ..onClick.listen(reverseText); 
} 
```

* 注意：   前面代码中的   ..   语法为  级联调用 （ cascade ）。 使用级联调用语法， 你可以在一个对象上执行多个操作。 
* 一个命令行应用的 main() 方法，并且使用了 方法参数作为输入参数：
* 下面是一个命令行应用的   main()   方法，并且使用了 方法参数作为输入参数： 

```dart
// Run the app like this: Dart args.Dart 1 test 
void main( List < String > arguments) { 
  print(arguments); 

  assert (arguments.length == 2 ); 
  assert ( int .parse(arguments[ 0 ]) == 1 ); 
  assert (arguments[ 1 ] == 'test' ); 
} 
```

* 你可以使用  args library   来 定义和解析命令行输入的参数数据。 

---

**Functions as first-class objects（一等方法对象）**
* 可以把方法当做参数调用另外一个方法。例如： 

```dart
printElement(element) { 
  print(element); 
} 

var list = [ 1 , 2 , 3 ]; 

// Pass printElement as a parameter. 
list.forEach(printElement); 
```

* 方法也可以赋值给一个变量： 

```dart
var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!' ; 
assert (loudify( 'hello' ) == '!!! HELLO !!!' ); 
```

* 上面的方法为 下面即将介绍的匿名方法。 

---

**Anonymous functions（匿名方法）**
* 大部分方法都带有名字，例如   main()   或者   printElement() 。 你有可以创建没有名字的方法，称之为匿名方法，有时候也被称为  lambda   或者  closure 闭包。 你可以把匿名方法赋值给一个变量， 然后你可以使用这个方法，比如添加到集合或者从集合中删除。 
* 没有名字的方法，称之为 匿名方法，有时候也被称为 lambda 或者 closure 闭包
* 例子：

```dart
([[Type ] param1 [, …]]) {  
  codeBlock ;  
};  
```

* 下面的代码定义了一个参数为 i   （该参数没有指定类型）的匿名函数。 list 中的每个元素都会调用这个函数来 打印出来，同时来计算了每个元素在 list 中的索引位置。 

```dart
var list = [ 'apples' , 'oranges' , 'grapes' , 'bananas' , 'plums' ]; 
list.forEach((i) { 
  print(list.indexOf(i).toString() + ': ' + i); 
}); 
```

* 如果方法只包含一个语句，可以使用胖箭头语法缩写。
* 如果方法只包含一个语句，可以使用胖箭头语法缩写。 把下面的代码粘贴到 DartPad 中运行，可以看到结果是一样的。 

```dart
list.forEach((i) => print(list.indexOf(i).toString() + ': ' + i)); 
```

---

**Lexical scope（静态作用域）**
* 和 Java 作用域 类似。
* Dart 是静态作用域语言，变量的作用域在写代码的时候就确定过了。 基本上大括号里面定义的变量就 只能在大括号里面访问，和 Java 作用域 类似。 
* 作用域的一个 示例：

```dart
var topLevel = true ; 

main() { 
  var insideMain = true ; 

  myFunction() { 
    var insideFunction = true ; 

    nestedFunction() { 
      var insideNestedFunction = true ; 
    
      assert (topLevel); 
      assert (insideMain); 
      assert (insideFunction); 
      assert (insideNestedFunction); 
    } 
  } 
} 
```

* 注意   nestedFunction()   可以访问所有的变量， 包含顶级变量。 

---

**Lexical closures（词法闭包）**
* 一个   闭包   是一个方法对象，不管该对象在何处被调用， 该对象都可以访问其作用域内 的变量。 
* 方法可以封闭定义到其作用域内的变量。 下面的示例中， makeAdder()   捕获到了变量   addBy 。 不管你在那里执行   makeAdder()   所返回的函数，都可以使用   addBy   参数。 

```dart
/// Returns a function that adds [addBy] to the 
/// function's argument. 
Function makeAdder( num addBy) { 
  return ( num i) => addBy + i; 
} 

main() { 
  // Create a function that adds 2. 
  var add2 = makeAdder( 2 ); 

  // Create a function that adds 4. 
  var add4 = makeAdder( 4 ); 

  assert (add2( 3 ) == 5 ); 
  assert (add4( 3 ) == 7 ); 
} 
```

* Testing functions for equality（测试函数是否相等）
* 下面是测试顶级方法、静态函数和实例函数 相等的示例

```dart
foo() {}               // A top-level function 

class A { 
  static void bar() {} // A static method 
  void baz() {}        // An instance method 
} 

main() { 
  var x; 

  // Comparing top-level functions. 
  x = foo; 
  assert (foo == x); 

  // Comparing static methods. 
  x = A .bar; 
  assert ( A .bar == x); 

  // Comparing instance methods. 
  var v = new A (); // Instance #1 of A 
  var w = new A (); // Instance #2 of A 
  var y = w; 
  x = w.baz; 

  // These closures refer to the same instance (#2), 
  // so they're equal. 
  assert (y.baz == x); 

  // These closures refer to different instances, 
  // so they're unequal. 
  assert (v.baz != w.baz); 
} 
```

---

**Return values（返回值）**
* 所有的函数都返回一个值。如果没有指定返回值，则 默认把语句   return null;   作为函数的最后一个语句执行。 

### Dart的Exceptions异常

* 代码中可以出现异常和捕获异常。异常表示一些 未知的错误情况。如果异常没有捕获， 则异常会抛出，导致 抛出异常的代码终止执行。 
* 和 Java 不同的是，所有的 Dart 异常是非检查异常。 方法不一定声明了他们所抛出的异常， 并且你不要求捕获任何异常。 
* Dart 提供了Exception和Error类型， 以及一些子类型。你还 可以定义自己的异常类型。但是， Dart 代码可以 抛出任何非 null 对象为异常，不仅仅是实现了 Exception 或者 Error 的对象。 
* 捕获异常可以避免异常继续传递（你重新抛出 rethrow 异常除外）。 捕获异常给你一个处理 该异常的机会：

```dart
try { 
  breedMoreLlamas(); 
} on OutOfLlamasException { 
  buyMoreLlamas(); 
}
```

* 对于可以抛出多种类型异常的代码，你可以指定 多个捕获语句。每个语句分别对应一个异常类型， 如果捕获语句没有指定异常类型，则 该可以捕获任何异常类型： 

```dart
try { 
  breedMoreLlamas(); 
} on OutOfLlamasException { 
  // A specific exception 
  buyMoreLlamas(); 
} on Exception catch (e) { 
  // Anything else that is an exception 
  print( 'Unknown exception: $e' ); 
} catch (e) { 
  // No specified type, handles all 
  print( 'Something really unknown: $e' ); 
} 
```

* 如之前代码所示，你可以使用 on   或者   catch   来声明捕获语句，也可以 同时使用。使用   on   来指定异常类型，使用   catch   来 捕获异常对象。 
* 函数   catch()   可以带有一个或者两个参数， 第一个参数为抛出的异常对象， 第二个为堆栈信息 ( 一个  StackTrace   对象 ) 。 

```dart
} on Exception catch (e) { 
  print( 'Exception details:\n $e' ); 
} catch (e, s) { 
  print( 'Exception details:\n $e' ); 
  print( 'Stack trace:\n $s' ); 
} 
```

* 使用   rethrow   关键字可以 把捕获的异常给 重新抛出。 

```dart
final foo = '' ; 

void misbehave() { 
  try { 
    foo = "You can't change a final variable's value." ; 
  } catch (e) { 
    print( 'misbehave() partially handled ${e.runtimeType}.' ); 
    rethrow; // Allow callers to see the exception. 
  } 
} 

void main() { 
  try { 
    misbehave(); 
  } catch (e) { 
    print( 'main() finished handling ${e.runtimeType}.' ); 
  } 
} 
```

---

**Throw抛出**
* 下面是抛出或者   扔出一个异常的示例： throw new FormatException ( 'Expected at least 1 section' ); 
* 还可以抛出任意的对象： throw 'Out of llamas!' ; 
* 由于抛出异常是一个表达式，所以可以在 => 语句中使用，也可以在其他能使用表达式的地方抛出异常。

```dart
distanceTo( Point other) => 
    throw new UnimplementedError (); 
```

* 抛出任意的对象：
* 还可以抛出任意的对象： throw 'Out of llamas!' ; 
* 下面是抛出或者   扔出一个异常的示例： 

```dart
throw new FormatException ( 'Expected at least 1 section' ); 
```

----

**Catch捕获**
* 捕获异常给你一个处理 该异常的机会：
* 可以使用on 或者 catch 来声明捕获语句，也可以 同时使用
* 使用 on 来指定异常类型，使用 catch 来 捕获异常对象。
* 使用 rethrow 关键字可以 把捕获的异常给 重新抛出。
  
```dart  
final foo = '' ; 

void misbehave() { 
  try { 
    foo = "You can't change a final variable's value." ; 
  } catch (e) { 
    print( 'misbehave() partially handled ${e.runtimeType}.' ); 
    rethrow; // Allow callers to see the exception. 
  } 
} 

void main() { 
  try { 
    misbehave(); 
  } catch (e) { 
    print( 'main() finished handling ${e.runtimeType}.' ); 
  } 
} 
```

* 函数 catch() 可以带有一个或者两个参数， 第一个参数为抛出的异常对象， 第二个为堆栈信息 (一个 StackTrace 对象)。

```dart
  ... 
} on Exception catch (e) { 
  print( 'Exception details:\n $e' ); 
} catch (e, s) { 
  print( 'Exception details:\n $e' ); 
  print( 'Stack trace:\n $s' ); 
} 
```

* 对于可以抛出多种类型异常的代码，你可以指定 多个捕获语句。每个语句分别对应一个异常类型， 如果捕获语句没有指定异常类型，则 该可以捕获任何异常类型：

```dart
try { 
  breedMoreLlamas(); 
} on OutOfLlamasException { 
  // A specific exception 
  buyMoreLlamas(); 
} on Exception catch (e) { 
  // Anything else that is an exception 
  print( 'Unknown exception: $e' ); 
} catch (e) { 
  // No specified type, handles all 
  print( 'Something really unknown: $e' ); 
} 
```

**Finally**
* 要确保某些代码执行，不管有没有出现异常都需要执行，可以使用 一个 finally 语句来实现。
* 要确保某些代码执行，不管有没有出现异常都需要执行，可以使用 一个   finally   语句来实现。如果没有   catch   语句来捕获异常， 则在执行完   finally   语句后， 异常被抛出了： 

```dart
try { 
  breedMoreLlamas(); 
} finally { 
  // Always clean up, even if an exception is thrown. 
  cleanLlamaStalls(); 
} 
```

* 定义的   finally   语句在任何匹配的   catch   语句之后执行： 

```dart
try { 
  breedMoreLlamas(); 
} catch (e) { 
  print( 'Error: $e' );  // Handle the exception first. 
} finally { 
  cleanLlamaStalls();  // Then clean up. 
} 
```

* 详情请参考  Exceptions   部分。 

### [Dart的Classes](http://Dart.goodev.org/guides/language/language-tour#a-basic-Dart-program%E4%B8%80%E4%B8%AA%E6%9C%80%E5%9F%BA%E6%9C%AC%E7%9A%84-Dart-%E7%A8%8B%E5%BA%8F)

* 使用 ?. 来替代 . 可以避免当左边对象为 null 时候 抛出异常：
* 使用   ?.   来替代   .   可以避免当左边对象为 null 时候 抛出异常：

```dart
// If p is non-null, set its y value to 4. 
p?.y = 4 ; 
```

---

**Instance variables**
* 所有没有初始化的变量值都是   null 。 
* 每个实例变量都会自动生成一个  getter   方法（隐含的）。 Non-final 实例变量还会自动生成一个  setter 方法。详情， 参考  Getters and setters 。 

```dart
class Point { 
  num x; 
  num y; 
} 

main() { 
  var point = new Point (); 
  point.x = 4 ;          // Use the setter method for x. 
  assert (point.x == 4 ); // Use the getter method for x. 
  assert (point.y == null ); // Values default to null. 
}
```

* 如果你在实例变量定义的时候初始化该变量（不是 在构造函数或者其他方法中初始化），改值是在实例创建的时候 初始化的，也就是在构造函数和初始化参数列 表执行之前。 
* 下面是如何定义实例变量的示例：

```dart
class Point { 
  num x; // Declare instance variable x, initially null. 
  num y; // Declare y, initially null. 
  num z = 0 ; // Declare z, initially 0. 
} 
```

---

**Constructors**
* 常见的构造函数生成一个 对象的新实例：
* 定义一个和类名字一样的方法就定义了一个构造函数 还可以带有其他可选的标识符，详情参考  Named constructors ) （命名构造函数）。 常见的构造函数生成一个 对象的新实例： 

```dart
class Point { 
  num x; 
  num y; 

  Point ( num x, num y) { 
    // There's a better way to do this, stay tuned. 
    this .x = x; 
    this .y = y; 
  } 
} 
```

* this   关键字指当前的实例。 
* 注意：   只有当名字冲突的时候才使用   this 。否则的话， Dart 代码风格样式推荐忽略   this 。 
* 由于把构造函数参数赋值给实例变量的场景太常见了， Dart 提供了一个语法糖来简化这个操作： 

```dart
class Point { 
  num x; 
  num y; 

  // Syntactic sugar for setting x and y 
  // before the constructor body runs. 
  Point ( this .x, this .y); 
} 
```

**Default constructors（默认构造函数）**
* 如果你没有定义构造函数，则会有个默认构造函数。 默认构造函数没有参数，并且会调用超类的 没有参数的构造函数。 

**Constructors aren’t inherited（构造函数不会继承）**
* 子类不会继承超类的构造函数。 子类如果没有定义构造函数，则只有一个默认构造函数 （没有名字没有参数）。 

**Named constructors（命名构造函数）**
* 使用命名构造函数可以为一个类实现多个构造函数， 或者使用命名构造函数来更清晰的表明你的意图： 

```dart
class Point { 
  num x; 
  num y; 

  Point ( this .x, this .y); 

  // Named constructor 
  Point .fromJson( Map json) { 
    x = json[ 'x' ]; 
    y = json[ 'y' ]; 
  } 
}
```

* 注意：构造函数不能继承，所以超类的命名构造函数 也不会被继承。如果你希望 子类也有超类一样的命名构造函数， 你必须在子类中自己实现该构造函数。 

**Invoking a non-default superclass constructor（调用超类构造函数）**
* 默认情况下，子类的构造函数会自动调用超类的 无名无参数的默认构造函数。 超类的构造函数在子类构造函数体开始执行的位置调用。 如果提供了一个  initializer list （初始化参数列表） ，则初始化参数列表在超类构造函数执行之前执行。 下面是构造函数执行顺序： 
	* initializer list （初始化参数列表） 
	* superclass’s no-arg constructor （超类的无名构造函数） 
	* main class’s no-arg constructor （主类的无名构造函数） 
* 如果超类没有无名无参数构造函数， 则你需要手工的调用超类的其他构造函数。 在构造函数参数后使用冒号 ( : ) 可以调用 超类构造函数。 
* 由于超类构造函数的参数在构造函数执行之前执行，所以 参数可以是一个表达式或者 一个方法调用： 

```dart
class Employee extends Person { 
  // ... 
  Employee () : super .fromJson(findDefaultData()); 
} 
```

* 注意：   如果在构造函数的初始化列表中使用   super() ，需要把它放到最后。 详情参考  Dart 最佳实践 。 
* 警告：   调用超类构造函数的参数无法访问   this 。 例如，参数可以为静态函数但是不能是实例函数。 

---

**Initializer list（初始化列表）**
* 在构造函数体执行之前除了可以调用超类构造函数之外，还可以 初始化实例参数。 使用逗号分隔初始化表达式。 

```dart
class Point { 
  num x; 
  num y; 

  Point ( this .x, this .y); 

  // Initializer list sets instance variables before 
  // the constructor body runs. 
  Point .fromJson( Map jsonMap) 
      : x = jsonMap[ 'x' ], 
        y = jsonMap[ 'y' ] { 
    print( 'In Point.fromJson(): ($x, $y)' ); 
  } 
} 
```

* 警告：   初始化表达式等号右边的部分不能访问   this 。 

---

**Redirecting constructors（重定向构造函数）**
* 有时候一个构造函数会调动类中的其他构造函数。 一个重定向构造函数是没有代码的，在构造函数声明后，使用 冒号调用其他构造函数。

```dart
  class Point { 
  num x; 
  num y; 

  // The main constructor for this class. 
  Point ( this .x, this .y); 

  // Delegates to the main constructor. 
  Point .alongXAxis( num x) : this (x, 0 ); 
} 
```

---

**Constant constructors（常量构造函数）**
* 如果你的类提供一个状态不变的对象，你可以把这些对象 定义为编译时常量。要实现这个功能，需要定义一个   const   构造函数， 并且声明所有类的变量为   final 。 

```dart
class ImmutablePoint { 
  final num x; 
  final num y; 
  const ImmutablePoint ( this .x, this .y); 
  static final ImmutablePoint origin = 
      const ImmutablePoint ( 0 , 0 ); 
} 
```

---

**Factory constructors（工厂方法构造函数）**
* 如果一个构造函数并不总是返回一个新的对象，则使用   factory   来定义 这个构造函数。例如，一个工厂构造函数 可能从缓存中获取一个实例并返回，或者 返回一个子类型的实例。 
下面代码演示工厂构造函数 如何从缓存中返回对象。 

```dart
class Logger { 
  final String name; 
  bool mute = false ; 

  // _cache is library-private, thanks to the _ in front 
  // of its name. 
  static final Map < String , Logger > _cache = 
      < String , Logger >{}; 

  factory Logger ( String name) { 
    if (_cache.containsKey(name)) { 
      return _cache[name]; 
    } else { 
      final logger = new Logger ._internal(name); 
      _cache[name] = logger; 
      return logger; 
    } 
  } 

  Logger ._internal( this .name); 

  void log( String msg) { 
    if (!mute) { 
      print(msg); 
    } 
  } 
} 
```

* 注意：   工厂构造函数无法访问   this 。 
* 使用   new   关键字来调用工厂构造函数。 

```dart
var logger = new Logger ( 'UI' ); 
logger.log( 'Button clicked' ); 
```

* 下面代码演示工厂构造函数 如何从缓存中返回对象。

```dart
class Logger { 
  final String name; 
  bool mute = false ; 

  // _cache is library-private, thanks to the _ in front 
  // of its name. 
  static final Map < String , Logger > _cache = 
      < String , Logger >{}; 

  factory Logger ( String name) { 
    if (_cache.containsKey(name)) { 
      return _cache[name]; 
    } else { 
      final logger = new Logger ._internal(name); 
      _cache[name] = logger; 
      return logger; 
    } 
  } 

  Logger ._internal( this .name); 

  void log( String msg) { 
    if (!mute) { 
      print(msg); 
    } 
  } 
} 
```

---

**Methods（函数）**
* 函数是类中定义的方法，是类对象的行为。

**Instance methods（实例函数）**
* 对象的实例函数可以访问   this 。 例如下面示例中的   distanceTo()   函数 就是实例函数： 

```dart
import 'Dart:math' ; 

class Point { 
  num x; 
  num y; 
  Point ( this .x, this .y); 

  num distanceTo( Point other) { 
    var dx = x - other.x; 
    var dy = y - other.y; 
    return sqrt(dx * dx + dy * dy); 
  } 
} 
```

---

**Getters and setters**
* Getters 和 setters 是用来设置和访问对象属性的特殊 函数。每个实例变量都隐含的具有一个 getter ， 如果变量不是 final 的则还有一个 setter 。 你可以通过实行 getter 和 setter 来创建新的属性， 使用   get   和   set   关键字定义 getter 和 setter ： 

```dart
class Rectangle { 
  num left; 
  num top; 
  num width; 
  num height; 

  Rectangle ( this .left, this .top, this .width, this .height); 

  // Define two calculated properties: right and bottom. 
  num get right             => left + width; 
      set right( num value)  => left = value - width; 
  num get bottom            => top + height; 
      set bottom( num value) => top = value - height; 
} 

main() { 
  var rect = new Rectangle ( 3 , 4 , 20 , 15 ); 
  assert (rect.left == 3 ); 
  rect.right = 12 ; 
  assert (rect.left == - 8 ); 
} 
```

* getter 和 setter 的好处是，你可以开始使用实例变量，后来 你可以把实例变量用函数包裹起来，而调用你代码的地方不需要修改。 
* 注意：   像 (++) 这种操作符不管是否定义 getter 都会正确的执行。 为了避免其他副作用， 操作符只调用 getter 一次，然后 把其值保存到一个临时变量中。 

---

**Abstract methods（抽象函数）**
* 实例函数、 getter 、和 setter 函数可以为抽象函数， 抽象函数是只定义函数接口但是没有实现的函数，由子类来 实现该函数。如果用分号来替代函数体则这个函数就是抽象函数。 

```dart
abstract class Doer { 
  // ...Define instance variables and methods... 

  void doSomething(); // Define an abstract method. 
} 

class EffectiveDoer extends Doer { 
  void doSomething() { 
    // ...Provide an implementation, so the method is not abstract here... 
  } 
} 
```

* 调用一个没实现的抽象函数会导致运行时异常。 
* 另外参考  抽象类 。 

---

**Overridable operators（可覆写的操作符）**
* 下表中的操作符可以被覆写。 例如，如果你定义了一个 Vector 类， 你可以定义一个   +   函数来实现两个向量相加。 

```
< 
+ 
| 
[] 
> 
/ 
^ 
[]= 
<= 
~/ 
& 
~ 
>= 
* 
<< 
== 
– 
% 
>> 
```

* 下面是覆写了   +   和   -   操作符的示例： 

```dart
class Vector { 
  final int x; 
  final int y; 
  const Vector ( this .x, this .y); 

  /// Overrides + (a + b). 
  Vector operator +( Vector v) { 
    return new Vector (x + v.x, y + v.y); 
  } 

  /// Overrides - (a - b). 
  Vector operator -( Vector v) { 
    return new Vector (x - v.x, y - v.y); 
  } 
} 

main() { 
  final v = new Vector ( 2 , 3 ); 
  final w = new Vector ( 2 , 2 ); 

  // v == (2, 3) 
  assert (v.x == 2 && v.y == 3 ); 

  // v + w == (4, 5) 
  assert ((v + w).x == 4 && (v + w).y == 5 ); 

  // v - w == (0, 1) 
  assert ((v - w).x == 0 && (v - w).y == 1 ); 
} 
```

* 如果你覆写了   ==   ，则还应该覆写对象的   hashCode  getter 函数。 关于 覆写   ==   和   hashCode   的示例请参考  实现 map 的 keys 。 
关于覆写的更多信息请参考  扩展类 。 

---

**Abstract classes（抽象类）**
* 抽象类通常用来定义接口， 以及部分实现。
* 如果你希望你的抽象类 是可示例化的，则定义一个 工厂 构造函数。
* 使用   abstract   修饰符定义一个   抽象类 — 一个不能被实例化的类。 抽象类通常用来定义接口， 以及部分实现。如果你希望你的抽象类 是可示例化的，则定义一个  工厂 构造函数 。 
* 抽象类通常具有  抽象函数 。 下面是定义具有抽象函数的 抽象类的示例： 

```
// This class is declared abstract and thus 
// can't be instantiated. 
abstract class AbstractContainer { 
  // ...Define constructors, fields, methods... 

  void updateChildren(); // Abstract method. 
} 
```

* 下面的类不是抽象的，但是定义了一个抽象函数，这样 的类是可以被实例化的： 

```
class SpecializedContainer extends AbstractContainer { 
  // ...Define more constructors, fields, methods... 

  void updateChildren() { 
    // ...Implement updateChildren()... 
  } 

  // Abstract method causes a warning but 
  // doesn't prevent instantiation. 
  void doSomething(); 
} 
```

---

**Implicit interfaces（隐式接口）**
* 每个类都隐式的定义了一个包含所有实例成员的接口， 并且这个类实现了这个接口。如果你想 创建类 A 来支持 类 B 的 api ，而不想继承 B 的实现， 则类 A 应该实现 B 的接口。 
* 下面是实现多个接口 的示例：

```dart
class Point implements Comparable , Location { 
  // ... 
} 
```

* 一个类可以通过 implements 关键字来实现一个或者多个接口， 并实现每个接口定义的 API。 例如

```dart
// A person. The implicit interface contains greet(). 
class Person { 
  // In the interface, but visible only in this library. 
  final _name; 

  // Not in the interface, since this is a constructor. 
  Person ( this ._name); 

  // In the interface. 
  String greet(who) => 'Hello, $who. I am $_name.' ; 
} 

// An implementation of the Person interface. 
class Imposter implements Person { 
  // We have to define this, but we don't use it. 
  final _name = "" ; 

  String greet(who) => 'Hi $who. Do you know who I am?' ; 
} 

greetBob( Person person) => person.greet( 'bob' ); 

main() { 
  print(greetBob( new Person ( 'kathy' ))); 
  print(greetBob( new Imposter ())); 
} 
```

---

**Extending a class（扩展类）**
* 用 @proxy 注解来避免警告信息：
* 如果你使用   noSuchMethod()   函数来实现每个可能的 getter 、 setter 、 以及其他类型的函数，你可以使用   @proxy   注解来避免警告信息： 

```dart
@proxy 
class A { 
  void noSuchMethod( Invocation mirror) { 
    // ... 
  } 
} 
```

* 使用 @override 注解来 表明你的函数是想覆写超类的一个函数：
* 还可以使用   @override   注解来 表明你的函数是想覆写超类的一个函数： 

```dart
class A { 
  @override 
  void noSuchMethod( Invocation mirror) { 
    // ... 
  } 
} 
```

* 子类可以覆写实例函数，getter 和 setter。
* 子类可以覆写实例函数， getter 和 setter 。 下面是覆写 Object 类的   noSuchMethod()   函数的例子， 如果调用了对象上不存在的函数，则就会触发   noSuchMethod()   函 数。 

```dart
class A { 
  // Unless you override noSuchMethod, using a 
  // non-existent member results in a NoSuchMethodError. 
  void noSuchMethod( Invocation mirror) { 
    print( 'You tried to use a non-existent member:' + 
          '${mirror.memberName}' ); 
  } 
} 
```

* 使用 extends 定义子类， supper 引用 超类：

```dart
class Television { 
  void turnOn() { 
    _illuminateDisplay(); 
    _activateIrSensor(); 
  } 
  // ... 
} 

class SmartTelevision extends Television { 
  void turnOn() { 
    super .turnOn(); 
    _bootNetworkInterface(); 
    _initializeMemory(); 
    _upgradeApps(); 
  } 
  // ... 
} 
```

* 如果你知道编译时的具体类型，则可以 实现这些类来避免警告，和 使用 @proxy 效果一样：

```dart
class A implements SomeClass , SomeOtherClass { 
  void noSuchMethod( Invocation mirror) { 
    // ... 
  } 
} 
```

---

**Enumerated types（枚举类型）**
* 可以在  switch 语句   中使用枚举。 如果在   switch (e )   中的  e   的类型为枚举类， 如果你没有处理所有该枚举类型的值的话，则会抛出一个警告： 

```dart
enum Color { 
  red, 
  green, 
  blue 
} 
// ... 
Color aColor = Color .blue; 
switch (aColor) { 
  case Color .red: 
    print( 'Red as roses!' ); 
    break ; 
  case Color .green: 
    print( 'Green as grass!' ); 
    break ; 
  default : // Without this, you see a WARNING. 
    print(aColor);  // 'Color.blue' 
}
```

* 枚举类型具有如下的限制： 
	* 无法继承枚举类型、无法使用 mix in 、无法实现一个枚举类型 
	* 无法显示的初始化一个枚举类型 
* 详情请参考  Dart 语言规范 。 
* 枚举的 values 常量可以返回 所有的枚举值。

```dart
List < Color > colors = Color .values; 
assert (colors[ 2 ] == Color .blue); 
```

* 使用 enum 关键字来定义枚举类型：

```
enum Color { 
  red, 
  green, 
  blue 
}
```

* 枚举类型中的每个值都有一个 index getter 函数， 该函数返回该值在枚举类型定义中的位置（从 0 开始）。 例如，第一个枚举值的位置为 0， 第二个为 1.

```dart
assert ( Color .red.index == 0 ); 
assert ( Color .green.index == 1 ); 
assert ( Color .blue.index == 2 ); 
```

* Adding features to a class: mixins（为类添加新的功能）
* 注意：   从 Dart 1.13 开始， 这两个限制在 Dart VM 上 没有那么严格了： 
	* Mixins 可以继承其他类，不再限制为继承 Object 
	* Mixins 可以调用   super() 。 
* 这种 “super mixins” 还  无法在 Dart2js 中使用   并且需要在 Dartanalyzer 中使用   --supermixin   参数。 
* 详情，请参考  Mixins in Dart 。 
* Mixins 是一种在多类继承中重用 一个类代码的方法。
* 使用 with 关键字后面为一个或者多个 mixin 名字来使用 mixin。

```dart
class Musician extends Performer with Musical { 
  // ... 
} 

class Maestro extends Person 
    with Musical , Aggressive , Demented { 
  Maestro ( String maestroName) { 
    name = maestroName; 
    canConduct = true ; 
  } 
} 
```

* 定义一个类继承 Object，该类没有构造函数， 不能调用 super ，则该类就是一个 mixin

```dart
abstract class Musical { 
  bool canPlayPiano = false ; 
  bool canCompose = false ; 
  bool canConduct = false ; 

  void entertainMe() { 
    if (canPlayPiano) { 
      print( 'Playing piano' ); 
    } else if (canConduct) { 
      print( 'Waving hands' ); 
    } else { 
      print( 'Humming to self' ); 
    } 
  } 
} 
```


**Class variables and methods（类变量和函数）**
* 使用 static 关键字来实现类级别的变量和函数。
* Static variables（静态变量）
* 静态变量对于类级别的状态是 非常有用的：

```dart
class Color { 
  static const red = 
      const Color ( 'red' ); // A constant static variable. 
  final String name;      // An instance variable. 
  const Color ( this .name); // A constant constructor. 
} 

main() { 
  assert ( Color .red.name == 'red' ); 
}
```

* 静态变量在第一次使用的时候才被初始化。 
* 注意：   这里准守代码风格推荐   命名规则，使用   lowerCamelCase   来命名常量。 

**Static methods（静态函数）**
* 静态函数不在类实例上执行， 所以无法访问 this。

```dart
import 'Dart:math' ; 

class Point { 
  num x; 
  num y; 
  Point ( this .x, this .y); 

  static num distanceBetween( Point a, Point b) { 
    var dx = a.x - b.x; 
    var dy = a.y - b.y; 
    return sqrt(dx * dx + dy * dy); 
  } 
} 

main() { 
  var a = new Point ( 2 , 2 ); 
  var b = new Point ( 4 , 4 ); 
  var distance = Point .distanceBetween(a, b); 
  assert (distance < 2.9 && distance > 2.8 ); 
} 
```

* 对于通用的或者经常使用的静态函数，考虑 使用顶级方法而不是静态函数。
* 静态函数还可以当做编译时常量使用。例如， 你可以把静态函数当做常量构造函数的参数来使用。

### Dart的CallableClasses可调用的类

**Isolates**
* 现代的浏览器以及移动浏览器都运行在多核 CPU 系统上。 要充分利用这些 CPU ，开发者一般使用共享内存 数据来保证多线程的正确执行。然而， 多线程共享数据通常会导致很多潜在的问题，并导致代码运行出错。 
* 所有的 Dart 代码在  isolates   中运行而不是线程。 每个 isolate 都有自己的堆内存，并且确保每个 isolate 的状态都不能被其他 isolate 访问。 


**Typedefs**
* 使用 typedef, 或者 function-type alias 来为方法类型命名， 然后可以使用命名的方法。
  
---

* 在 Dart 语言中，方法也是对象。 使用  typedef , 或者  function-type alias   来为方法类型命名， 然后可以使用命名的方法。 当把方法类型赋值给一个变量的时候， typedef 保留类型信息。 
* 下面的代码没有使用 typedef ： 

```dart
class SortedCollection { 
  Function compare; 

  SortedCollection ( int f( Object a, Object b)) { 
    compare = f; 
  } 
} 

  // Initial, broken implementation. 
  int sort( Object a, Object b) => 0 ; 

main() { 
  SortedCollection coll = new SortedCollection (sort); 

  // 我们只知道 compare 是一个 Function 类型， 
  // 但是不知道具体是何种 Function 类型？ 
  assert (coll.compare is Function ); 
} 
```

* 当把   f   赋值给   compare   的时候， 类型信息丢失了。   f   的类型是   (Object, Object)   →   int  ( 这里 → 代表返回值类型 ) ， 当然该类型是一个 Function 。如果我们使用显式的名字并保留类型信息， 开发者和工具可以使用 这些信息： 

```dart
typedef int Compare ( Object a, Object b); 

class SortedCollection { 
  Compare compare; 

  SortedCollection ( this .compare); 
} 

  // Initial, broken implementation. 
  int sort( Object a, Object b) => 0 ; 

main() { 
  SortedCollection coll = new SortedCollection (sort); 
  assert (coll.compare is Function ); 
  assert (coll.compare is Compare ); 
} 
```

* 注意：   目前， typedefs 只能使用在 function 类型上，但是将来 可能会有变化。 
* 由于 typedefs 只是别名，他们还提供了一种 判断任意 function 的类型的方法。例如： 

```dart
typedef int Compare ( int a, int b); 

int sort( int a, int b) => a - b; 

main() { 
  assert (sort is Compare ); // True! 
} 
```

### Dart的Numbers

* Numbers（数值）2019.2.13
* 字符串和数字之间转换的方式
* Dart 支持两种类型的数字： 
* int  :整数值，其取值通常位于 -2 53   和 2 53   之间。 
* double :64-bit ( 双精度 ) 浮点数，符合 IEEE 754 标准。 
* int   和   double   都是  num   的子类。 num 类型定义了基本的操作符，例如 +, -, /, 和 * ， 还定义了 abs() 、  ceil() 、和   floor()   等 函数。 ( 位操作符，例如 >> 定义在   int   类中。 ) 如果 num 或者其子类型不满足你的要求，请参考  Dart:math   库。 
* 注意：   不在 -2 53   到 2 53   范围内的整数在 Dart 中的行为 和 JavaScript 中表现不一样。 原因在于 Dart 具有任意精度的整数，而 JavaScript 没有。 参考  问题 1533   了解更多信息。 
* 整数是不带小数点的数字。下面是一些定义 整数的方式： 

```dart
var x = 1 ; 
var hex = 0xDEADBEEF ; 
var bigInt = 34653465834652437659238476592374958739845729 ; 
```

* 如果一个数带小数点，则其为 double ， 下面是定义 double 的一些方式： 

```dart
var y = 1.1 ; 
var exponents = 1.42e5 ; 
```

* 下面是字符串和数字之间转换的方式： 

```dart
// String -> int 
var one = int .parse( '1' ); 
assert (one == 1 ); 

// String -> double 
var onePointOne = double .parse( '1.1' ); 
assert (onePointOne == 1.1 ); 

// int -> String 
String oneAsString = 1. toString(); 
assert (oneAsString == '1' ); 

// double -> String 
String piAsString = 3.14159 .toStringAsFixed( 2 ); 
assert (piAsString == '3.14' ); 
```

* 整数类型支持传统的位移操作符， (<<, >>), AND (&), 和 OR (|) 。例如：

```dart
assert (( 3 << 1 ) == 6 );  // 0011 << 1 == 0110 
assert (( 3 >> 1 ) == 1 );  // 0011 >> 1 == 0001 
assert (( 3 | 4 )  == 7 );  // 0011 | 0100 == 0111 
```

* 数字字面量为编译时常量。 很多算术表达式 只要其操作数是常量，则表达式结果 也是编译时常量。 

```dart
const msPerSecond = 1000 ; 
const secondsUntilRetry = 5 ; 
const msUntilRetry = secondsUntilRetry * msPerSecond; 
```

### Dart的Keyword关键字

* Keywords（关键字）2019.2.13
* 带有上标 1 的关键字是 内置关键字。避免把内置关键字当做标识符使用。 也不要把内置关键字 用作类名字和类型名字。 有些内置关键字是为了方便把 JavaScript 代码移植到 Dart 而存在的。 例如，如果 JavaScript 代码中有个变量的名字为 factory， 在移植到 Dart 中的时候，你不必重新命名这个变量。
* 带有上标 2 的关键字，是在 Dart 1.0 发布以后又新加的，用于 支持异步相关的特性。 你不能在标记为 async、 async*、或者 sync* 的方法体内 使用 async、 await、或者 yield 作为标识符。 详情请参考：异步支持。

**下表为 Dart 语言的关键字**

```dart
abstract  1 
continue 
false 
new 
this 
as  1 
default 
final 
null 
throw 
assert 
deferred  1 
finally 
operator  1 
true 
async  2 
do 
for 
part  1 
try 
async*  2 
dynamic  1 
get  1 
rethrow 
typedef  1 
await  2 
else 
if 
return 
var 
break 
enum 
implements  1 
set  1 
void 
case 
export  1 
import  1 
static  1 
while 
catch 
external  1 
in 
super 
with 
class 
extends 
is 
switch 
yield  2 
const 
factory  1 
library  1 
sync*  2 
yield*  2 
```

### Dart的AsynchronySupport异步支持

** Dart 有一些语言特性来支持 异步编程**
* 最常见的特性是 async 方法和 await 表达式。
* Dart 库中有很多返回 Future 或者 Stream 对象的方法。 这些方法是 异步的
* 有两种方式可以使用 Future 对象中的 数据：
	* 使用 async 和 await
	* 使用 Future API
* 从 Stream 中获取数据也有两种 方式：
	* 使用 async 和一个 异步 for 循环 (await for)
	* 使用 Stream API

---

**要使用 await，其方法必须带有 async 关键字：**

```dart
checkVersion() async { 
  var version = await lookUpVersion(); 
  if (version == expectedVersion) { 
    // Do something. 
  } else { 
    // Do something else. 
  } 
} 
```

---

** Declaring async functions（声明异步方法）**
* 一个  async 方法   是函数体被标记为   async   的方法。 虽然异步方法的执行可能需要一定时间，但是 异步方法立刻返回 - 在方法体还没执行之前就返回了。 

```dart
checkVersion() async { 
  // ... 
} 

lookUpVersion() async => /* ... */ ; 
```

* 在一个方法上添加   async   关键字，则这个方法返回值为 Future 。 例如，下面是一个返回字符串 的同步方法： 

```dart
String lookUpVersionSync() => '1.0.0' ;
```

* 如果使用 async 关键字，则该方法 返回一个 Future ，并且 认为该函数是一个耗时的操作。

```dart
Future < String > lookUpVersion() async => '1.0.0' ; 
```

* 注意，方法的函数体并不需要使用 Future API 。 Dart 会自动在需要的时候创建 Future 对象。 
* 一个 async 方法 是函数体被标记为 async 的方法。
* 在一个方法上添加 async 关键字，则这个方法返回值为 Future。

```dart
String lookUpVersionSync() => '1.0.0' ; 
```

* 如果使用 async 关键字，则该方法 返回一个 Future，并且 认为该函数是一个耗时的操作。

```dart
Future < String > lookUpVersion() async => '1.0.0' ; 
```

** Using await expressions with Futures（使用 await 表达式）**

* await 表达式具有如下的形式： 
* await expression 
* 在一个异步方法内可以使用多次   await   表达式。 例如，下面的示例使用了三次   await   表达式 来执行相关的功能： 

```dart
var entrypoint = await findEntrypoint(); 
var exitCode = await runExecutable(entrypoint, args); 
await flushThenExit(exitCode); 
```

* 在   await expression   中，   expression   的返回值通常是一个 Future ； 如果返回的值不是 Future ，则 Dart 会自动把该值放到 Future 中返回。 Future 对象代表返回一个对象的承诺（ promise ）。   awaitexpression   执行的结果为这个返回的对象。 await expression 会阻塞住，直到需要的对象返回为止。 
* 如果   await   无法正常使用，请确保是在一个 async 方法中。   例如要在   main()   方法中使用   await ， 则   main()   方法的函数体必须标记为   async ：

```dart
main() async { 
  checkVersion(); 
  print( 'In main: version is ${await lookUpVersion()}' ); 
} 
```

* 在 await expression 中， expression 的返回值通常是一个 Future；
* 如果返回的值不是 Future，则 Dart 会自动把该值放到 Future 中返回。
* Future 对象代表返回一个对象的承诺（promise）。
* await expression 执行的结果为这个返回的对象。
* await expression 会阻塞住，直到需要的对象返回为止。
* 如要在 main() 方法中使用 await， 则 main() 方法的函数体必须标记为 async：

```dart
main() async { 
  checkVersion(); 
  print( 'In main: version is ${await lookUpVersion()}' ); 
} 
```

** Using asynchronous for loops with Streams（在循环中使用异步）**

* 异步 for 循环具有如下的形式：

```dart
await for (variable declaration in expression ) { 
  // Executes each time the stream emits a value. 
} 
```

* 上面   expression   返回的值必须是 Stream 类型的。 执行流程如下： 
	* 等待直到 stream 返回一个数据 
	* 使用 stream 返回的参数 执行 for 循环代码， 
	* 重复执行 1 和 2 直到 stream 数据返回完毕。 
* 使用   break   或者   return   语句可以 停止接收 stream 的数据， 这样就跳出了 for 循环并且 从 stream 上取消注册了。 
* 如果异步 for 循环不能正常工作， 确保是在一个 async 方法中使用。   例如，要想在   main()   方法中使用异步 for 循环，则需要把   main()   方法的函数体标记为   async ：

```dart
main() async { 
  ... 
  await for ( var request in requestServer) { 
    handleRequest(request); 
  } 
  ... 
} 
```

* 关于异步编程的更多信息，参考  Dart:async 。 另外还 可以参考  Dart Language Asynchrony Support: Phase 1   和  Dart Language Asynchrony Support: Phase 2 ， 以及  Dart 语言规范 。

### Dart的Comments注释

**Dart 支持单行注释、多行注释和 文档注释。**

**Single-line comments**
* 单行注释以   //   开始。   //   后面的一行内容 为 Dart 代码注释。 

```dart
main() { 
  // TODO: refactor into an AbstractLlamaGreetingFactory? 
  print( 'Welcome to my Llama farm!' ); 
} 
```

**Multi-line comments**
* 多行注释以   /*   开始，   */   结尾。 多行注释 可以 嵌套。

```dart
main() { 
  /* 
   * This is a lot of work. Consider raising chickens. 

  Llama larry = new Llama(); 
  larry.feed(); 
  larry.exercise(); 
  larry.clean(); 
   */ 
} 
```

**Documentation comments**
* 文档注释可以使用 /// 开始， 也可以使用 /** 开始 并以 */ 结束。
* 文档注释可以使用   ///   开始， 也可以使用   /**   开始 并以 */ 结束。 
* 在文档注释内， Dart 编译器忽略除了中括号以外的内容。 使用中括号可以引用 classes 、 methods 、 fields 、 top-level variables 、 functions 、 和 parameters 。中括号里面的名字使用 当前注释出现地方的语法范围查找对应的成员。 
* 下面是一个引用其他类和成员 的文档注释： 

```dart
/// A domesticated South American camelid (Lama glama). 
/// 
/// Andean cultures have used llamas as meat and pack 
/// animals since pre-Hispanic times. 
class Llama { 
  String name; 

  /// Feeds your llama [Food]. 
  /// 
  /// The typical llama eats one bale of hay per week. 
  void feed( Food food) { 
    // ... 
  } 

  /// Exercises your llama with an [activity] for 
  /// [timeLimit] minutes. 
  void exercise( Activity activity, int timeLimit) { 
    // ... 
  } 
} 
```

* 在生成的文档中， [Food]   变为一个连接 到 Food 类 API 文档的链接。 
* 使用 SDK 中的  文档生成工具 可以解析文档并生成 HTML 网页。 关于生成的文档示例，请参考  Dart API 文档。   关于如何 组织文档的建议，请参考  Dart 文档注释指南。 

### Dart的Important concepts（重要的概念）2019.2.13

* 如果一个标识符以 (_) 开头，则该标识符 在库内是私有的。
* 在学习 Dart 的时候，请牢记下面一些事实和 概念
* 所有能够使用变量引用的都是对象， 每个对象都是一个类的实例。在 Dart 中 甚至连 数字、方法和 null 都是对象。所有的对象都继承于 Object 类。

---

* 所有能够使用变量引用的都是对象， 每个对象都是一个类的实例。在 Dart 中 甚至连 数字、方法和   null   都是对象。所有的对象都继承于  Object   类。 
* 使用静态类型 ( 例如前面示例中的   num  ) 可以更清晰的表明你的意图，并且可以让静态分析工具来分析你的代码， 但这并不是牵制性的。（在调试代码的时候你可能注意到 没有指定类型的变量的类型为   dynamic 。） 
* Dart 在运行之前会先解析你的代码。你可以通过使用 类型或者编译时常量来帮助 Dart 去捕获异常以及 让代码运行的更高效。
* Dart 支持顶级方法 ( 例如   main() ) ，同时还支持在类中定义函数。 （静态函数和实例函数）。 你还可以在方法中定义方法 （嵌套方法或者局部方法）。 
* 同样， Dart 还支持顶级变量，以及 在类中定义变量（静态变量和实例变量）。 实例变量有时候被称之为域（ Fields ）或者属性（ Properties ）。 
* 和 Java 不同的是， Dart 没有   public 、   protected 、 和   private   关键字。如果一个标识符以 (_) 开头，则该标识符 在库内是私有的。详情请参考：  库和可见性 。 
* 标识符可以以字母或者 _ 下划线开头，后面可以是 其他字符和数字的组合。 
* 有时候   表达式 expression   和   语句 statement   是有区别的，所以这种情况我们会分别指明每种情况。 
* Dart 工具可以指出两种问题：警告和错误。 警告只是说你的代码可能有问题， 但是并不会阻止你的代码执行。 错误可以是编译时错误也可以是运行时错误。遇到编译时错误时，代码将 无法执行；运行时错误将会在运行代码的时候导致一个  异常 。 

### Dart的HttpPackage网络请求

```dart
dependencies:
  ...
  http: ^0.11.3+16

import 'Dart:convert';
import 'package:flutter/material.Dart';
import 'package:http/http.Dart' as http;
[...]
  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
```

### Dart的Booleans（布尔值）2019.2.13

* 为了代表布尔值， Dart 有一个名字为bool的类型。 只有两个对象是布尔类型的： true   和   false   所创建的对象， 这两个对象也都是编译时常量。
* 当 Dart 需要一个布尔值的时候，只有true对象才被认为是 true 。 所有其他的值都是 flase 。这点和 JavaScript 不一样， 像数字1 、 字符串"aString" 、 以及someObject等值都被认为是 false 。 
* 例如，下面的代码在 JavaScript 和 Dart 中都是合法的代码： 

```dart
var name = 'Bob' ; 
if (name) { 
  // Prints in JavaScript, not in Dart. 
  print( 'You have a name!' ); 
} 
```

* 如果在 JavaScript 中运行，则会打印出 “You have a name!” ，在 JavaScript 中   name   是非 null 对象所以认为是 true 。但是在 Dart 的生产模式下运行，这不会打印任何内容，原因是name被转换为 false了，原因在于name != true 。 如果在 Dart  检查模式运行，上面的 代码将会抛出一个异常，表示   name   变量不是一个布尔值。 
* 下面是另外一个在 JavaScript 和 Dart 中表现不一致的示例：

```dart
if ( 1 ) { 
  print( 'JS prints this line.' ); 
} else { 
  print( 'Dart in production mode prints this line.' ); 
  // However, in checked mode, if (1) throws an 
  // exception because 1 is not boolean. 
} 
```

* 注意：上面两个示例只能在 Dart 生产模式下运行， 在检查模式下，会抛出异常表明变量不是所期望的布尔类型。 
* Dart 这样设计布尔值，是为了避免奇怪的行为。很多 JavaScript代码都遇到这种问题。 对于你来说，在写代码的时候你不用这些写代码： if (nonbooleanValue ) ，你应该显式的 判断变量是否为布尔值类型。例如：

```dart
// Check for an empty string. 
var fullName = '' ; 
assert (fullName.isEmpty); 

// Check for zero. 
var hitPoints = 0 ; 
assert (hitPoints <= 0 ); 

// Check for null. 
var unicorn; 
assert (unicorn == null ); 

// Check for NaN. 
var iMeantToDoThis = 0 / 0 ; 
assert (iMeantToDoThis.isNaN); 
```

* 当 Dart 需要一个布尔值的时候，只有 true 对象才被认为是 true。 所有其他的值都是 flase。
* 意思就是true才行 

----

* 布尔例子

```dart
if (1) { 
  print( 'JS prints this line.' ); 
} else { 
  print( 'Dart in production mode prints this line.' ); 
  // However, in checked mode, if (1) throws an 
  // exception because 1 is not boolean. 
} 
```


###  Flutter的Dart语言简介

**   Dart和JavaScript做一个对比**  
* 开发效率高
	* 基于JIT的快速开发周期：Flutter在开发阶段采用，采用JIT模式，这样就避免了每次改动都要进行编译，极大的节省了开发时间；
	* 基于AOT的发布包: Flutter在发布时可以通过AOT生成高效的ARM代码以保证应用性能。而JavaScript则不具有这个能力。
	* Dart 运行时和编译器支持 Flutter 的两个关键特性的组合：
	* 基于 JIT 的快速开发周期 ： Flutter 在开发阶段采用，采用 JIT 模式，这样就避免了每次改动都要进行编译，极大的节省了开发时间；
	* 基于 AOT 的发布包 : Flutter 在发布时可以通过 AOT 生成高效的 ARM 代码以保证应用性能。而 JavaScript 则不具有这个能力。  
* 高性能
	* Flutter 旨在提供流畅、高保真的的 UI 体验。为了实现这一点， Flutter 中需要能够在每个动画帧中运行大量的代码。这意味着需要一种既能提供高性能的语言，而不会出现会丢帧的周期性暂停，而 Dart 支持 AOT ，在这一点上可以做的比 JavaScript 更好 
* 快速内存分配
	* Flutter 框架使用函数式流，这使得它在很大程度上依赖于底层的内存分配器。因此，拥有一个能够有效地处理琐碎任务的内存分配器将显得十分重要，在缺乏此功能的语言中， Flutter 将无法有效地工作。当然 Chrome V8 的 JavaScript 引擎在内存分配上也已经做的很好，事实上 Dart 开发团队的很多成员都是来自 Chrome 团队的，所以在内存分配上 Dart 并不能作为超越 JavaScript 的优势，而对于 Flutter 来说，它需要这样的特性，而 Dart 也正好满足而已。 
* 类型安全
	* 由于 Dart 是类型安全的语言，支持静态类型检测，所以可以在编译前发现一些类型的错误，并排除潜在问题，这一点对于前端开发者来说可能会更具有吸引力。与之不同的， JavaScript 是一个弱类型语言，也因此前端社区出现了很多给 JavaScript 代码添加静态类型检测的扩展语言和工具，如：微软的 TypeScript 以及 Facebook 的 Flow 。相比之下， Dart 本身就支持静态类型，这是它的一个重要优势。 
* Dart团队就在你身边
	* 看似不起眼，实则举足轻重。由于有 Dart 团队的积极投入， Flutter 团队可以获得更多、更方便的支持，正如 Flutter 官网所述 “ 我们正与 Dart 社区进行密切合作，以改进 Dart 在 Flutter 中的使用。例如，当我们最初采用 Dart 时，该语言并没有提供生成原生二进制文件的工具链（这对于实现可预测的高性能具有很大的帮助），但是现在它实现了，因为 Dart 团队专门为 Flutter 构建了它。同样， Dart VM 之前已经针对吞吐量进行了优化，但团队现在正在优化 VM 的延迟时间，这对于 Flutter 的工作负载更为重要。 ” 

* JavaScript 的弱类型一直被抓短，所以 TypeScript 、 Coffeescript 甚至是 Facebook 的 flow （虽然并不能算 JavaScript 的一个超集，但也通过标注和打包工具提供了静态类型检查）才有市场。就笔者使用过的脚本语言中（笔者曾使用过 Python 、 PHP ）， JavaScript 无疑是动态化 支持最好的脚本语言，比如在 JavaScript 中，可以给任何对象在任何时候动态扩展属性，对于精通 JavaScript 的高手来说，这无疑是一把利剑。但是，任何事物都有两面性， JavaScript 的强大的动态化特性也是把双刃剑，你可经常听到另一个声音，认为 JavaScript 的这种动态性糟糕透了，太过灵活反而导致代码很难预期，无法限制不被期望的修改。毕竟有些人总是对自己或别人写的代码不放心，他们希望能够让代码变得可控，并期望有一套静态类型检查系统来帮助自己减少错误。正因如此，在 Flutter 中， Dart 几乎放弃了脚本语言动态化的特性，如不支持反射、也不支持动态创建函数等。并且 Dart 在 2.0 强制开启了类型检查（ Strong Mode ），原先的检查模式（ checked mode ）和可选类型（ optional type ）将淡出，所以在类型安全这个层面来说， Dart 和 TypeScript 、 Coffeescript 是差不多的，所以单从这一点来看， Dart 并不具备什么明显优势，但综合起来看， Dart 既能进行服务端脚本、 APP 开发、 web 开发，这就有优势了！ 
* 综上所述，笔者还是很看好 Dart 语言的将来，之所以表这个态，是因为在新技术发展初期，很多人可能还有所摇摆，有所犹豫，所以有必要给大家打一剂强心针，当然，这是一个见仁见智的问题，大家可以各抒己见。 

**   Dart在静态语法方面和Java非常相似**  

* Dart vs Java
* 客观的来讲， Dart 在语法层面确实比 Java 更有表现力；在 VM 层面， Dart VM 在内存回收和吞吐量都进行了反复的优化，但具体的性能对比，笔者没有找到相关测试数据，但在笔者看来，只要 Dart 语言能流行， VM 的性能就不用担心，毕竟 Google 在 go （没用 vm 但有 GC ）、 javascript （ v8 ）、 dalvik （ android 上的 java vm ）上已经有了很多技术积淀。值得注意的是 Dart 在 Flutter 中已经可以将 GC 做到 10ms 以内，所以 Dart 和 Java 相比，决胜因素并不会是在性能方面。而在语法层面， Dart 要比 java 更有表现力，最重要的是 Dart 对函数式编程支持要远强于 Java( 目前只停留在 lamda 表达式 ) ，而 Dart 目前真正的不足是生态 ，但笔者相信，随着 Flutter 的逐渐火热，会回过头来反推 Dart 生态加速发展，对于 Dart 来说，现在需要的是时间。 

**   变量声明**  

* var
	
```

// 类似于 JavaScript 中的 var ，它可以接收任何类型的变量，但最大的不同是 Dart 中 var 变量一旦赋值，类型便会确定，则不能再改变其类型，如： 
var t ; 
t = "hi world" ; 

// 下面代码在 Dart 中会报错，因为变量 t 的类型已经确定为 String ， 
// 类型一旦确定后则不能再更改其类型。 
t = 1000 ; 

// 上面的代码在 JavaScript 是没有问题的，前端开发者需要注意一下，之所以有此差异是因为 Dart 本身是一个强类型语言，任何变量都是有确定类型的，在 Dart 中，当用 var 声明一个变量后， Dart 在编译时会根据第一次赋值数据的类型来推断其类型，编译结束后其类型就已经被确定，而 JavaScript 是纯粹的弱类型脚本语言， var 只是变量的声明方式而已。 

```


* dynamic和Object
	
	
```

Dynamic 和 Object   与   var 功能相似，都会在赋值时自动进行类型推断，不同在于，赋值后可以改变其类型，如： 
dynamic t ; 
t = "hi world" ; 
// 下面代码没有问题 
t = 1000 ; 
Object   是 Dart 所有对象的根基类，也就是说所有类型都是 Object 的子类，所以任何类型的数据都可以赋值给 Object 声明的对象，所以表现效果和 dynamic 相似。

```

* inal和const
	
```

// 如果您从未打算更改一个变量，那么使用   final   或   const ，不是 var ，也不是一个类型。 一个   final 变量只能被设置一次，两者区别在于： const   // 变量是一个编译时常量， final 变量在第一次使用时被初始化。被 final 或者 const 修饰的变量，变量类型可以省略，如： 

// 可以省略 String 这个类型声明 
final str = "hi world" ; 

//final String str = "hi world";  
const str1 = "hi world" ; 

//const String str1 = "hi world"; 

```

**   函数**  
* Dart 是一种真正的面向对象的语言，所以即使是函数也是对象，并且有一个类型 Function 。这意味着函数可以赋值给变量或作为参数传递给其他函数，这是函数式编程的典型特征。 

* 函数声明


```

bool isNoble ( int atomicNumber ) { 
  return _nobleGases [ atomicNumber ] != null ; 
} 
Dart 函数声明如果没有显式声明返回值类型时会默认当做 dynamic 处理，注意，函数返回值没有类型推断： 
typedef bool CALLBACK (); 

// 不指定返回类型，此时默认为 dynamic ，不是 bool 
isNoble ( int atomicNumber ) { 
  return _nobleGases [ atomicNumber ] != null ; 
} 

void test ( CALLBACK cb ){ 
   print ( cb ());   
} 
// 报错， isNoble 不是 bool 类型 
test ( isNoble ); 

```

* 对于只包含一个表达式的函数，可以使用简写语法

```

bool isNoble （ int atomicNumber ） => _nobleGases [ atomicNumber ] ！ = null ; 

```

* 函数作为变量

```

var say = ( str ){ 
  print ( str ); 
}; 
say ( "hi world" ); 

```

* 函数作为参数传递

```

void execute ( var callback ){ 
    callback (); 
} 
execute (() => print ( "xxx" )) 

```

* 可选的位置参数

```

// 包装一组函数参数，用 [] 标记为可选的位置参数： 
String say ( String from , String msg , [ String device ]) { 
  var result = '$from says $msg' ; 
  if ( device != null ) { 
    result = '$result with a $device' ; 
  } 
  return result ; 
} 
// 下面是一个不带可选参数调用这个函数的例子： 
say ( 'Bob' , 'Howdy' ); // 结果是： Bob says Howdy 

// 下面是用第三个参数调用这个函数的例子： 
say ( 'Bob' , 'Howdy' , 'smoke signal' ); // 结果是： Bob says Howdy with a smoke signal 

```

* 可选的命名参数
  
```

定义函数时，使用 {param1, param2, …} ，用于指定命名参数。例如： 
// 设置 [bold] 和 [hidden] 标志 
void enableFlags ({ bool bold , bool hidden }) { 
    // ...  
} 
调用函数时，可以使用指定命名参数。例如： paramName: value 
enableFlags ( bold : true , hidden : false ); 
可选命名参数在 Flutter 中使用非常多。   

```

**   Stream**  

* Stream   也是用于接收异步事件数据，和 Future   不同的是，它可以接收多个异步操作的结果（成功或失败）。 也就是说，在执行异步任务时，可以通过多次触发成功或失败事件来传递结果数据或错误异常。   Stream   常用于会多次读取数据的异步任务场景，如网络内容下载、文件读写等。举个例子： 

```

Stream . fromFutures ([ 
  // 1 秒后返回结果 
  Future . delayed ( new Duration ( seconds : 1 ), () { 
    return "hello 1" ; 
  }), 
  // 抛出一个异常 
  Future . delayed ( new Duration ( seconds : 2 ),(){ 
    throw AssertionError ( "Error" ); 
  }), 
  // 3 秒后返回结果 
  Future . delayed ( new Duration ( seconds : 3 ), () { 
    return "hello 3" ; 
  }) 
]). listen (( data ){ 
   print ( data ); 
}, onError : ( e ){ 
   print ( e . message ); 
}, onDone : (){ 

}); 

上面的代码依次会输出： 
I/flutter (17666): hello 1 
I/flutter (17666): Error 
I/flutter (17666): hello 3 

```

* 代码很简单，就不赘述了。 
* 思考题：既然 Stream 可以接收多次事件，那能不能用 Stream 来实现一个订阅者模式的事件总线？ 


**   Async/await**  

* Dart 中的 async/await   和 JavaScript 中的 async/await 功能和用法是一模一样的，如果你已经了解 JavaScript 中的 async/await 的用法，可以直接跳过本节。 
* 回调地狱 (Callback hell) 
* 如果代码中有大量异步逻辑，并且出现大量异步任务依赖其它异步任务的结果时，必然会出现 Future.then 回调中套回调情况。举个例子，比如现在有个需求场景是用户先登录，登录成功后会获得用户 Id ，然后通过用户 Id ，再去请求用户个人信息，获取到用户个人信息后，为了使用方便，我们需要将其缓存在本地文件系统，代码如下： 


```

// 先分别定义各个异步任务 
Future < String > login ( String userName , String pwd ){ 
    ... 
    // 用户登录 
}; 
Future < String > getUserInfo ( String id ){ 
    ... 
    // 获取用户信息   
}; 
Future saveUserInfo ( String userInfo ){ 
    ... 
    // 保存用户信息   
}; 
接下来，执行整个任务流： 
login ( "alice" , "******" ). then (( id ){ 
  // 登录成功后通过， id 获取用户信息     
  getUserInfo ( id ). then (( userInfo ){ 
    // 获取用户信息后保存   
    saveUserInfo ( userInfo ). then ((){ 
       // 保存用户信息，接下来执行其它操作 
        ... 
    }); 
  }); 
}) 

```

* 可以感受一下，如果业务逻辑中有大量异步依赖的情况，将会出现上面这种在回调里面套回调的情况，过多的嵌套会导致的代码可读性下降以及出错率提高，并且非常难维护，这个问题被形象的称为回调地狱（ Callback hell ） 。回调地狱问题在之前 JavaScript 中非常突出，也是 JavaScript 被吐槽最多的点，但随着 ECMAScript6 和 ECMAScript7 标准发布后，这个问题得到了非常好的解决，而解决回调地狱的两大神器正是 ECMAScript6 引入了 Promise ，以及 ECMAScript7 中引入的 async/await 。 而在 Dart 中几乎是完全平移了 JavaScript 中的这两者： Future 相当于 Promise ，而 async/await 连名字都没改。接下来我们看看通过 Future 和 async/await 如何消除上面示例中的嵌套问题。 
* 使用 Future 消除 callback hell 

```

login ( "alice" , "******" ). then (( id ){ 
      return getUserInfo ( id ); 
}). then (( userInfo ){ 
    return saveUserInfo ( userInfo ); 
}). then (( e ){ 
   // 执行接下来的操作   
}). catchError (( e ){ 
  // 错误处理   
  print ( e ); 
}); 

```

* 正如上文所述，  “ Future   的所有 API 的返回值仍然是一个 Future 对象，所以可以很方便的进行链式调用 ”   ，如果在 then 中返回的是一个 Future 的话，该 future 会执行，执行结束后会触发后面的 then 回调，这样依次向下，就避免了层层嵌套。 
* 使用 async/await 消除 callback hell 
* 通过 Future 回调中再返回 Future 的方式虽然能避免层层嵌套，但是还是有一层回调，有没有一种方式能够让我们可以像写同步代码那样来执行异步任务而不使用回调的方式？答案是肯定的，这就要使用 async/await 了，下面我们先直接看代码，然后再解释，代码如下： 

```

task () async { 
   try { 
    String id = await login ( "alice" , "******" ); 
    String userInfo = await getUserInfo ( id ); 
    await saveUserInfo ( userInfo ); 
    // 执行接下来的操作     
   } catch ( e ){ 
    // 错误处理     
    print ( e );     
   }   
} 

```

* async 用来表示函数是异步的，定义的函数会返回一个 Future 对象，可以使用 then 方法添加回调函数。 
* await   后面是一个 Future ，表示等待该异步任务完成，异步完成后才会往下走； await 必须出现在   async   函数内部。 
* 可以看到，我们通过 async/await 将一个异步流用同步的代码表示出来了。 
* 其实，无论是在 JavaScript 还是 Dart 中， async/await 都只是一个语法糖，编译器或解释器最终都会将其转化为一个 Promise （ Future ）的调用链。 


**  异步支持**  

* Dart 类库有非常多的返回 Future 或者 Stream 对象的函数。 这些函数被称为异步函数 ：它们只会在设置好一些耗时操作之后返回，比如像 IO 操作。而不是等到这个操作完成。 
* async 和 await 关键词支持了异步编程，运行您写出和同步代码很像的异步代码。 

**   Future**  
* Future 与 JavaScript 中的 Promise 非常相似，表示一个异步操作的最终完成（或失败）及其结果值的表示。简单来说，它就是用于处理异步操作的，异步处理成功了就执行成功的操作，异步处理失败了就捕获错误或者停止后续操作。一个 Future 只会对应一个结果，要么成功，要么失败。 
* 由于本身功能较多，这里我们只介绍其常用的 API 及特性。还有，请记住， Future   的所有 API 的返回值仍然是一个 Future 对象，所以可以很方便的进行链式调用。 

**   Future.then**  

* 为了方便示例，在本例中我们使用 Future.delayed   创建了一个延时任务（实际场景会是一个真正的耗时任务，比如一次网络请求），即 2 秒后返回结果字符串 "hi world!" ，然后我们在 then 中接收异步结果并打印结果，代码如下： 


```

Future . delayed ( new Duration ( seconds : 2 ),(){ 
   return "hi world!" ; 
}). then (( data ){ 
   print ( data ); 
}); 


```

**  Future.catchError**  

* 如果异步任务发生错误，我们可以在 catchError 中捕获错误，我们将上面示例改为： 

```

Future . delayed ( new Duration ( seconds : 2 ),(){ 
   //return "hi world!"; 
   throw AssertionError ( "Error" );   
}). then (( data ){ 
   // 执行成功会走到这里   
   print ( "success" ); 
}). catchError (( e ){ 
   // 执行失败会走到这里   
   print ( e ); 
}); 

```

* 在本示例中，我们在异步任务中抛出了一个异常， then 的回调函数将不会被执行，取而代之的是   catchError 回调函数将被调用；但是，并不是只有   catchError 回调才能捕获错误， then 方法还有一个可选参数 onError ，我们也可以它来捕获异常： 

```

Future . delayed ( new Duration ( seconds : 2 ), () { 
    //return "hi world!"; 
    throw AssertionError ( "Error" ); 
}). then (( data ) { 
    print ( "success" ); 
}, onError : ( e ) { 
    print ( e ); 
}); 

```

**  Future.whenComplete**  

* 有些时候，我们会遇到无论异步任务执行成功或失败都需要做一些事的场景，比如在网络请求前弹出加载对话框，在请求结束后关闭对话框。这种场景，有两种方法，第一种是分别在 then 或 catch 中关闭一下对话框，第二种就是使用 Future 的 whenComplete 回调，我们将上面示例改一下： 

```

Future . delayed ( new Duration ( seconds : 2 ),(){ 
   //return "hi world!"; 
   throw AssertionError ( "Error" ); 
}). then (( data ){ 
   // 执行成功会走到这里   
   print ( data ); 
}). catchError (( e ){ 
   // 执行失败会走到这里     
   print ( e ); 
}). whenComplete ((){ 
   // 无论成功或失败都会走到这里 
}); 

```

#### Future.wait

* 有些时候，我们需要等待多个异步任务都执行结束后才进行一些操作，比如我们有一个界面，需要先分别从两个网络接口获取数据，获取成功后，我们需要将两个接口数据进行特定的处理后再显示到 UI 界面上，应该怎么做？答案是 Future.wait ，它接受一个 Future 数组参数，只有数组中所有 Future 都执行成功后，才会触发 then 的成功回调，只要有一个 Future 执行失败，就会触发错误回调。下面，我们通过模拟 Future.delayed   来模拟两个数据获取的异步任务，等两个异步任务都执行成功时，将两个异步任务的结果拼接打印出来，代码如下： 

```

Future . wait ([ 
  // 2 秒后返回结果   
  Future . delayed ( new Duration ( seconds : 2 ), () { 
    return "hello" ; 
  }), 
  // 4 秒后返回结果   
  Future . delayed ( new Duration ( seconds : 4 ), () { 
    return " world" ; 
  }) 
]). then (( results ){ 
  print ( results [ 0 ] + results [ 1 ]); 
}). catchError (( e ){ 
  print ( e ); 
}); 

```

* 执行上面代码， 4 秒后你会在控制台中看到 “hello world” 。 

