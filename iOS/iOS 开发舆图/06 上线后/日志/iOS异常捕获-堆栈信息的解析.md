iOS异常捕获-堆栈信息的解析

最近使用NSSetUncaughtExceptionHandler和signal方法捕获异常，并传到服务器，用来追踪线上app的异常信息。

但是捕获到的都是堆栈信息：

如何利用这些堆栈信息查看报错方法名和行数？

异常信息
异常信息有三种类型：
1.已标记错误位置的:
```
test 0x000000010bfddd8c -[ViewController viewDidLoad] + 8588
```

这种信息已经很明确了，不用解析

2.有模块地址的情况：
```
test 0x00000001018157dc 0x100064000 + 24844252
```

以上面为例子，从左到右依次是：
二进制库名（test），调用方法的地址（0x00000001018157dc），模块地址（0x100064000）+偏移地址（24844252）

3.无模块地址的情况：
```
test 0x00000001018157dc test + 24844252
```

##dSYM符号表获取
xcode->window->organizer->右键你的应用 show finder->右键.xcarchive 显示包内容->dSYMs->test.app.dYSM

atos命令
atos命令来符号化某个特定模块加载地址
```
atos [-arch 架构名] [-o 符号表] [-l 模块地址] [方法地址]
```

##解析
使用终端，进到test.app.dYSM所在目录

一.如果是有模块地址的情况，运行：
```
atos -arch arm64 -o test.app.dSYM/Contents/Resources/DWARF/test -l 0x100064000 0x00000001018157dc
```

二.如果是无模块地址的情况

1.先将偏移地址转为16进制：
```
24844252 = 0x17B17DC
```

2.然后用方法的地址-偏移地址，得到的就是模块地址
```
0x00000001018157dc - 0x17B17DC = 0x100064000
```

3.最后运行：
```
atos -arch arm64 -o test.app.dSYM/Contents/Resources/DWARF/test -l 0x100064000 0x00000001018157dc
```

