在Flutter中，大多数东西都是widget（后同“组件”或“部件”），包括对齐(alignment)、填充(padding)和布局(layout)等，它们都是以widget的形式提供。

一切皆Widget( StatelessWidget 和 StatefulWidget ,Widget就是View，应用本身也是一个widget。 )

MaterialApp也是一个widget

home 为Flutter应用的首页，它也是一个widget。

Widget其实并不是表示最终绘制在设备屏幕上的显示元素，而它只是描述显示元素的一个配置数据。

Flutter中真正代表屏幕上显示元素的类是Element，也就是说Widget只是描述Element的配置数据

一个Widget对象可以对应多个Element对象。这很好理解，根据同一份配置（Widget），可以创建多个实例（Element）。