dispatch_queue_t queue =
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

/*
 * Create a dispatch semaphore *
 * Set the initial value 1 for the counter of the dispatch semaphore
 * to assure that only one thread will access the object of 
 * NSMutableArray class at the same time.
 */
 
dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
NSMutableArray *array = [[NSMutableArray alloc] init];

for (int i = 0; i < 100000; ++i) {
	dispatch_async(queue, ^{
		/*
		 * Wait for the dispatch semaphore *
		 * Wait forever until the counter of the dispatch semaphore is one and more.
		 */

		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

		/*
		 * Because the counter of the dispatch semaphore is one and more,
		 * the counter is decreased by one and the program flow has returned from
		 * the dispatch_semaphore_wait function. 
		 *
		 * The counter of the dispatch semaphore is always zero here.
		 *
		 * Because only one thread can access the object of the NSMutableArray class
		 * at the same time, you can update the object safely. 
		 */
		 
		 [array addObject:[NSNumber numberWithInt:i]];

		/*
		 * Because a task that needs concurrenct control is done,
		 * you have to call the dispatch_semaphore_signal function
		 * to increase the counter of the dispatch semaphore. *
		 * If some threads are waiting for the counter of the dispatch_semaphore
		 * incremented on dispatch_semaphore_wait, the first thread will be started.
		 */
		 
		dispatch_semaphore_signal(semaphore);
	});
}

/*
 * Originally, because the dispatch semaphore isn’t needed any more,
 * you have to release the dispatch semaphore.
 *
 * dispatch_release(semaphore);
 */
