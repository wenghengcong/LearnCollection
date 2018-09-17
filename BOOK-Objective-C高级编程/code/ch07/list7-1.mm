/*
 * How to get the main dispatch queue
 */
 
dispatch_queue_t mainDispatchQueue = dispatch_get_main_queue();

/*
 * How to get a global dispatch queue of high priority 
 */

dispatch_queue_t globalDispatchQueueHigh = 
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

/*
 * How to get a global dispatch queue of default priority
 */

dispatch_queue_t globalDispatchQueueDefault = 
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

	
/*
 * How to get a global dispatch queue of low priority 
 */

dispatch_queue_t globalDispatchQueueLow = 
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

/*
 * How to get a global dispatch queue of background priority */
dispatch_queue_t globalDispatchQueueBackground = 
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);