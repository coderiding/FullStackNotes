# Dart语法--对象的构建者以及操控者

[TOC]

## typedef

```
//没返回值，则只要参数匹配就行了，如果定义了返回值，则返回值不一样会报错
typedef Fun1(int a, int b);
typedef Fun2<T, K>(T a, K b);

int add(int a, int b) {
  print('a + b');
  return a + b;
}

class Demo1 {
  Demo1(int f(int a, int b), int x, int y) {
    var sum = f(x, y);
    print("sum1 = $sum");
  }
}

class Demo2 {
  Demo2(Fun1 f, int x, int y) {
    var sum = f(x, y);
    print("sum2 = $sum");
  }
}

class Demo3 {
  Demo3(Fun2<int, int> f, int x, int y) {
    var sum = f(x, y);
    print("sum3 = $sum");
  }
}

goTypedef() {
  Demo1 d1 = new Demo1(add, 2, 3);
  Demo2 d2 = new Demo2(add, 5, 6);
  Demo3 d3 = new Demo3(add, 5, 6);
}
```
## 泛型
Dart 的泛型类型是固化的，在运行时有也可以判断具体的类型。
```
void goGeneric() {
  //list
  var colors1 = <String>['red', 'green', 'blue'];
  //Map
  var colors2 = <String, String>{
    'first': 'red',
    'second': 'green',
    'third': 'blue'
  };

  var colors3 = new List<String>();
  colors3.addAll(['red', 'green', 'blue']);
  print(colors3 is List<String>); //java在运行时不判断泛型
}
```
## 控制语句
- if and else
- for loops
- while and do-while loops
- break and continue
- switch and case
- assert

### for
```
//List 和 Set 等实现了 Iterable 接口的类还支持 for-in 形式的遍历
void goFor(){
  //for-in  形式
  var collection = [0, 1, 2];
  for (var x in collection) {
    print(x);
  }

  //forEach形式
  List list = ['a','b','c'];
  list.forEach((i)=>print(i));
}
```
### while and do-while
```
void goWhile(){
  int a = 1;
  while(a < 5){
    print('goWhile a = $a');
    a++;
    if(a == 4){
      break;
    }
  }

  int b = 0;
  do{
    b ++;
    print('goWhile b = $b');
  }while(b < 0);
}
```
### Switch and case，enum
1. 每个非空的 case 语句都必须有一个 break 语句。 另外还可以通过 continue、throw 或者 return 来结束非空 case 语句。
2. case都必须是编译时常量，这些常量必须符合以下条件：
    - 都是int的实例
    - 都是String的实例
    - 都是同一个类的实例且该类必须从Object继承了==的实现
    - switch使用==比较，class必须没有覆写==操作符
```
void goSwitch() {
  switch ("flutter") {
    case "jimmy":
      print('hello jimmy');
      break;
    case "flutter":
      print("hello flutter");
      break;
  }
  //switch中使用枚举需要把所有枚举值case一边，或者加default，否则会有警告
  Color color = Color.red;
  switch (color) {
    case Color.red:
      break;
    case Color.blue:
      break;
    //case Color.green:
      //break;
    default:
  }
  switch (color) {
    case Color.red:
      print("color.red");
      continue goGreen;
    case Color.blue:
      print("color.blue");
      break;
    goGreen:
    case Color.green:
      print("color.green");
      break;
    default:
  }
}

enum Color { red, green, blue }
void goEnum() {
  print('Color.red = ${Color.red}');
  print('Color.red = ${Color.red.index}');
  
  //values 返回所有枚举值
  List<Color> colors = Color.values;
  assert(colors[2] == Color.blue);
}
```

