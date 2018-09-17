{
	id test0 = [[Test alloc] init];
	id test1 = [[Test alloc] init];
	[test0 setObject:test1];
	[test1 setObject:test0];
}
