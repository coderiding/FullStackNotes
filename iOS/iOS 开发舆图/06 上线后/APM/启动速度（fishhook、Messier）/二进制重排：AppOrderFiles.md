# 二进制重排：AppOrderFiles

https://github.com/yulingtianxia/AppOrderFiles


问题：Undefined symbol: ___sanitizer_cov_trace_pc_guard_init
解决：https://github.com/yulingtianxia/AppOrderFiles/issues/1

哪个库编译不过，就移除哪个库 other c flags 中的 -fsanitize-coverage=func,trace-pc-guard

@codeRiding
 
codeRiding commented 28 days ago
如果有swift代码，可能还需要在Other Swift Flags，把里面的东西删掉



Swift的
-sanitize-coverage=func
-sanitize=undefined