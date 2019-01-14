+ (id) alloc
{
	return [self allocWithZone: NSDefaultMallocZone()]; 
}

+ (id) allocWithZone: (NSZone*)z
{
	return NSAllocateObject (self, 0, z); 
}