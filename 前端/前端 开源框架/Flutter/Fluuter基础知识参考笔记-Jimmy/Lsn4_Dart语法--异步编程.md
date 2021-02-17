## const与final
1. 区别一：final要求变量只能初始化一次，并不要求赋的值一定是编译时常量。而const要求在声明时初始化，并且赋值必需为编译时常量。
2. 区别二：final是惰性初始化，即在运行时第一次使用前才初始化。而 const 是在编译时就确定值了。
```
//这里 const 和 final 没有区别，因为变量 a 被立即赋值为一个数字常量
void test1() {
  var a1 = 1;
  const a2 = 1;
  final a3 = 1;

  int a4 = 1;
  const int a5 = 1;
  final int a6 = 1;
}
```
### 什么是编译时常量
指的是：字面量（如数字、bool、字符串、List的字面量形式）、其它常量或者常量的算术运算，也可以是这些的组合形式，简单地说常量就是可以在编译时确定的值。如下：
```
//const可以如下定义
void test2() {
  const a = 8;
  const b = false;
  const c = a;
  const d = 5 * 3;
  const e = a * d + 2;
}
```
而其它形式，比如实例化一个新的对象,一个函数调用的返回值就不是编译时常量了，它们在运行时才能获得结果。
```
void test3() {
  final x1 = new DateTime.now(); //ok
  const x2 = new DateTime.now();//error
}
```
### final 实例成员
```
//声明时直接初始化
class X1 {
  final a = 0;
}
//或构造方法中初始化
class X2 {
  final a;
  X2(this.a){
  }
}
//或初始化列表中初始化
class X3 {
  final a;
  X3(a): this.a = a{
  }
}
```
### const 实例成员
```dart
class X {
  //只能声明时直接初始化
  static const a = 0;//必须是static的
  X(){
  }
}
```
### 常量对象和常量构造函数
前面说的编译时常量还包括常量对象，也就是通过 const 构造函数创建的对象。
1. 所有实例成员都是 final 或 const 实例成员，那么该类所创建的对象的状态就是不可变的。
2. 定义 const 构造函数，const 构造函数所创建的对象就是常量对象。
3. 用 const 代替 new 来调用构造函数。
4. 可以用 new 调用 const 构造函数，但那样就不能用 const 声明该变量了。
5. const 构造函数也不能有函数体。
6. 常量对象还有一个特点，相同的常量对象始终只有一个。
```
class Constant {
  static const a = 1;
  final b;

  const Constant(this.b); //不能有函数体

  static const m = const Constant(3);
}

main(){
  const x1 = const Constant(3);// ok
  const x2 = new Constant(3);// error
  final x3 = const Constant(3);// ok
  final x4 = new Constant(5);// ok
  
  assert(x1 == x3);
  assert(x1 != x4);
}
```
区别三：const 可以修饰变量，也可以修饰值，而 final 只用来修饰变量。
```
void test4(){
  const list1 = [1, 2, 3]; // error
  const list2 = const [1, 2, 3];
  const list3 = const [new DateTime.now(), 2, 3]; // error, 因为new DateTime.now()不是const
  const list4 = const [const Constant(3), 2, 3];

  var x1 = 5;
  const list5 = const[x1]; //error，x1不是const
  
  const x2 = 5;
  const list6 = const[x2];

  final list7 = [1, 2, 3];
  final list8 = const [1, 2, 3];
  final list9 = const [new DateTime.now(), 2, 3];// error, 因为new DateTime.now()不是const
}
```
const 修饰值的时候，要求值必需是常量或由常量组成。var、final等在左边定义变量时，并不关心右边是不是常量。但如果右边用了const，那么不管左边是什么要求，右边都必需是常量。

## 异步
### Async和await
```
Future getName1() async {
  await getStr1();
  print('getName1');
}

getStr1() {
  print('getStr1');
}

getName2() {
  print('getName2');
}

getName3() {
  print('getName3');
}

goAsync() {
  getName1();
  getName2();
  getName3();
}
//输出结果
getStr1
getName2
getName3
getName1
```
1. return的类型为T，那么函数的返回类型应该为Future<T>，或T的父类，否则会产生静态警告。
2. 如果函数中return的类型是Future<T>，那么函数的返回类型同样为Future<T>，而不是Future<Future<T>>。
3. await表达式可以使用多次，但只能在async标记的函数中使用。

