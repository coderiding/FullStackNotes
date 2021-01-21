```objectivec
//总耗时=main函数之前+main函数之后+didFinishLaunchingWithOptions

* 这是用打log的方式记录时间.
* 首先在 main.m 添加如下代码

CFAbsoluteTime StartTime;

int main(int argc, char * argv[]) {
    StartTime = CFAbsoluteTimeGetCurrent();
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

* 然后在 AppDelegate.m 的开头声明
* 这里统计的是main函数之前后到didFinishLaunchingWithOptions开始.

extern CFAbsoluteTime StartTime;
CFAbsoluteTime OptionsStartTime;
CFAbsoluteTime OptionsEndTime;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    OptionsStartTime = CFAbsoluteTimeGetCurrent();
    MXLog(@"\n\nTotal pre-main--mainBefore--%f\n\n",(OptionsStartTime - StartTime));
    
    [self setupLaunchConfigure];
    [self setupBDSSpeechSynthesizer];
    [self mx_uploadProviderLocation];

    OptionsEndTime = CFAbsoluteTimeGetCurrent();
    MXLog(@"\n\nTotal pre-main--didOptionsTotal--%f\n\n",(OptionsEndTime - OptionsStartTime));

    return YES;
}
```