```objectivec
struct bucket_t {
private:
    cache_key_t _key;// SEL作为key
    IMP _imp;

public:
    inline cache_key_t key() const { return _key; }
    inline IMP imp() const { return (IMP)_imp; }
    inline void setKey(cache_key_t newKey) { _key = newKey; }
    inline void setImp(IMP newImp) { _imp = newImp; }

    void set(cache_key_t newKey, IMP newImp);
};
```

[参数：cache_key_t](https://www.notion.so/cache_key_t-f5f4523174bd4ff6b6bae4b7b725f356)