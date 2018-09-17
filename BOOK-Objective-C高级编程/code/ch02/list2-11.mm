CFMutableArrayRef cfObject = NULL;
{
	id obj = [[NSMutableArray alloc] init];
	cfObject = CFBridgingRetain(obj);
	CFShow(cfObject);
	printf("retain count = %d\n", CFGetRetainCount(cfObject));
}
printf("retain count after the scope = %d\n", CFGetRetainCount(cfObject));
CFRelease(cfObject);
