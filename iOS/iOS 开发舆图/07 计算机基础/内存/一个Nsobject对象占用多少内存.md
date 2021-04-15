解答：

- 系统分配了 16 个字节给 Nsobject 对象（通过 malloc_size 函数获得）
- 但 Nsobject）对象内部只使用了 8 个字节的空间（64bt 环境下，可以通过 class_ getinstancesize 函数获得