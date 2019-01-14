struct __block_impl {
	void *isa;
	int Flags;
	int Reserved;
	void *FuncPtr;
};

struct __main_block_impl_0 {
	struct __block_impl impl;
	struct __main_block_desc_0* Desc;

	__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
		impl.isa = &_NSConcreteStackBlock;
		impl.Flags = flags;
		impl.FuncPtr = fp;
		Desc = desc;
	}
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself)
{
	printf("Block\n");
}

static struct __main_block_desc_0
{
	unsigned long reserved;
	unsigned long Block_size;
} __main_block_desc_0_DATA = {
	0,
	sizeof(struct __main_block_impl_0)
};

int main() {
	void (*blk)(void) =
		(void (*)(void))&__main_block_impl_0(
			(void *)__main_block_func_0, &__main_block_desc_0_DATA);
	
	((void (*)(struct __block_impl *))(
		(struct __block_impl *)blk)->FuncPtr)((struct __block_impl *)blk);

	return 0;
}
