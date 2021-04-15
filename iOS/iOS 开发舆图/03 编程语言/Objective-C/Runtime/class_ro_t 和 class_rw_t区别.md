class_ro_t 和 class_rw_t 的区别？


解答：class_ro_t只读，存储方法列表、属性列表、协议列表、iva指针等类的初始化信息，存储的方法、协议、属性是一维数组。

class_rw_t可读可写，存储分类方法，存储class_ro_t所有信息，存储的方法、协议、属性是二维数组，提供给runtime动态插入方法用