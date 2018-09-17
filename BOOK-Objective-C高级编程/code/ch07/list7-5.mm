dispatch_queue_t queue =
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

/*
 * Executing on a global dispatch queue asynchronously
 */

dispatch_async(queue, ^{

	/*
 	 * On the global dispatch queue, dispatch_apply function waits for
 	 *  all the tasks to be finished.
	 */
 
	dispatch_apply([array count], queue, ^(size_t index) {

		/*
		 * do something concurrently with all the objects in the NSArray object
		 */

		NSLog(@"%zu: %@", index, [array objectAtIndex:index]);
	});

	/*
	 * All the tasks by dispatch_apply function are finished. 
	 */

	/*
	 * Execute on the main dispatch queue asynchronously
	 */

	dispatch_async(dispatch_get_main_queue(), ^{
		/*
		 * Executed on the main dispatch queue.
		 * Something like updating userface, etc.
		 */

		NSLog(@"done");
	});
});
