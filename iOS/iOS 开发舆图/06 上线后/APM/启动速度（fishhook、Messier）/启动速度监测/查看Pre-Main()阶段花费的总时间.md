- 想查看Pre-Main阶段的时间比较简单。
- [mx：我的iOS9越狱手机没有打印下面的信息，但是iOS13]的可以
- 直接打开Xcode，找到Product->Scheme->Edit Scheme->Run->Arguments->Environment Variables->DYLD_PRINT_STATISTICS 设置为 YES

```objectivec
Total pre-main time: 2.8 seconds (100.0%)
         dylib loading time:  99.96 milliseconds (3.4%)
        rebase/binding time:  75.63 milliseconds (2.6%)
            ObjC setup time: 445.31 milliseconds (15.5%)
           initializer time: 2.2 seconds (78.3%)
           slowest intializers :
             libSystem.B.dylib :  10.14 milliseconds (0.3%)
    libMainThreadChecker.dylib :  60.74 milliseconds (2.1%)
          libglInterpose.dylib : 352.89 milliseconds (12.3%)
                  小帮快送 : 3.4 seconds (120.7%)
```