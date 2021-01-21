### 步骤1：

- 下载[LLDB Github](https://github.com/DerekSelander/LLDB)

### 步骤2：

- 将下载文件解压，并将lldb_commands目录copy到/usr/local/Cellar中

### 步骤3：配置

- 复制lldb_commands中的dslldb.py的完整路径 （ctl+opt+c）
- 创建.lldbinit文件：vim ~/.lldbinit（找到.lldbinit文件，然后进行编辑，在末尾添加）

```swift
command script import /usr/local/Cellar/lldb_commands/dslldb.py
```

### 步骤4：执行导入

```swift
command source .lldbinit
```