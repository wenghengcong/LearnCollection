blk_t blk; {
	id array = [[NSMutableArray alloc] init]; blk = [^(id obj) {
	[array addObject:obj];
NSLog(@"array count = %ld", [array count]); } copy];
}
blk([[NSObject alloc] init]); blk([[NSObject alloc] init]);
blk([[NSObject alloc] init]);