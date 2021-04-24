一切皆Widget( StatelessWidget 和 StatefulWidget ,Widget就是View，应用本身也是一个widget。 )

StatefulWidget 有状态：交互或者数据改变导致Widget改变，例如改变文案
StatelessWidget 无状态：不会被改变的Widget，例如纯展示页面，数据也不会改变； 无状态的组件的声明周期只有一个：build

Widget是不可变的，不可变的！！。变的只是Widge里面的状态，也就是State

### 怎么选

如果不需要自己维持状态就使用StatelessWidget，否则使用StatefulWidget。

通过上面的介绍，大家不难发现StatefulWidget几乎是这样一个存在——我在任何需求下使用它都能实现想要的效果，那么我们为什么不一股脑全部使用它呢？既然它也能实现StatelessWidget的效果，那我们还要StatelessWidget做什么？StatefulWidget就是一个全能的存在啊

参考
https://juejin.cn/post/6844903941025562632   https://app.yinxiang.com/shard/s35/nl/9757212/d9ca55ee-9cda-424a-9253-0a32181d88a1