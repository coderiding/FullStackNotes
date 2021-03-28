判断是否xx开始
使用startswith
示例代码：

String = "12345 上山打老虎"
if str(String).startswith('1'): #判断String是否以“虎”结尾
    print("有老虎")
else:
    print("没老虎")

执行结果：
	有老虎



————————————————



判断是否xx结尾
使用endswith
示例代码1：

String = "12345 上山打老虎"
if str(String).endswith('虎'): #判断String是否以“虎”结尾
    print("有老虎")
else:
    print("没老虎")

执行结果：
	有老虎
 