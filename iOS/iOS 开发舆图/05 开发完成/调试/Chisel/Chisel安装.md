### 步骤1：

```swift
brew install chisel
```

### 步骤2：

- 已安装到/usr/local/Cellar里面
- 复制chisel文件下的fdlldb.py的完整路径
- 创建.lldbinit文件：vim ~/.lldbinit（找到.lldbinit文件，然后进行编辑，在末尾添加）

```swift
command script import /usr/local/Cellar/chisel/2.0.1/libexec/fblldb.py
```

### 步骤3：使用

- 下面这个命令是在调试的时候才使用，就是要在lldb环境下使用

```swift
command source .lldbinit
```