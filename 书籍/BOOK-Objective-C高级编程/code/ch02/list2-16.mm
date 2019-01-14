{
	CFMutableArrayRef cfObject = 
	CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
	printf("retain count = %d\n", CFGetRetainCount(cfObject));

	/*
	 * The object is created with ownership by Core Foundation Framework API. 
	 * The retain count is one.
	 */
	 
	id obj = (__bridge id)cfObject;

	/*
	 * variable obj has a strong reference because it is qualified with __strong. 
	 */
	 
	printf("retain count after the cast = %d\n", CFGetRetainCount(cfObject));

	/*
	 * Because variable obj has a strong reference and
 	 * CFRelease is not called,
	 * retain count is two.
	 */
	 
	NSLog(@"class=%@", obj);
}

/*
 * Leaving the scope of variable obj, its strong reference disappears. 
 * The object is released.
 */

/*
 * Because the reference count is one, it is not discarded. Memory leak!
 */