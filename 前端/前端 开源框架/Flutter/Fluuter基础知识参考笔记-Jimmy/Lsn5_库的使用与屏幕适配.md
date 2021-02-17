# Lsn5.库的使用与屏幕适配



[TOC]
## 库

### 使用库
```
import 'package:工程名字/lib下的相对路径'
import 'lib下的相对路径'
```
### 指定库前缀
> 通过as指定前缀

### 导入库的一部分
> 通过show,hide,显示和隐藏部分库内容

```
//lib文件内容
String _name = 'lib1';

void getLib(){
  print('我是lib1');
}

class Person{
  String name = 'zhangsan';
  int _age = 5;

  void run(){

  }

  void look(){

  }
}

//调用lib文件内容
import 'lib1.dart' show getLib, Person;
import 'lib2.dart' as lib2 hide getLib;

void goLib() {
  Person p1 = new Person();
  lib2.Person p2 = new lib2.Person();
}

void main() {
  goLib();
}
```
### 重新导出库--export
1. 可以通过重新导出部分库或者全部库来组合或重新打包库。
2. 也有hide，show，没有as。
```
//将要使用的库放在同一个文件下，方便其他文件调用
//export导入的库的内容，当前文件并不能使用
export 'lib1.dart';
export 'lib2.dart' show name2;
```

### 声明库，关联文件与库--library，part，part of
1. 添加实现文件，把part fileUri放在有库的文件，其中fileUri是实现文件的路径。
2. 然后在实现文件中，添加部分标识符（part of identifier），其中identifier是library定义的名称。
```
//文件1
library jimmy;
part 'lib3.dart';

//lib3.dart文件
part of jimmy;
```
> 注意：
> 1.当前文件成员覆盖import,export导入的库的成员，类似本地变量覆盖全局变量。
> 2.导入的多个库中有命名冲突，如果没使用该冲突命名，则不会报错。

### 依赖版本设置
依赖分：常规依赖和Dev依赖，重写依赖。
Dev依赖：主要用于测试调试时需要依赖的库。
```
english_words:any//可以是版本
//可以是路径
english_words:
    path:相对路径
```
1. any,>=,>,<=,<,或者直接指定版本
2. ^version表示向后兼容到指定版本的范围。例如^1.2.3等同于'>=1.2.3<2.0.0'，而^0.1.2等同于'>=0.1.2<0.2.0'

重写依赖
dependency_overrides:
使用方式和依赖一样，但是会强制下载依赖包，不管是否兼容，不推荐使用。



## 布局控件分两种：
1. 多个子元素的布局---10个
  Row
  Column
  Stack
  IndexedStack
  Flow
  Table
  Wrap
  ListBody
  ListView
  CustomMultiChildLayout
2. 单个子元素的布局---18个
  Container
  padding
  Center
  Align
  FittedBox
  AspectRatio
  ConstrainedBox
  Baseline
  FractionallySizedBox
  IntrinsicHeight
  IntrinsicWidth
  LimitedBox
  Offstage
  OverflowBox
  SizedBox
  SizedOverflowBox
  Transform
  CustomSingleChildLayout

## Row、Column
自身不带滚动属性，如果超出了一行，在debug下面则会显示溢出的提示

### MainAxisAlignment：
主轴方向上的对齐方式，默认是start。MainAxisAlignment枚举值如下：

- start：将children放置在主轴的起点；
- center：将children放置在主轴的中心；
- end：将children放置在主轴的末尾；
- spaceAround：将主轴方向上的空白区域均分，使得children之间的空白区域相等，但是首尾child的空白区域为1/2；
- spaceBetween：将主轴方向上的空白区域均分，使得children之间的空白区域相等，首尾child都靠近首尾，没有间隙；
- spaceEvenly：将主轴方向上的空白区域均分，使得children之间的空白区域相等，包括首尾child；

### MainAxisSize
主轴应占用多少空间---min,max,默认max。

### CrossAxisAlignment：
交叉轴方向的对齐方式,默认center。CrossAxisAlignment枚举值有如下：

- center：children在交叉轴上居中展示；
- start：children在交叉轴上起点处展示；
- end：children在交叉轴上末尾展示；
- stretch：让children填满交叉轴方向；
- baseline：在交叉轴方向，使得children的baseline对齐；


### VerticalDirection：
定义了children摆放顺序，默认是down。VerticalDirection枚举值有两种：

- down：从top到bottom进行布局；
- up：从bottom到top进行布局。
  top对应Row以及Column的话，就是左边和顶部，bottom的话，则是右边和底部。

### TextDirection：
rtl: rigth to left
ltr: left to right

### TextBaseline
alphabetic：用于对齐字母字符底部的水平线。
ideographic：用于对齐表意字符的水平线。
```
import 'package:flutter/material.dart';

void main() {
  runApp(new Row(
    textDirection: TextDirection.ltr,
    children: <Widget>[
      new Text(
        'jimmy1',
        textDirection: TextDirection.ltr,
      ),
      new Text(
        'jimmy2',
        textDirection: TextDirection.ltr,
      ),
      new Text(
        'jimmy3',
        textDirection: TextDirection.ltr,
      ),new Text(
        'jimmy4',
        textDirection: TextDirection.ltr,
      ),
    ],
  ));
}
```