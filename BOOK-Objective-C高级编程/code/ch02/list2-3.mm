{
	id __strong test = [[Test alloc] init];
	
	/*
	 * test has a strong reference to a Test Object 
	 */
	 
	[test setObject:[[NSObject alloc] init]];

	/*
	 * The member obj_ of the object
	 * has a strong reference to a NSObject instance. 
	 */
} 

/*
 * Leaving the scope of variable test, its strong reference disappears.
 * The Test object is released.
 * It is disposed of because no one has ownership. *
 * When it is disposed of,
 * The strong reference by its member obj_ disappears as well.
 * The object of NSObject is released.
 * It is disposed of because no one has ownership as well.
 */

