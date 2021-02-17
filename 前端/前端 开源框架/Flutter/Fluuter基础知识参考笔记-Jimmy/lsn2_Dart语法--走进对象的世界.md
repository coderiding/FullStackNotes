# lsn2_Dart语法--走进对象的世界

[TOC]

## Dart语法概要
```dart
// 定义个方法。
printNumber(num aNumber) {
  print('The number is $aNumber.'); // 在控制台打印内容。
}

// 这是程序执行的入口。
main() {
  var number = 42; // 定义并初始化一个变量。
  printNumber(number); 
}
```
1. 所有的函数都返回一个值。如果没有指定返回值，则默认把语句return null;作为函数的最后一个语句执行。
2. main()，Dart程序执行的入口方法，每个程序都需要一个这样的方法。
- main()方法前面的void可有可没有。
- main()方法有一个可选的List<String>的参数,在Android studio 运行时需配置，如图：

![](1.png)

![](2.png)

3. var一种不指定类型声明变量的方式。
- Dart中一切皆对象，所以没有初始化的默认值都是null，null是Null类的唯一实例。
- 我们也可以申请一个具体类型，有助于编译工具帮我们补全代码，查找bug。例如：String name = 'Bob';
- 在代码风格中，使用var而不是具体的类型来定义局部变量。推荐的做法是在编写严格API时尽量使用类型声明(规定使用)，编写独立应用时尽量使用var声明(快速开发)。
- 想要知道具体类型，使用runtimeType
4. 42，是一个字面量。字面量是编译时常量。
5. num是一个类型(类型接口)。
6. print()打印语句，${a+b}或者$a," ",' '都行
7. 注释和java中一样的

### 断言介绍
```
int lineCount;
assert(lineCount == null);//断言
//如果条件不为 true 则会抛出一个AssertionError异常。
```
## 内置类型
### Numbers（数值）
1. int 和 double 都是 num 的子类
2. num 类型定义了基本的操作符，例如 +, -, /, 和 *， 还定义了 abs()、 ceil()、和 floor() 等函数
```
int i = 1;
double d = 1.2;
num j = 1;
num k = 1.2;
```
### String
```
String str1 = 'abc';//单引号字符串
String str2 = "abc";//双引号字符串
//三个 ' 或 " (不能混合使用)来定义多行的String类型，注意str3和str4的显示区别
String str3 = '''abc
      def''';
String str4 = "abc"
  "def";
String str5 = "abc"+"def";//str4和str5是一样的
print("str1 = $str1");//abc
print("str2 = $str2");//abc
print("str3 = $str3");//abc \n def
print("str4 = $str4");//abcdef
print("str5 = $str5");//abcdef

//通过提供一个r前缀可以创建一个 “原始 raw” 字符串,原始字符串中没转义字符
var s = r"In a raw string, even \n isn't special."
print("s = $s");//In a raw string, even \n isn't special.
```
字符串和数值之间的转换
```
// String -> int
var one = int.parse('1');
assert(one == 1);

// String -> double
var onePointOne = double.parse('1.1');
assert(onePointOne == 1.1);

// int -> String
String oneAsString = 1.toString();
assert(oneAsString == '1');

// double -> String
String piAsString = 3.14159.toStringAsFixed(2);//四舍五入
assert(piAsString == '3.14');
```
### Booleans（布尔值）
只有true被认为是true，其他的都是false
```
if(1){}//错误
//下面的ok
if(1 != 0){}
if(true){}
if(false){}
```
### Lists（列表），runtimeType
在 Dart 中数组就是 List 对象
```
[1,2,3][1];//2
[1,2,3].length;//3
[].length;//0
[].isEmpty;//true
['a'].isEmpty;//false

var list1 = [1, 2, 3];
var list2 = ['a', 'b', 'c'];
var list3 = [1, 'a', 3];
print('list1 = $list1');//list1 = [1, 2, 3]
print('list2 = $list2');//list2 = [a, b, c]
print('list3 = $list3');//list3 = [1, a, 3]
print('${list3[0].runtimeType},${list3[1].runtimeType}');//int,String
var list4;
print('list4 = ${list4.runtimeType}');//返回Null
//runtimeType，返回(运行时类型)对象的类型
```
### Maps
```
var colors1 = {
// Keys      Values
  'first' : 'red',
  12: 'green',
  'third' : 'blue'
};
print('colors1 = $colors1');//colors1 = {first: red, 7: green, third: blue}
print(colors1[7]);//green

var colors2 = new Map();
colors2['first'] = 'red';
colors2['second'] = 'green';
colors2['third'] = 'blue';
//通过map中的key获取value,如果所查找的key不存在，则返回 null：
assert(colors2['first'] == 'red');
//获取长度
assert(colors2.length == 3);
```
### Runes
Dart字符串是一系列UTF-16代码单元，因此在字符串中表示32位Unicode值需要特殊语法。
Dart中使用String的runes来获取UTF-32字符集的字符。String的codeUnits和codeUnitAt属性可以获取UTF-16字符集的字符。
```
var clapping = '\u{1f44f}';
print(clapping);
print(clapping.codeUnits);
print(clapping.codeUnitAt(1));
print(clapping.runes.toList());

Runes input = new Runes(
  '\u2665  \u{1f605}  \u{1f60e}  \u{1f47b}  \u{1f596}  \u{1f44d}');
print(new String.fromCharCodes(input));
```

