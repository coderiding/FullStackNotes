```objectivec
Total pre-main time: 2.0 seconds (100.0%)
         dylib loading time:  94.69 milliseconds (4.6%)
        rebase/binding time:  62.45 milliseconds (3.0%)
            ObjC setup time:  53.09 milliseconds (2.6%)
           initializer time: 1.8 seconds (89.6%)
           slowest intializers :
             libSystem.B.dylib :   6.49 milliseconds (0.3%)
    libMainThreadChecker.dylib :  43.84 milliseconds (2.1%)
          libglInterpose.dylib : 261.05 milliseconds (12.8%)
                  小帮快送 : 2.9 seconds (143.6%)

阶段2耗时：mian方法到didFinishLaunchingWithOptions方法的耗时--0.632435

阶段3耗时：didFinishLaunchingWithOptions方法内部的耗时--0.349428
```