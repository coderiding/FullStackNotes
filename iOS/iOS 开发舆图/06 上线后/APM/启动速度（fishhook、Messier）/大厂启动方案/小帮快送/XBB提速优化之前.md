```objectivec
Total pre-main time: 2.1 seconds (100.0%)
         dylib loading time:  67.11 milliseconds (3.1%)
        rebase/binding time:  63.41 milliseconds (3.0%)
            ObjC setup time:  53.62 milliseconds (2.5%)
           initializer time: 1.9 seconds (91.2%)
           slowest intializers :
             libSystem.B.dylib :   6.41 milliseconds (0.3%)
    libMainThreadChecker.dylib :  42.75 milliseconds (2.0%)
          libglInterpose.dylib : 196.18 milliseconds (9.3%)
                           xbb : 3.2 seconds (152.8%)
            
阶段2耗时：mian方法到didFinishLaunchingWithOptions方法的耗时--0.512035

阶段3耗时：didFinishLaunchingWithOptions方法内部的耗时--0.341064
```