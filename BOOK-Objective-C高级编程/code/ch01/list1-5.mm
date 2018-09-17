- (id) retain
{
	NSIncrementExtraRefCount(self);
    return self;
}

inline void NSIncrementExtraRefCount(id anObject)
{
	if (((struct obj_layout *)anObject)[-1].retained == UINT_MAX - 1)
		[NSException raise: NSInternalInconsistencyException
			format: @"NSIncrementExtraRefCount() asked to increment too far"];
	((struct obj_layout *)anObject)[-1].retained++;
}