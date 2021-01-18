```
#if defined(__cplusplus)
#define FOUNDATION_EXTERN extern "C"
#else
#define FOUNDATION_EXTERN extern
#endif
```

```
//NS_UNAVAILABLE的作用是直接禁止此方法的使用
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)init NS_UNAVAILABLE;
```

```
///API_AVAILABLE

```