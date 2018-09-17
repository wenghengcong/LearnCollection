/* a struct for the Block and some functions */

struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0* Desc;
	id __strong array;
	__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, 
	id __strong _array, int flags=0) : array(_array) {
		impl.isa = &_NSConcreteStackBlock; impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	}
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself, id obj)
{
	id __strong array = __cself->array;
	[array addObject:obj];
	NSLog(@"array count = %ld", [array count]);
}

static void __main_block_copy_0(struct __main_block_impl_0 *dst, __main_block_impl_0 *src)
{
	_Block_object_assign(&dst->array, src->array, BLOCK_FIELD_IS_OBJECT);
}

static void __main_block_dispose_0(struct __main_block_impl_0 *src)
{
	_Block_object_dispose(src->array, BLOCK_FIELD_IS_OBJECT);
}

static struct __main_block_desc_0 {
	unsigned long reserved;
	unsigned long Block_size;
	void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*); 
	void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = {
		0,
		sizeof(struct __main_block_impl_0), 
		__main_block_copy_0, 
		__main_block_dispose_0
};

/* Block literal and executing the Block */

blk_t blk;
{
	id __strong array = [[NSMutableArray alloc] init];
	blk = &__main_block_impl_0(
		__main_block_func_0, &__main_block_desc_0_DATA, array, 0x22000000);
	blk = [blk copy]; 
}
(*blk->impl.FuncPtr)(blk, [[NSObject alloc] init]); 
(*blk->impl.FuncPtr)(blk, [[NSObject alloc] init]); 
(*blk->impl.FuncPtr)(blk, [[NSObject alloc] init]);