## Exceptions（异常）
Throw 可以抛出任意对象
```
void goThrow() {
  try {
    getName2();
  } catch (e,s) {
    //函数 catch() 可以带有一个或者两个参数， 第一个参数为抛出的异常对象，
    // 第二个为堆栈信息 (一个 StackTrace 对象)。
    print("goThrow catch = $e,$s");
  } finally {
    print('goThrow finally');
  }
}

getName2() {
  //你可以使用on 或者 catch 来声明捕获语句，也可以同时使用。
  // 使用 on 来指定异常类型，使用 catch 来捕获异常对象。
  try {
    getName();
  } on Exception {
    print("getName2:Exception");
  } on NullThrownError catch (e) {
    print("getName2 on = $e");
    //使用 rethrow 关键字可以 把捕获的异常给 重新抛出。
    rethrow;
  } catch (e) {
    // 没指定类型，捕获任何异常类型
    print("getName2 catch $e");
  }
}

getName() {
  if (true) {
    throw new NullThrownError();
  }
}
```
### 构造函数
```
//java中写法
class Point1 {
  num x;
  num y;

  Point1(num x, num y) {
    this.x = x;
    this.y = y;
  }
}

//dart建议写法
class Point2 {
  num x;
  num y;
  Point2(this.x, this.y);
}
```
### 命名构造函数
Dart语言是不支持方法重载的。构造函数的重载也不支持，但是它支持命名构造函数。
```
Point2.fromJson(Map json) {
    x = json['x'];
    y = json['y'];
}
```
### 重定向构造函数
一个重定向构造函数是没有代码的，在构造函数声明后，使用冒号调用其他构造函数。
```
Point2.alongXAxis(num x) : this(x, 0);
```
### 超类构造函数
```
class Person {
  String firstName;
  Person(var a){
  }
  Person.fromJson(Map data) {
    print('in Person');
  }
}
class Point2 extends Person {
  Point2.fromJson(Map data) : super.fromJson(data) {
    print('in Point');
  }
}
void goPoint2() {
  var point = new Point2.fromJson({});
}
```
### Initializer list（初始化列表）
初始化列表非常适合用来设置 final 变量的值。
```
import 'dart:math';

class Point3 {
  final num x;
  final num y;
  final num distanceFromOrigin;

  Point3(x, y)
      : x = x,
        y = y,
        distanceFromOrigin = sqrt(x * x + y * y);
}

void goPoint3() {
  var p = new Point3(2, 3);
  print(p.distanceFromOrigin);
}
```
### 工厂构造函数
```
class A{
  String name;

  //注意： 工厂构造函数无法访问 this。所以这儿要静态的
  static A _cache;

  //工厂构造函数的关键字为factory
  factory A([String name = 'A']){
    if(A._cache == null){
      A._cache=new A._newObject(name);
    }
    return A._cache;
  }
  //需要一个命名构造函数用来生产实例
  A._newObject(this.name);
}

void goFactory(){
  A a = new A('HelloWorld');
  print(a.name);

  A b = new A('HelloDart');
  print(b.name);

  print(a == b);
}
```
### Getters and setters
```
class GetAndSet{
  num a;
  num b;
  GetAndSet(this.a,this.b);

  num get c{
    print('get c');
    return a + b;
  }
  set c(num value){
    print('set c');
    a = value +b;
  }
}

goGetAndSet() {
  var i = new GetAndSet(4,7);
  i.c = 4;
  var k = i.c;
  print('i.a = ${i.a},i.b = ${i.b},k = $k');
}
```
## 抽象类
```
abstract class Car {
  run();

  space() {}
}

class Bus extends Car {
  int width = 4;

  Bus(this.width);

  @override
  run() {
    print('Bus 起飞跑');
  }
}
```
## 接口
1. 每个类都隐式的定义了一个包含所有实例成员的接口， 并且这个类实现了这个接口。
2. 如果你想创建类A来支持类B的api，而不想继承B的实现，则类A应该实现类B的接口。
3. 一个类可以通过 implements 关键字来实现一个或者多个接口， 并实现每个接口定义的 API。
```
class BigBus implements Bus {
  @override
  int width;

  @override
  run() {
    // TODO: implement run
  }

  @override
  space() {
    // TODO: implement space
  }
}
```
## mixin
特性：
1. 传统的接口概念中，并不包含实现部分，而Mixin包含实现。

如何定义一个mixin的类：

1. 定义一个类继承 Object
2. 该类没有构造函数
3. 不能调用 super ，则该类就是一个 mixin
```
//可以是抽象的，也可以不是
class S {
//   a() {
//     print("S.a");
//   }
//   b() {
//     print("S.b");
//   }
//   c() {
//     print("S.c ");
//   }
}
class A {
  a() {
    print("A.a");
  }
  b() {
    print("A.b");
  }
}
class B {
  a() {
    print("B.a");
  }
  b() {
    print("B.b");
  }
  c() {
    print("B.c ");
  }
}
class T extends B with A,S{
}
// class T = B with A, S;
main() {
  T t = new T();
  t.a();
  t.b();
  t.c();
  assert(t is S);//ture
}
```