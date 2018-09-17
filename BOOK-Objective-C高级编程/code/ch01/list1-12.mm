- (void) drain
{
	[self dealloc];
}

- (void) dealloc
{
	[self emptyPool];
	[array release];
}

- (void) emptyPool
{
	for (id obj in array) {
		[obj release];
	}
}