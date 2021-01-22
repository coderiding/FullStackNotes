静态分析工具

```objectivec
点击这里下载Clang 静态分析器http://clang-analyzer.llvm.org/release_notes.html，然后解压就可以了，不需要放到特定目录下。而卸载它的话，删除这个解压后的目录即可。

在 Clang 静态分析器中，常用的就是 scan-build 和 scan-view 这两个工具。

scan-build 是用来运行分析器的命令行工具；scan-view 包含了 scan-build 工具，会在 scan-build 执行完后将结果可视化。

scan-build 的原理是，将编译器构建改成另一个“假的”编译器来构建，这个“假的”编译器会执行 Clang 来编译，然后执行静态分析器分析你的代码。

scan-build 的使用方法，也很简单，你只需要到项目目录下，使用如下命令即可：

\yourpath\scan-build -k -V make

关于 scan-build 的更多参数和使用说明，你可以点击这个链接查看。http://clang-analyzer.llvm.org/scan-build

Clang 静态分析器是由分析引擎 (analyzer core) 和 checkers 组成的。所有的 checker 都是基于底层分析引擎之上的。通过分析引擎提供的功能，我们可以编写新的 checker。

checker 架构能够方便用户扩展代码检查的规则，或者通过自定义来扩展 bug 类型。如果你想编写自己的 checker，可以在 Clang 项目的 lib/StaticAnalyzer/Checkers 目录下找到示例参考，比如 ObjCUnusedIVarsChecker.cpp 就是用来检查是否有定义了，但是从未使用过的变量。

当然，如果为了编写自定义的 checker 一开始就埋头进去看那些示例代码是很难看懂的，你甚至都不能知道编写 checker 时有哪些方法可以为我所用。所以，你需要先了解 Clang 静态分析器提供了哪些功能接口，然后再参考官方的大量实例，去了解怎么使用这些功能接口，在这之后再动手开发才会事半功倍。

----------------

了解Clang分析器的功能接口：

checker 的官方示例代码里有一个非常实用的，也就是内存泄露检查示例 MallocChecker，你可以点击这个链接查看代码。http://clang.llvm.org/doxygen/MallocChecker_8cpp_source.html

在这段代码开头，我们可以看到引入了 clang/AST/ 和 clang/StaticAnalyzer/Core/PathSensitive/ 目录下的头文件。这两个目录下定义的接口功能非常强大，大部分 checker 都是基于此开发的。

clang/AST/ 目录中，有语法树遍历 RecursiveASTVisitor，还有语法树层级遍历 StmtVisitor，遍历过程中，会有很多回调函数可以让 Checker 进行检查。比如，方法调用前的回调 checkPreCall、方法调用后的回调 checkPostCall，CFG（Control Flow Graph 控制流程图） 分支调用时的回调 checkBranchCondition、CFG 路径分析结束时的回调 checkEndAnalysis 等等。有了这些回调，我们就可以从语法树层级和路径上去做静态检查的工作了。

clang/StaticAnalyzer/Core/PathSensitive/ 目录里，可以让 checker 检查变量和值上的更多变化。从目录 PathSensitive，我们也能看出这些功能叫做路径敏感分析（Path-Sensitive Analyses），是从条件分支上去跟踪，而这种跟踪是跟踪每一种分支去做分析。

但是，要去追踪所有路径的话，就可能会碰到很多复杂情况，特别是执行循环后，问题会更复杂，需要通过路径合并来简化复杂的情况，但是简化后可能就不会分析出所有的路径。所以，考虑到合理性问题的话，我们还是需要做些取舍，让其更加合理，达到尽量输出更多信息的目的，来方便我们开发 checker，检查出更多的 bug 。

路径敏感分析也包含了模拟内存管理，SymbolManager 符号管理里维护着变量的生命周期分析。想要了解具体实现的话，你可以点击这个链接参看源码实现。http://clang.llvm.org/doxygen/SymbolManager_8h_source.html

这个内存泄露检查示例 MallocChecker 里，运用了 Clang 静态分析器提供的语法树层级节点检查、变量值路径追踪以及内存管理分析功能接口，对我们编写自定义的 checker 是一个很全面、典型的示例。

追其根本，编写自己的 checker ，其核心还是要更多地掌握 Clang 静态分析器的内在原理。很早之前，苹果公司就在 LLVM Developers Meeting 上https://www.youtube.com/watch?v=4lUJTY373og&t=102s，和我们分享过怎样通过 Clang 静态分析器去找 bug。你可以点击这个链接，查看相应的 PPThttp://llvm.org/devmtg/2008-08/Kremenek_StaticAnalyzer.pdf，这对我们了解 Clang 静态分析器的原理有很大的帮助。

不过，checker 架构也有不完美的地方，比如每执行完一条语句，分析引擎需要回去遍历所有 checker 中的回调函数。这样的话，随着 checker 数量的增加，整体检查的速度也会变得越来越慢。

如果你想列出当前 Clang 版本下的所有 checker，可以使用如下命令：

clang —analyze -Xclang -analyzer-checker-help

下面显示的就是常用的 checker：
debug.ConfigDumper              配置表
debug.DumpCFG                   显示控制流程图
debug.DumpCallGraph             显示调用图
debug.DumpCalls                 打印引擎遍历的调用
debug.DumpDominators            打印控制流程图的 dominance tree
debug.DumpLiveVars              打印实时变量分析结果
debug.DumpTraversal             打印引擎遍历的分支条件
debug.ExprInspection            检查分析器对表达式的理解
debug.Stats                     使用分析器统计信息发出警告
debug.TaintTest                 标记污染的符号
debug.ViewCFG                   查看控制流程图
debug.ViewCallGraph             使用 GraphViz 查看调用图
debug.ViewExplodedGraph         使用 GraphViz 查看分解图

接下来，我和你举个例子来说明如何使用 checker 。我们先写一段代码：

int main()
{
	int a;
	int b = 10;
	a = b;
	return a;
}

接下来，我们使用下面这条命令，调用 DumpCFG 这个 checker 对上面代码进行分析：

clang -cc1 -analyze -analyzer-checker=debug.DumpCFG

显示结果如下：

int main()
 [B2 (ENTRY)]
   Succs (1): B1
 
 [B1]
   1: int a;
   2: 10
   3: int b = 10;
   4: b
   5: [B1.4] (ImplicitCastExpr, LValueToRValue, int)
   6: a
   7: [B1.6] = [B1.5]
   8: a
   9: [B1.8] (ImplicitCastExpr, LValueToRValue, int)
  10: return [B1.9];
   Preds (1): B2
   Succs (1): B0
 
 [B0 (EXIT)]
   Preds (1): B
可以看出，代码的控制流程图被打印了出来。控制流程图会把程序拆得更细，可以把执行过程表现得更直观，有助于我们做静态分析。
```

[clang的重写命令](https://www.notion.so/clang-13dfde64f26a435fb019eb7707e43ef1)