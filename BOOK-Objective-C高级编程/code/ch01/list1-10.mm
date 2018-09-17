+ (void) addObject: (id)anObj
{
	NSAutoreleasePool *pool = getting active NSAutoreleasePool;
	if (pool != nil) {
		[pool addObject:anObj];
	} else {
		NSLog(@"autorelease is called without active NSAutoreleasePool.");
	}
}
