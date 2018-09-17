long result = dispatch_semaphore_wait(semaphore, time);

if (result == 0) {

	/*
	 * The counter of the dispatch semaphore was more than one.
	 * Or it became one and more before the specified timeout.
	 * The counter is automatically decreased by one.
	 *
	 * Here, you can execute a task that needs a concurrency control.
	 */

} else {

	/*
	 * Because the counter of the dispatch semaphore was zero,
	 * it has waited until the specified timeout.
	 */

}