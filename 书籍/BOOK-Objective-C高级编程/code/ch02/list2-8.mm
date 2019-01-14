id __weak obj1 = nil;
{
	/*
￼￼￼	 * You create an object and have ownership.

￼￼	 */

	id __strong obj0 = [[NSObject alloc] init];

	/*
	 * The variable obj0 is qualified with __strong. 
	 * Which means, it has ownership of the object.
	 */
	 
	obj1 = obj0;

	/*
	 * variable obj1 has a weak reference of the object
	 */
	 
	NSLog(@"A: %@", obj0);

	/*
	 * The object, to which the variable obj0 has a strong reference, is displayed 
	 */
} 
/*
 * Leaving the scope of variable obj0, its strong reference disappears.
 * The object is released.
 * It is disposed of because no one has ownership.
 *
 * When it is disposed of,
 * weak reference is destroyed and nil is assigned to the obj1. 
 */

NSLog(@"B: %@", obj1);
/*
 * The value of obj1, nil is displayed
 */
