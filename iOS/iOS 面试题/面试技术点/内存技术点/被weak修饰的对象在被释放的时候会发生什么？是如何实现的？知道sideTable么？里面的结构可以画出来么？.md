### 被weak修饰的对象在被释放的时候会发生什么？是如何实现的？知道sideTable么？里面的结构可以画出来么？（来源《出一套iOS高级题》J_Knight_）

* SideTable主要存放了OC对象的引用计数和弱引用相关信息

```OBJECTIVE-C
struct SideTable {
    spinlock_t slock;           // 自旋锁，防止多线程访问冲突
    RefcountMap refcnts;        // 对象引用计数map
    weak_table_t weak_table;    // 对象弱引用map

    SideTable() {
        memset(&weak_table, 0, sizeof(weak_table));
    }

    ~SideTable() {
        _objc_fatal("Do not delete SideTable.");
    }

    // 锁操作 符合StripedMap对T的定义
    void lock() { slock.lock(); }
    void unlock() { slock.unlock(); }
    void forceReset() { slock.forceReset(); }

    // Address-ordered lock discipline for a pair of side tables.

    template<HaveOld, HaveNew>
    static void lockTwo(SideTable *lock1, SideTable *lock2);
    template<HaveOld, HaveNew>
    static void unlockTwo(SideTable *lock1, SideTable *lock2);
};
```