- (NSUInteger) retainCount
{
	return NSExtraRefCount(self) + 1;
}

inline NSUInteger NSExtraRefCount(id anObject)
{
	return ((struct obj_layout *)anObject)[-1].retained;
}