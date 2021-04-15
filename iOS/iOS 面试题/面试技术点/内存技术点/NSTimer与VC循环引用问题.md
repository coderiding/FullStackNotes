### 存在问题
![5LDOwL](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/5LDOwL.png)

* 分析
![Uq0OtR](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/Uq0OtR.png)
描述：NSTimer中的target参数对VC有强引用，VC对NSTimer又是strong强引用，结果就无法释放，VC退出，timer还会工作，VC也无法释放。

### 解决方案一
![cm2nlm](https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/cm2nlm.png)
使用NSTimer那个自带Block的构造方法，把要调用的方法放到里面。