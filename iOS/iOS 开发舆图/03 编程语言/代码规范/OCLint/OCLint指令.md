[http://docs.oclint.org/en/stable/manual/oclint.html](http://docs.oclint.org/en/stable/manual/oclint.html)

`oclint [options] <source> -- [compiler flags]`

[options]为一些参数选项，可以是规则加载选项、报告形式选项等：

1. R <路径> ： 检测所用的规则的路径，默认路径$(/path/to/bin/oclint)/../lib/oclint/rules
2. disable-rule <规则名>： 让相对应的规则失效[OCLint 规则列表](https://link.jianshu.com/?t=http%3A%2F%2Fdocs.oclint.org%2Fen%2Fstable%2Frules%2Findex.html)
3. rc <参数>=<值> ：修改阈值
4. report-type <报告类型>，有"text"、“html”、“json”、“pmd”、“xcode”几个类型
5. o <路径> 报告生成路径。

```objectivec
// 数值都是默认值
-rc=LONG_CLASS=1000 \ #类行数限制  

-rc=LONG_LINE=100 \  #每行的字符限制

-rc=LONG_METHOD=50 \ #方法行数限制

-rc=LONG_VARIABLE_NAME=20 \ #参数名字符限制

-rc=MAXIMUM_IF_LENGTH=15 \ #if的行数限制

-rc=MINIMUM_CASES_IN_SWITCH=3 \ #switch case的最小数目

-rc=NPATH_COMPLEXITY=200 \ #通过该方法的非循环执行路径数量限制

-rc=NSSS_METHOD=30 \ #连续未注释行数限制

-rc=NESTED_BLOCK_DEPTH=5 \ #block嵌套层数限制

-rc=SHORT_VARIABLE_NAME=3 \ #变量名的最小字符数限制

-rc=TOO_MANY_FIELDS=20 \ #类成员限制

-rc=TOO_MANY_METHODS=30 \ #类方法数限制

-rc=TOO_MANY_PARAMETERS=10 \ #参数个数限制

```