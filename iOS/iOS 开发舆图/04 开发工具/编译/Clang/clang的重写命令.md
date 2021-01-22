重写成c++

```objectivec
clang -rewrite-objc sark.m -o sark.cpp
//cpp就是c plus plus ，表示c++代码

// 制定平台编译
xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc sark.m -o sark.cpp
```