//
//  BFClassInfo.h
//  OCObjectInfo
//
//  Created by WengHengcong on 2018/11/22.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#ifndef BFClassInfo_h
#define BFClassInfo_h

# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
# endif

#if __LP64__
typedef uint32_t mask_t;
#else
typedef uint16_t mask_t;
#endif
typedef uintptr_t cache_key_t;

#if __arm__  ||  __x86_64__  ||  __i386__
// objc_msgSend has few registers available.
// Cache scan increments and wraps at special end-marking bucket.
#define CACHE_END_MARKER 1
static inline mask_t cache_next(mask_t i, mask_t mask) {
    return (i+1) & mask;
}

#elif __arm64__
// objc_msgSend has lots of registers available.
// Cache scan decrements. No end marker needed.
#define CACHE_END_MARKER 0
static inline mask_t cache_next(mask_t i, mask_t mask) {
    return i ? i-1 : mask;
}

#else
#error unknown architecture
#endif

struct bucket_t {
    cache_key_t _key;
    IMP _imp;
    inline cache_key_t key() const { return _key; }
    inline IMP imp() const { return (IMP)_imp; }
    inline void setKey(cache_key_t newKey) { _key = newKey; }
    inline void setImp(IMP newImp) { _imp = newImp; }
    void set(cache_key_t newKey, IMP newImp);
};

struct cache_t {
    bucket_t *_buckets;
    mask_t _mask;
    mask_t _occupied;
    
    IMP imp(SEL selector)
    {
        mask_t begin = _mask & (long long)selector;
        mask_t i = begin;
        do {
            if (_buckets[i]._key == 0  ||  _buckets[i]._key == (long long)selector) {
                return _buckets[i]._imp;
            }
        } while ((i = cache_next(i, _mask)) != begin);
        return NULL;
    }
};

struct entsize_list_tt {
    uint32_t entsizeAndFlags;
    uint32_t count;
};

struct method_t {
    SEL name;
    const char *types;
    IMP imp;
};

struct method_list_t : entsize_list_tt {
    method_t first;
};

struct ivar_t {
    int32_t *offset;
    const char *name;
    const char *type;
    uint32_t alignment_raw;
    uint32_t size;
};

struct ivar_list_t : entsize_list_tt {
    ivar_t first;
};

struct property_t {
    const char *name;
    const char *attributes;
};

struct property_list_t : entsize_list_tt {
    property_t first;
};

struct chained_property_list {
    chained_property_list *next;
    uint32_t count;
    property_t list[0];
};

typedef uintptr_t protocol_ref_t;
struct protocol_list_t {
    uintptr_t count;
    protocol_ref_t list[0];
};

struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;  // instance对象占用的内存空间
#ifdef __LP64__
    uint32_t reserved;
#endif
    const uint8_t * ivarLayout;
    const char * name;  // 类名
    method_list_t * baseMethodList;
    protocol_list_t * baseProtocols;
    const ivar_list_t * ivars;  // 成员变量列表
    const uint8_t * weakIvarLayout;
    property_list_t *baseProperties;
};

struct class_rw_t {
    uint32_t flags;
    uint32_t version;
    const class_ro_t *ro;
    method_list_t * methods;    // 方法列表
    property_list_t *properties;    // 属性列表
    const protocol_list_t * protocols;  // 协议列表
    Class firstSubclass;
    Class nextSiblingClass;
    char *demangledName;
};

#define FAST_DATA_MASK          0x00007ffffffffff8UL
struct class_data_bits_t {
    uintptr_t bits;
public:
    class_rw_t* data() {
        return (class_rw_t *)(bits & FAST_DATA_MASK);
    }
};

/* OC对象 */
struct bf_objc_object {
    void *isa;
};

/* 类对象 */
struct bf_objc_class : bf_objc_object {
    Class superclass;
    cache_t cache;
    class_data_bits_t bits;
public:
    class_rw_t* data() {
        return bits.data();
    }
    
    bf_objc_class* metaClass() {
        return (bf_objc_class *)((long long)isa & ISA_MASK);
    }
};


//
size_t bytesForCapacity(uint32_t cap)
{
    // fixme put end marker inline when capacity+1 malloc is inefficient
    return sizeof(bucket_t) * (cap + 1);
}

bucket_t *endMarker(struct bucket_t *b, uint32_t cap)
{
    // bytesForCapacity() chooses whether the end marker is inline or not
    return (bucket_t *)((uintptr_t)b + bytesForCapacity(cap)) - 1;
}

template <typename T>
static inline T log2u(T x) {
    return (x<2) ? 0 : log2u(x>>1)+1;
}

static inline mask_t bf_cache_hash(cache_key_t key, mask_t mask)
{
    return (mask_t)(key & mask);
}


struct bucket_t *bf_buckets(cache_t cache)
{
    return cache._buckets;
}

mask_t bf_mask(cache_t cache)
{
    return cache._mask;
}

void bf_incrementOccupied(cache_t cache)
{
    cache._occupied++;
}

cache_key_t bf_getKey(SEL sel)
{
    assert(sel);
    return (cache_key_t)sel;
}


bucket_t * bf_findBucket(cache_t cache, cache_key_t k)
{
    assert(k != 0);

    bucket_t *b = bf_buckets(cache);    //缓存
    mask_t m = bf_mask(cache);          //缓存空间-1
    mask_t begin = bf_cache_hash(k, m);    //计算key对应的hash值，hash的计算方法：key & mask
    mask_t i = begin;

    //假如hash值begin未命中缓存，继续下一次尝试
    //尝试cache_next(i, m)，下一次hash计算方法为：(i+1) & mask
    do {
        if (b[i].key() == 0  ||  b[i].key() == k) {
            return &b[i];
        }
    } while ((i = cache_next(i, m)) != begin);

    // hack
    return nil;
}

bucket_t * bf_findBucket2(bucket_t* buc, mask_t size, cache_key_t k)
{
    assert(k != 0);
    
    bucket_t *b = buc;    //缓存
    mask_t m = size;          //缓存空间-1
    mask_t begin = bf_cache_hash(k, m);    //计算key对应的hash值，hash的计算方法：key & mask
    mask_t i = begin;
    
    //假如hash值begin未命中缓存，继续下一次尝试
    //尝试cache_next(i, m)，下一次hash计算方法为：(i+1) & mask
    do {
        if (b[i].key() == 0  ||  b[i].key() == k) {
            return &b[i];
        }
    } while ((i = cache_next(i, m)) != begin);
    
    // hack
    return nil;
}


#endif /* BFClassInfo_h */
