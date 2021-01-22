```objectivec
git clone --recurse-submodules -j8 git://github.com/foo/bar.git
//这-j8是一项可选的性能优化，已在2.8版中提供，并可以一次并行获取多达8个子模块-请参见man git-clone
```

```objectivec
//从1.9版的Git升级到2.12版（-j仅在2.8+版中可用）：
git clone --recursive -j8 git://github.com/foo/bar.git
```

```objectivec
//在Git 1.6.5和更高版本中，您可以使用：
git clone --recursive git://github.com/foo/bar.git
```