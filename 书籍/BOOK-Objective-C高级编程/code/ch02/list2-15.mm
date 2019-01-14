{
	CFMutableArrayRef cfObject = 
		CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
	printf("retain count = %d\n", CFGetRetainCount(cfObject));

	/*
	 * The object is created with ownership by Core Foundation Framework API.
	 * The retain count is one.
	 */

	id obj = CFBridgingRelease(cfObject);

	/*
	 * By assignment after CFBridgingRelease,
	 * variable obj has a strong reference and then 
	 * the object is released by CFRelease.
	 */

	printf("retain count after the cast = %d\n", CFGetRetainCount(cfObject));
	
	/*
	 * Only the variable obj has a strong reference to
	 * the object, so the retain count is one. 
	 *
	 * And, after being cast by CFBridgingRelease,
	 * pointer stored in variable cfObject is still valid. 
	 */

	NSLog(@"class=%@", obj);
}

/*
 * Leaving the scope of variable obj, its strong reference disappears.
 * The object is released automatically.
 * Because no one has ownership, the object is discarded. 
 */
 