依赖存储在Git仓库中的包。如果软件包位于仓库的根目录中，请使用以下语法

```yaml
dependencies:
  pkg1:
    git:
      url: git://github.com/xxx/pkg1.git
```

如果仓库不是在根目录，通过path指定位置
可以使用path参数指定相对位置
```YAML
dependencies:
  package1:
    git:
      url: git://github.com/flutter/packages.git
      path: packages/package1     
```

参考
https://www.dartlang.org/tools/pub/dependencies