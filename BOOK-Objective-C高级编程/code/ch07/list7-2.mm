/*
 * Execute a Block on a global dispatch queue of default priority. 
 */

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	/*
	 * some tasks here to be executed concurrently 
	 */
	
	/*
	 * Then, execute a Block on the main dispatch queue 
	 */

	dispatch_async(dispatch_get_main_queue(), ^{
		/*
		 * Here, some tasks that can work only on the main thread.
		*/
	});
});

