[object class]的实现相当于调用方法：objc_getClass(const char * _Nonnull name)

---

object_getClass

* 传参是id类型，返回这个id的isa指针所指向的Class，
* 传参是Class，返回该Class的metaClass。