CFMutableArrayRef cfObject = NULL;
{
	id obj = [[NSMutableArray alloc] init];

	/*
	 * variable obj has a strong reference to the object 
	 */
	cfObject = CFBridgingRetain(obj);

	/*
	 * CFBridgingRetain works as if CFRetain is called and 
	 * the object is assigned to variable cfObject
	 */

	CFShow(cfObject);
	printf("retain count = %d\n", CFGetRetainCount(cfObject));

	/*
	 * Reference count is two. One is for strong reference of variable obj, 
	 * The other is by CFBridgingRetain.
	 */
}

/*
 * Leaving the scope of variable obj, its strong reference disappears.
 * Reference count is one. 
 */
 
printf("retain count after the scope = %d\n", CFGetRetainCount(cfObject));
CFRelease(cfObject);

/*
 * Reference count is zero because of CFRelease. 
 * So, the object is discarded.
 */
