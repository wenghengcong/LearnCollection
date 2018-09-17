struct obj_layout {
	NSUInteger retained; 
};

+ (id) alloc
{
	int size = sizeof(struct obj_layout) + size_of_the_object;
	struct obj_layout *p = (struct obj_layout *)calloc(1, size);
	return (id)(p + 1);
}