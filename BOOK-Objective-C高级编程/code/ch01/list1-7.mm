- (void) dealloc
{
	NSDeallocateObject (self);
}

inline void NSDeallocateObject(id anObject)
{
	struct obj_layout *o = &((struct obj_layout *)anObject)[-1];
	free(o);
}