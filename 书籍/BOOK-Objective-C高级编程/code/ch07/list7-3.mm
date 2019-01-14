dispatch_time_t getDispatchTimeByDate(NSDate *date)
{
	NSTimeInterval interval;
	double second, subsecond;
	struct timespec time;
	dispatch_time_t milestone;

	interval = [date timeIntervalSince1970];
	subsecond = modf(interval, &second);
	time.tv_sec = second;
	time.tv_nsec = subsecond * NSEC_PER_SEC;
	milestone = dispatch_walltime(&time, 0);
	return milestone;
}