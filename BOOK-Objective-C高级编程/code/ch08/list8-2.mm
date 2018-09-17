/*
 * Create a dispatch source with DISPATCH_SOURCE_TYPE_TIMER
 *
 * When a specified time is elapsed, a task will be added to the main dispatch queue 
 */

dispatch_source_t timer = dispatch_source_create(
	DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());

/*
 * Set the timer to 15 seconds later, * Without repeating,
 * Allow one-second delay
 */

dispatch_source_set_timer(timer, 
	dispatch_time(DISPATCH_TIME_NOW, 15ull * NSEC_PER_SEC),
		DISPATCH_TIME_FOREVER, 1ull * NSEC_PER_SEC);

/*
 * Set a task to be executed when the specified time is passed. 
 */
 
dispatch_source_set_event_handler(timer, ^{
	NSLog(@"wakeup!");
	/*
	 * Cancel the dispatch source 
	 */
	dispatch_source_cancel(timer); 
});

/*
 * Assign a task for the cancellation of the dispatch source 
 */

dispatch_source_set_cancel_handler(timer, ^{ 
	NSLog(@"canceled");

	/*
	 * Release the dispatch source itself 
	 */

	dispatch_release(timer);
});

/*
 * Resume the dispatch source 
 */
dispatch_resume(timer);