## Functions（方法）
Dart没有final方法，允许重写几乎所有方法（同样，部分内置的操作符例外）
```
//平时使用方式
String sayHello1(String name){
  return 'Hello $name!';
  //return print('Hello $name!');//print();方法返回的是void
}

//这样也是可以的，忽略类型定义
sayHello2(name){
  return 'Hello $name!';
}

//对于只有一个表达式的方法，你可以选择使用缩写语法来定义：
sayHello3(name) => 'Hello $name!';
//注意：在箭头 (=>) 和冒号 (;) 之间只能使用一个表达式 –- 不能使用语句。 表达式计算后通常会返回一个单独的值.
//例如下面这些，注释后面的就是表达式：
int i = 10;//i = 10
anArray[0] = 10;//anArray[0] = 100
int result = 1 + 2; // result = 1 + 2
if (value1 == value2)//value1 == value2

//方法也可以赋值给一个变量--类似函数指针
var sayHello4 = (name)=>'Hello $name!';
```
### 函数闭包
方法也是对象并且具有一种类型：Function。一个闭包是一个方法对象。
```
Function makeAdder(num addBy) {
  return (num i) => addBy + i;
}

main() {
  var add2 = makeAdder(2);//add2(num i) => 2 + i；
  var add4 = makeAdder(4);//add2(num i) => 4 + i；

  assert(add2(3) == 5);
  assert(add4(3) == 7);
}
```
### typedef
因为 typedef 是简单的别名，所以它提供了一种方法来检查任何函数的类型。比如：
```
typedef int Compare(int a, int b);

int sort(int a, int b) => a - b;

main() {
  assert(sort is Compare);
}

//请注意 目前 typedef 仅限于函数类型，我们期望这一点能有所改变。
```

### 方法可作为参数被调用
```
printNumber(name) {
  print(name);
}
var list = [1, 2, 3];

//可以把方法当做参数调用另外一个方法
list.forEach(printNumber);

//匿名方法
list.forEach((i){
    print(i);
}));
```

### 可选参数
分为：可选命名，可选位置
```
//可选命名,赋默认值的方式两种：等号'='或者冒号':'
FunA(a, {b, c:3, d:4, e})
{
  print('$a $b $c $d $e');
}
//可选位置，赋默认值只有一种方式：等号'='
FunB(a, [b, c=3, d=4, e])
{
  print('$a $b $c $d $e');
}
void main()
{
  FunA(1, b:3, d:5);//1 3 3 5 null
  FunB(1, 3, 5);//1 3 5 4 null
}

//可选参数为list,map的情况
void FunC(
    {List<int> list = const [1, 2, 3],
      Map<String, String> colors = const {
        'first': 'red',
        'second': 'green',
        'third': 'blue'
      }}) {
  print('list:  $list');
  print('colors: $colors');
}
```
## 操作符
### ~/ 除后取整
5 ~/ 2 = 2; 5 / 2 = 2.5
### as,is,is!
| 操作符 | 解释                           |
| ------ | ------------------------------ |
| as     | 类型转换                       |
| is     | 如果对象是指定的类型返回 True  |
| is!    | 如果对象是指定的类型返回 False |
```
//使用 as 操作符把对象转换为特定的类型。一般情况下，你可以把它当做用 is 判定类型然后调用所判定对象的函数的缩写形式

//is相当于instanceof
if (emp is Person) { // Type check
  emp.firstName = 'Bob';
}

(emp as Person).firstName = 'Bob';

//注意： 上面这两个代码效果是有区别的。如果 emp 是 null 或者不是 Person 类型， 则第一个示例使用 is 则不会执行条件里面的代码，而第二个情况使用 as 则会抛出一个异常。
```

### ??=
b ??= value; // 如果 b 是 null，则赋值给 b；如果不是 null，则 b 的值保持不变
### ??
```
String toString() => msg ?? super.toString();
String toString() => msg == null ? super.toString() : msg;
```
### ?.   
和.类似，但是左边的操作对象不能为 null，例如 foo?.bar 如果 foo 为 null 则返回 null，否则返回 bar 成员
### .. 级联语法
```
class Person {
    String name;
    String country;
    void setCountry(String country){
      this.country = country;
    }
    String toString() => 'Name:$name\nCountry:$country';
}
void main() {
  Person p = new Person();
  p ..name = 'Wang'
    ..setCountry('China');
  print(p);
}
//打印结果：
//Name:Wang
//Country:China
```
注意： 严格来说， 两个点的级联语法不是一个操作符。 只是一个 Dart 特殊语法。
### operator
```
//可以重写的操作符
<	+	|	[]
>	/	^	[]=
<=	~/	&	~
>=	*	<<	==
–	%	>>	
```
```
class myString{
  String str;

  myString(this.str);

  String operator +(myString s){
    return '${str}${s.str}';
  }
}

void main(){
  myString hello=new myString('Hello');
  myString world=new myString('World');
  print(hello+world);
}
```


