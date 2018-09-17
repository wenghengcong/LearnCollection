struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0* Desc;
	const char *fmt;
	int val;
	
	__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc,
			const char *_fmt, int _val, int flags=0) : fmt(_fmt), val(_val) {
		impl.isa = &_NSConcreteStackBlock; impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	} 
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself)
{
	const char *fmt = __cself->fmt;
	int val = __cself->val;
	printf(fmt, val);
}

static struct __main_block_desc_0 {
	unsigned long reserved;
	unsigned long Block_size;
} __main_block_desc_0_DATA = { 
	0,
	sizeof(struct __main_block_impl_0)
};

int main() {
	int dmy = 256;
	int val = 10;
	const char *fmt = "val = %d\n";
	void (*blk)(void) = &__main_block_impl_0(
		__main_block_func_0, &__main_block_desc_0_DATA, fmt, val);
￼￼	return 0;
}
