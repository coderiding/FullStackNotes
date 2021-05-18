https://blog.csdn.net/u013297881/article/details/115029257


Flutter异常Another exception was thrown: Instance of ‘DiagnosticsProperty＜void＞
绝大可能是这样的原因

Flutter Incorrect use of ParentDataWidget
提示报错，并且在release版本下无法显示界面，找到原因是使用了**Expanded**控件，

经过排查后发现是Expanded、Flexible等组件，在“Container、Padding、Stack”组件中导致的。

切记：Expanded、Flexible只在Row、Column等组件内，不在其他组件内使用。
————————————————
版权声明：本文为CSDN博主「Android-Sky」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/u013297881/article/details/115029257