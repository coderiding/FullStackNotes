InheritedWidget
https://blog.csdn.net/vitaviva/article/details/105462686

在Flutter进行界面开发时，我们经常会遇到数据传递的问题。由于Flutter采用节点树的方式组织页面，以致于一个普通页面的节点层级会很深。此时，我们如果还是一层层传递数据，当需要修改数据时，就会比较麻烦。

此时，我们需要一种机制，能够让某一个节点下的所有子节点，访问该节点下的数据。

InheritedWidget就满足了我们这一需求。


InheritedWidget使用说明 https://www.jianshu.com/p/76cf7842da68   https://app.yinxiang.com/shard/s35/nl/9757212/4fafd86a-b8d7-4b43-ae07-341d6db7d4d6