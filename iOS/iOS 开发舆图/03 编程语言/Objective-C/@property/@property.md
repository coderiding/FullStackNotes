@property 使用这个语法，会自定对成员变量生成get和set方法，以前没有这个快捷语法的时候，需要手动实现set和get方法，请问，@dynamic的作用是什么？

完成属性定义后，编译器会自动编写访问这些属性所需的方法，此过程叫做“自动合成”(autosynthesis)。

实例变量的名字=属性名前加下划线

@property有两个对应的词，一个是 @synthesize，一个是 @dynamic。如果 @synthesize和 @dynamic都没写，那么默认的就是@syntheszie var = _var;