- (void) release
{
	if (NSDecrementExtraRefCountWasZero(self))
		[self dealloc];
}

BOOL
NSDecrementExtraRefCountWasZero(id anObject)
{
	if (((struct obj_layout *)anObject)[-1].retained == 0) {
    	return YES;
    } else {
    	((struct obj_layout *)anObject)[-1].retained--;
		return NO;
	}
}