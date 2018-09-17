id __unsafe_unretained obj1 = nil;
{
	/*
	 * You create an object and have ownership. 
	 */
	 
	id __strong obj0 = [[NSObject alloc] init];

	/*
	 * The variable obj0 is qualified with __strong.
	 * Which means, it has ownership of the object.
	 */

	obj1 = obj0;

	/*
	 * variable obj1 is assigned from variable obj0,
	 * obj1 does not have either strong or weak reference
	 */

	NSLog(@"A: %@", obj1);

	/*
	 * Display the value of obj1
	 */
}

/*
 * Leaving the scope of variable obj0, its strong reference disappears.
 * The object is released automatically.
 * Because no one has ownership, the object is discarded.
 */

NSLog(@"B: %@", obj1);

/*
 * Display the value of obj1
 *
 * The object referenced from obj1 is already discarded.
 * It is called dangling pointer. 
 * Invalid access!!
 */