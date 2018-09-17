dispatch_queue_t queue =
	dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

NSMutableArray *array = [[NSMutableArray alloc] init];

for (int i = 0; i < 100000; ++i) {
	dispatch_async(queue, ^{
		[array addObject:[NSNumber numberWithInt:i]];
	});
}