### Future
Future表示在将来某时获取一个值的方式。当一个返回Future的函数被调用的时候，做了两件事情：
1. 函数把自己放入队列和返回一个未完成的Future对象
2. 之后当值可用时，Future带着值变成完成状态。
```
  //1.使用then按指定顺序
  getName2().then((_) => getName1()).then((_) => getName3());
  //2.使用whenComplete()按指定顺序
  getName2().whenComplete(() {
    getName1().whenComplete(() {
      getName3();
    });
  });
  //3.使用wait,一并返回完成值
  Future.wait([getName2(), getName1(), getName3()])
      .then((List re) {
    re.forEach((i) => print(i));
  });
```
### Future与异常
```
//返回都是Future可以用链式结构
void goThrow() {
  new Future(() => print('start'))
      .then((_) => new Future.error("xxxxxx"))
      .whenComplete(() => print("run"))
      .then((_) => print("don't"))
      .catchError((e) => print(e));
}
```

```
//混合同步类型和异步类型的异常
main() {
 fun3().catchError((e){
   print('e = $e');
 });
}

fun1() {
  throw 'fun1 is error';
}

fun2() {
  throw 'fun2 is error';
}

//方法1：
//Future fun3(){
//  return new Future.sync((){
//    fun1();
//    return new Future(() {
//      fun2();
//    });
//  });
//}
//方法2：
Future fun3() async{
  fun1();
  return new Future(() {
    fun2();
  });
}
```

### 事件队列
1. Dart应用程序仅有一个消息循环，以及两个队列：event事件队列和microtask微任务队列。
2. 事件队列包含所有的外部事件，如：I/O、鼠标事件、定时器、Isolate之间的消息等等。

当main函数退出后，消息循环开始工作，首先FIFO的方式执行所有微任务。接着，从事件队列中提取消息并一条条处理，然后再执行所有的微任务，以此循环，直到所有队列为空。

#### 如何调度任务
dart:async包中提供的如下API：
1. Future类，可添加一个事件到事件队列的末尾；
2. 顶层函数 scheduleMicrotask()，可添加一个任务到微任务队列的末尾。

Future几点注意事项：
1. 当Future完成计算后，then()注册的回调函数会立即执行。需注意的是，then()注册的函数并不会添加到事件队列中，回调函数只是在事件循环中任务完成后被调用。
2. 如果Future在then()被调用之前已经完成计算，那么任务会被添加到微任务队列中，并且该任务会执行then()中注册的回调函数。
3. Future()和Future.delayed()构造函数并不会立即完成计算。
4. Future.value()构造函数在微任务中完成计算，其他类似第2条。
5. Future.sync()构造函数会立即执行函数，并在微任务中完成计算，其他类似第2条。
```
//demo1
import 'dart:async';

main() async {
  Future f1 = new Future(() => null);
  Future f2 = new Future(() => null);
  Future f3 = new Future(() => null);

  f3.then((_) => print("1"));

  f2.then((_) {
    print("2");
    new Future(() => print("3"));
    f1.then((_) {
      print("4");
    });
  });
}
//运行结果
2
4
1
3
```
```
//demo2
import 'dart:async';

main() {
  print('1');
  scheduleMicrotask(() => print('s1'));

  new Future.delayed(new Duration(seconds: 1), () => print('d1'));
  
  new Future(() => print('f1')).then((_) {
    print('f2');
    scheduleMicrotask(() => print('s3'));
  }).then((_) => print('f3'));

  new Future(() => print('f4'));

  scheduleMicrotask(() => print('s2'));

  print('2');
}
//打印结果：
1
2
s1
s2
f1
f2
f3
s3
f4
d1
```
注意点：
1. 尽量使用事件队列，微任务要尽量简单，否则会引起鼠标无反应等。
2. 为使应用程序保持响应，避免在事件循环中添加计算密集型代码
3. 执行计算密集型代码的时候，另创建Isolate

### 生成器
生成器有两种类型：同步生成器和异步生成器。
#### 同步生成器：sync*
```
Iterable getNum(n) sync* {
  print("Begin");
  int k = 0;
  while (k < n) {
    //moveNext会返回true给调用者。
    //函数会在下次调用moveNext的时候恢复执行。
    yield k++;
  }
  print("End");
}

goIterable() {
  //调用getNun立即返回Iterable
  var it = getNum(3).iterator;
  //调用moveNext方法时getNum才开始执行
  while(it.moveNext()) {
    print(it.current);
  }
  print('over');
}
//打印结果
Begin
0
1
2
End
over
```

#### 异步生成器：async*
```
Stream getNum(n) async* {
  print("Begin");
  int k = 0;
  while (k < n) {
    //不用暂停，数据流通过StreamSubscription进行控制
    yield k++;
  }
  print("End");
}

goStream() {
  //调用getNum立即返回Stream,只有执行了listen，函数才会开始执行
  getNum(3).listen((v) {
    print(v);
  });
  print('over');
}
//打印结果
over
Begin
0
1
2
End
```