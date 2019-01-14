struct __Block_byref_val_0 { void *__isa;
	__Block_byref_val_0 *__forwarding;
	int __flags;
	int __size;
	int val;
};

struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0* Desc;
	__Block_byref_val_0 *val;
	__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc,
			__Block_byref_val_0 *_val, int flags=0) : val(_val->__forwarding) { 
		impl.isa = &_NSConcreteStackBlock;
		impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	}
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself)
{
	__Block_byref_val_0 *val = __cself->val;
	(val->__forwarding->val) = 1;
}

static void __main_block_copy_0(
	struct __main_block_impl_0*dst, struct __main_block_impl_0*src)
{
	_Block_object_assign(&dst->val, src->val, BLOCK_FIELD_IS_BYREF);
}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
	_Block_object_dispose(src->val, BLOCK_FIELD_IS_BYREF);
}

static struct __main_block_desc_0 {
	unsigned long reserved;
	unsigned long Block_size;
	void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
	void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = {
	0,
	sizeof(struct __main_block_impl_0),
￼￼	__main_block_copy_0,
	__main_block_dispose_0
};

int main()
{
	__Block_byref_val_0 val = {
		0,
		&val,
		0,
		sizeof(__Block_byref_val_0),
		10
	};
	
	blk = &__main_block_impl_0(
		__main_block_func_0, &__main_block_desc_0_DATA, &val, 0x22000000);
	return 0;
}
