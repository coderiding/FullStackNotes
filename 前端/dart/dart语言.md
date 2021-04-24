Dart语言同时支持AOT和JIT运行方式，JIT模式下还有一个备受欢迎的开发利器“热刷新”（Hot Reload）

https://tech.meituan.com/2018/08/09/waimai-flutter-practice.html

Dart是强类型语言，但是显式变量类型声明是可选的，Dart支持类型推断。如果不想使用类型推断，可以用dynamic类型。
Dart支持泛型，List<int>表示包含int类型的列表，List<dynamic>则表示包含任意类型的列表。
Dart支持顶层（top-level）函数和类成员函数，也支持嵌套函数和本地函数。
Dart支持顶层变量和类成员变量。
Dart没有public、protected和private这些关键字，使用下划线“_”开头的变量或者函数，表示只在库内可见。


Dart似乎是C和Java的混合体