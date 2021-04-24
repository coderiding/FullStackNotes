它是DecoratedBox、ConstrainedBox、Transform、Padding、Align等组件组合的一个多功能容器

我们只需通过一个Container组件可以实现同时需要装饰、变换、限制的场景。

color和decoration是互斥的，如果同时设置它们则会报错！实际上，当指定color时，Container内会自动创建一个decoration

https://book.flutterchina.club/chapter5/container.html