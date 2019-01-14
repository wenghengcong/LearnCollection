__block size_t total = 0;
size_t size = how many bytes you want to get;
char *buff = (char *)malloc(size);

/*
 * Set as an asynchronous (NONBLOCK) descripter for ‘sockfd’, a file descripter
 */

fcntl(sockfd, F_SETFL, O_NONBLOCK);

/*
 * Obtain a global dispatch queue to add an event handler. 
 */

dispatch_queue_t queue = 
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

/*
 * Create a dispatch source with READ event. 
 */

dispatch_source_t source = 
	dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, sockfd, 0, queue);

/*
 * Assign a task with the READ event. 
 */

dispatch_source_set_event_handler(source, ^{
	/*
	 * Get the available data size. 
	 */

	size_t available = dispatch_source_get_data(source);

	/*
	 * Read data from the descriptor 
	 */

	int length = read(sockfd, buff, available);

	/*
	 * When an error occurs, cancel the dispatch source. 
	 */

	if (length < 0) {
		/*
		 * error handling 
		 */

		dispatch_source_cancel(source); 
	}

	total += length;

	if (total == size) {
		/*
		 * Process the buff 
		 */

		/*
		 * Cancel the dispatch source to finalize it 
		 */

	￼￼	dispatch_source_cancel(source);
	}
});

/*
 * Assign a task for the cancellation of the dispatch source 
 */

dispatch_source_set_cancel_handler(source, ^{ 
	free(buff);
	close(sockfd);

	/*
	 * Release the dispatch source itself 
	 */
	dispatch_release(timer); 
});

/*
 * Resume the dispatch source 
 */

dispatch_resume(source);