id __weak obj1 = nil;
{
id __strong obj0 = [[NSObject alloc] init];
	obj1 = obj0;
	NSLog(@"A: %@", obj1);
}
NSLog(@"B: %@", obj1);