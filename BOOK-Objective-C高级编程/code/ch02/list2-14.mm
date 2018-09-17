{
	CFMutableArrayRef cfObject =
		CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
	printf("retain count = %d\n", CFGetRetainCount(cfObject));
	id obj = CFBridgingRelease(cfObject);
	printf("retain count after the cast = %d\n", CFGetRetainCount(cfObject));
	NSLog(@"class=%@", obj);
}
