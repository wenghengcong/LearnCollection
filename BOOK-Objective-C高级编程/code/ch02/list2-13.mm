CFMutableArrayRef cfObject = NULL;
{
	id obj = [[NSMutableArray alloc] init];

	/*
	 * variable obj has a strong reference to the object
	 */
	 
	cfObject = (__bridge CFMutableArrayRef)obj;
	CFShow(cfObject);
	printf("retain count = %d\n", CFGetRetainCount(cfObject));

	/*
	 * __bridge cast does not touch ownership status.
	 * Reference count is one because of variable obj's strong reference.
￼￼	 */ 
}

/*
 * Leaving the scope of variable obj, its strong reference disappears. 
 * The object is released automatically.
 * Because no one has ownership, the object is discarded.
 */

/*
 * From here, any access to the object is invalid! (dangling pointer)
 */

printf("retain count after the scope = %d\n", CFGetRetainCount(cfObject));
CFRelease(cfObject);
